---
name: telegram-bot
description: Integração com Telegram Bot API usando python-telegram-bot e APScheduler. Use quando implementar notificações de estoque baixo, consolidador mensal, envio de mensagens, ou configurar o scheduler de tarefas. Antes de escrever qualquer código, carregue a skill tdd-ptbr e siga o ciclo Red-Green-Refactor.
---

# Telegram Bot + Scheduler — ControleEstoqueLashDesigner

## Quick Start

As notificações são enviadas de dois lugares:

1. **Backend** (`backend/app/services/notificacoes.py`): alerta de estoque baixo após venda.
2. **Scheduler** (`scheduler/app/notificacoes.py`): consolidador mensal no dia 1.

## Stack

- **python-telegram-bot** v20+ — `Application.builder().token().build()`
- **APScheduler** — `AsyncIOScheduler` com trigger `CronTrigger`
- Ambos usam `async` e compartilham `DATABASE_URL` para queries.

## Configuração

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    telegram_bot_token: str
    telegram_admin_chat_id: str      # chat_id da admin (Giovana) — backend
    telegram_pix_key: str            # chave PIX — scheduler

settings = Settings()
```

## Notificação de estoque baixo (Backend)

Disparada após `POST /api/vendas` quando o estoque **cruza** o limiar de 3.

```python
from telegram import Bot

async def notificar_estoque_baixo(nome_produto: str):
    bot = Bot(token=settings.telegram_bot_token)
    mensagem = f"Atenção Giovana o produto {nome_produto} está com o estoque baixo! Providencie a compra"
    await bot.send_message(chat_id=settings.telegram_admin_chat_id, text=mensagem)
```

**Regra de disparo**:
- Antes da venda: `quantidade > 3`
- Depois da venda: `quantidade <= 3`
- Se já estava ≤3 antes da venda, **não** dispara novamente (evita spam).

## Consolidador mensal (Scheduler)

Roda no dia 1 de cada mês às 08:00 BRT (`0 11 1 * *`).

```python
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger

scheduler = AsyncIOScheduler()
scheduler.add_job(consolidar_mensal, CronTrigger(hour=11, day=1))
scheduler.start()
```

### Lógica de consolidação

```python
async def consolidar_mensal():
    hoje = date.today()
    if hoje.month == 1:
        mes_anterior = 12
        ano_anterior = hoje.year - 1
    else:
        mes_anterior = hoje.month - 1
        ano_anterior = hoje.year

    # Buscar usuários ativos com telegram_chat_id
    usuarios = await buscar_usuarios_ativos_com_telegram()

    for usuario in usuarios:
        total = await somar_vendas_mes(usuario.nome, mes_anterior, ano_anterior)
        if total > 0:
            await enviar_mensagem_consolidado(usuario, total, mes_anterior)
```

### Mensagem do consolidador

Template exato (SDD.md seção 6.2):

```
Olá {NomeUsuario} o seu material do mês de {nomeMes} ficou em R$:{valor}.
Minha chave pix é: {chavePix}
```

- `nomeMes` por extenso em português: "Janeiro", "Fevereiro", ..., "Dezembro".
- `valor` formatado com 2 casas decimais.
- Só envia se `total > 0` e `usuario.telegram_chat_id` não for nulo.

## Variáveis de ambiente necessárias

| Variável                  | Serviço que usa        |
|---------------------------|------------------------|
| `TELEGRAM_BOT_TOKEN`      | Backend + Scheduler    |
| `TELEGRAM_ADMIN_CHAT_ID`  | Backend (alerta admin) |
| `TELEGRAM_PIX_KEY`        | Scheduler (chave PIX)  |
| `DATABASE_URL`            | Backend + Scheduler    |

## Cron do scheduler

| Campo | Valor | Significado       |
|-------|-------|-------------------|
| hour  | 11    | 11:00 UTC         |
| day   | 1     | Dia 1 do mês      |
| Fuso  | UTC   | = 08:00 BRT       |

## Testes e TDD

### Ciclo TDD (obrigatório)

1. **Red:** escreva o teste que falha
2. **Green:** escreva o código mínimo que faz o teste passar
3. **Refactor:** melhore o código mantendo os testes verdes

### Localização

```
tests/scheduler/
├── conftest.py                    # Fixtures (db session, mock bot)
├── test_notificacoes.py           # Testes do consolidador mensal
└── test_estoque_baixo.py          # Testes da notificação de estoque
```

### Padrões de teste

**Teste de notificação de estoque (mock de Bot):**
```python
from unittest.mock import AsyncMock, patch
import pytest

@pytest.mark.asyncio
async def test_notificar_estoque_baixo_envia_mensagem():
    with patch("app.services.notificacoes.Bot") as MockBot:
        mock_bot = AsyncMock()
        MockBot.return_value = mock_bot
        await notificar_estoque_baixo("Produto X")
        mock_bot.send_message.assert_called_once()
        call_args = mock_bot.send_message.call_args
        assert "estoque baixo" in call_args.kwargs["text"].lower()

@pytest.mark.asyncio
async def test_notificar_estoque_baixo_usa_chat_id_correto():
    with patch("app.services.notificacoes.Bot") as MockBot:
        mock_bot = AsyncMock()
        MockBot.return_value = mock_bot
        await notificar_estoque_baixo("Produto X")
        assert call_args.kwargs["chat_id"] == settings.telegram_admin_chat_id
```

**Teste de consolidador mensal:**
```python
from unittest.mock import AsyncMock, patch
from datetime import date

@pytest.mark.asyncio
async def test_consolidar_mensal_envia_para_usuarios_ativos():
    with patch("app.notificacoes.enviar_mensagem_consolidado") as mock_enviar, \
         patch("app.notificacoes.somar_vendas_mes", return_value=150.00):
        await consolidar_mensal()
        mock_enviar.assert_called_once()

@pytest.mark.asyncio
async def test_consolidar_mensal_nao_envia_para_total_zero():
    with patch("app.notificacoes.enviar_mensagem_consolidado") as mock_enviar, \
         patch("app.notificacoes.somar_vendas_mes", return_value=0):
        await consolidar_mensal()
        mock_enviar.assert_not_called()

@pytest.mark.asyncio
async def test_consolidar_mensal_nao_envia_para_usuario_sem_chat_id():
    with patch("app.notificacoes.enviar_mensagem_consolidado") as mock_enviar, \
         patch("app.notificacoes.buscar_usuarios_ativos_com_telegram", return_value=[]):
        await consolidar_mensal()
        mock_enviar.assert_not_called()
```

### Fixtures (conftest.py)

```python
import pytest
from unittest.mock import AsyncMock

@pytest.fixture
def mock_bot():
    with patch("app.services.notificacoes.Bot") as MockBot:
        mock_bot = AsyncMock()
        MockBot.return_value = mock_bot
        yield mock_bot

@pytest.fixture
def dados_usuario():
    return {
        "nome": "Usuário Teste",
        "telegram_chat_id": "123456789",
        "situacao": "ativa"
    }
```

### Comandos

```bash
# Rodar testes do scheduler
docker compose exec scheduler pytest

# Rodar com cobertura
docker compose exec scheduler pytest --cov=app --cov-report=term-missing
```

### Convenções de teste

- Todo `notificacoes.py` deve ter `test_notificacoes.py` correspondente
- Mockar `Bot.send_message` em todos os testes de notificação
- Mockar queries de DB em testes unitários do scheduler
- Verificar: mensagem enviada, chat_id correto, template do SDD.md respeitado
- Testar cenários: envio ok, total zero, usuário sem chat_id, mês de janeiro (edge case)

## Convenções

- Use `python-telegram-bot` v20+ (sintaxe async com `Application` e `Bot`).
- Mensagens de notificação em **português brasileiro**, templates exatos do SDD.md.
- O `telegram_chat_id` é opcional no cadastro de usuário — sem ele, o usuário não recebe consolidador.
- O scheduler usa `AsyncIOScheduler` (não `BackgroundScheduler`) para compatibilidade com async.
- Não hardcodar tokens ou chat_ids — sempre usar `settings` (pydantic-settings).
