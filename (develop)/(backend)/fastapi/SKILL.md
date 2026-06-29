---
name: fastapi
description: Desenvolvimento backend com Python 3.12, FastAPI, SQLAlchemy 2.0 async, Alembic e Pydantic v2. Use quando implementar rotas, modelos ORM, schemas, serviços, migrations, ou configurar o servidor ASGI. Também use para revisar código Python do backend ou scheduler. Antes de escrever qualquer código, carregue a skill tdd-ptbr e siga o ciclo Red-Green-Refactor.
---

# FastAPI Backend — ControleEstoqueLashDesigner

## Quick Start

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
alembic revision --autogenerate -m "descricao"
alembic upgrade head
```

## Stack

- **Python 3.12** com tipagem completa
- **FastAPI** — rotas `async def`, dependency injection, CORS middleware
- **SQLAlchemy 2.0** — engine assíncrono (`create_async_engine`), `async_sessionmaker`, `select()` style
- **Alembic** — migrations autogeradas
- **Pydantic v2** — `BaseModel`, `Field()`, `model_validate`, `model_dump`
- **Uvicorn** — servidor ASGI

## Estrutura

```
backend/app/
├── main.py              # FastAPI(), lifespan, CORS, app.include_router()
├── config.py            # Settings(BaseSettings) com DATABASE_URL, TELEGRAM_*
├── database.py          # create_async_engine, async_sessionmaker, get_db dependency
├── models/              # SQLAlchemy ORM (DeclarativeBase)
├── schemas/             # Pydantic v2
├── routes/              # APIRouter(prefix="/api/...")
└── services/            # telegram.py, notificacoes.py
```

## Padrões de código

### Config (pydantic-settings)

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    telegram_bot_token: str
    telegram_admin_chat_id: str
    telegram_pix_key: str

    model_config = SettingsConfigDict(env_file=".env")

settings = Settings()
```

### Database (SQLAlchemy async)

```python
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

engine = create_async_engine(settings.database_url, echo=False)
async_session = async_sessionmaker(engine, expire_on_commit=False)

async def get_db() -> AsyncSession:
    async with async_session() as session:
        yield session
```

### Models (ORM)

```python
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

class Base(DeclarativeBase):
    pass

class Produto(Base):
    __tablename__ = "produtos"
    nome: Mapped[str] = mapped_column(String(255), primary_key=True)  # PK natural!
    preco: Mapped[Decimal] = mapped_column(Numeric(10,2))
    quantidade: Mapped[int] = mapped_column(Integer, default=0)
```

### Schemas (Pydantic v2)

```python
from pydantic import BaseModel, Field
from decimal import Decimal
from datetime import date, datetime

class ProdutoCreate(BaseModel):
    nome: str
    preco: Decimal
    quantidade: int = 0

class ProdutoResponse(BaseModel):
    nome: str
    preco: Decimal
    quantidade: int
    model_config = ConfigDict(from_attributes=True)

class VendaCreate(BaseModel):
    nome_produto: str
    nome_usuario: str
    data_compra: date = Field(default_factory=date.today)
    quantidade_comprada: int = Field(gt=0)
    # preco_pago NUNCA está aqui — calculado pelo servidor
```

### Routes (APIRouter)

```python
from fastapi import APIRouter, Depends, HTTPException

router = APIRouter(prefix="/api/produtos", tags=["produtos"])

@router.get("/", response_model=list[ProdutoResponse])
async def listar(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Produto).order_by(Produto.nome))
    return result.scalars().all()

@router.post("/", response_model=ProdutoResponse, status_code=201)
async def criar(body: ProdutoCreate, db: AsyncSession = Depends(get_db)):
    ...
```

## Regras de negócio críticas

### POST /api/vendas — transação atômica

```python
@router.post("/", response_model=VendaResponse, status_code=201)
async def criar_venda(body: VendaCreate, db: AsyncSession = Depends(get_db)):
    async with db.begin():  # transação atômica
        produto = await db.get(Produto, body.nome_produto)
        if not produto:
            raise HTTPException(404, "Produto não encontrado")
        if produto.quantidade < body.quantidade_comprada:
            raise HTTPException(400, "Estoque insuficiente")

        quantidade_antes = produto.quantidade
        preco_pago = body.quantidade_comprada * produto.preco
        produto.quantidade -= body.quantidade_comprada

        venda = Venda(
            nome_produto=body.nome_produto,
            nome_usuario=body.nome_usuario,
            data_compra=body.data_compra,
            quantidade_comprada=body.quantidade_comprada,
            preco_pago=preco_pago
        )
        db.add(venda)
        await db.flush()
        await db.refresh(venda)

    # Fora da transação: notificação de estoque baixo
    if quantidade_antes > 3 and produto.quantidade <= 3:
        await notificar_estoque_baixo(produto.nome)

    return venda
```

### Alerta de estoque — histerese

A notificação só dispara se `quantidade_antes > 3` **e** `quantidade_depois <= 3`. Isso evita spam em vendas consecutivas abaixo do limiar.

### Consolidador mensal

Trigger: `0 11 1 * *` (UTC, = 08:00 BRT). Processa mês anterior. Envia para usuários `situacao='ativa'` com `telegram_chat_id` preenchido e `total > 0`.

## Convenções

- Use `Decimal` para dinheiro, **nunca** `float`.
- Todas as rotas são `async def`.
- Use `select()` style do SQLAlchemy 2.0, não `session.query()`.
- Schemas Pydantic usam `model_config = ConfigDict(from_attributes=True)` para compatibilidade ORM.
- Migrations Alembic são autogeradas (`--autogenerate`) a partir dos modelos.
- Mensagens de erro e notificações em **português brasileiro**.
- CORS middleware permite origins de desenvolvimento e produção.

## Testes e TDD

### Localização

```
tests/backend/
├── conftest.py           # Fixtures compartilhadas (db session, client, dados de teste)
├── test_models/          # Testes de models SQLAlchemy
├── test_schemas/         # Testes de validação Pydantic
├── test_services/        # Testes de lógica de negócio
├── test_routes/          # Testes de rotas API (integração)
└── test_repositories/    # Testes de queries
```

### Ciclo TDD (obrigatório)

1. **Red:** escreva o teste que falha
2. **Green:** escreva o código mínimo que faz o teste passar
3. **Refactor:** melhore o código mantendo os testes verdes

### Padrões de teste

**Teste de schema (unitário):**
```python
from pydantic import ValidationError
from app.schemas.despesa import DespesaCreate

def test_despesa_create_campos_obrigatorios():
    with pytest.raises(ValidationError):
        DespesaCreate()

def test_despesa_create_valor_negativo():
    with pytest.raises(ValidationError):
        DespesaCreate(valor=-10, categoria_id=1, descricao="teste")
```

**Teste de rota (integração com DB):**
```python
from httpx import AsyncClient

async def test_criar_categoria_sucesso(client: AsyncClient):
    response = await client.post("/api/categorias", json={"nome": "Alimentação", "cor": "#FF0000"})
    assert response.status_code == 201
    assert response.json()["nome"] == "Alimentação"

async def test_criar_categoria_nome_duplicado(client: AsyncClient):
    await client.post("/api/categorias", json={"nome": "Alimentação", "cor": "#FF0000"})
    response = await client.post("/api/categorias", json={"nome": "Alimentação", "cor": "#00FF00"})
    assert response.status_code == 409
```

**Teste de service (unitário com mock de DB):**
```python
from unittest.mock import AsyncMock, patch

async def test_notificar_estoque_baixo_envia_mensagem():
    with patch("app.services.notificacoes.Bot") as MockBot:
        mock_bot = AsyncMock()
        MockBot.return_value = mock_bot
        await notificar_estoque_baixo("Produto X")
        mock_bot.send_message.assert_called_once()
```

### Fixtures (conftest.py)

```python
import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker

@pytest.fixture
async def client():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac

@pytest.fixture
async def db_session():
    engine = create_async_engine("sqlite+aiosqlite:///:memory:")
    async_session = async_sessionmaker(engine)
    async with async_session() as session:
        yield session
```

### Comandos

```bash
# Rodar todos os testes
docker compose exec backend pytest

# Rodar com cobertura
docker compose exec backend pytest --cov=app --cov-report=term-missing

# Rodar teste específico
docker compose exec backend pytest test_routes/test_categorias.py -v
```

### Convenções de teste

- Todo `routes/*.py` deve ter `test_routes/test_*.py` correspondente
- Todo `services/*.py` deve ter `test_services/test_*.py` correspondente
- Todo `schemas/*.py` deve ter `test_schemas/test_*.py` correspondente
- Fixtures de dados (categorias, usuários) ficam em `conftest.py`
- Nunca usar `float` em dados de teste monetários — sempre `Decimal`
- Mockar serviços externos (Telegram) em testes unitários
- Usar `pytest-asyncio` para testes assíncronos
