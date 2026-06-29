---
name: gherkin-e2e
description: 'QA — Gera cenários E2E em Gherkin e valida features concluídas (testes, cobertura, sintaxe). Use quando o usuário pedir para criar testes E2E, gerar cenários Gherkin, escrever testes de aceitação, criar feature files, ou disser "testes e2e", "cenários", "gherkin", "given when then", "critérios de aceite". Use também quando uma spec estiver aprovada e precisar de validação. Obrigatório invocar ao final de cada feature implementada para validar cenários existentes, rodar BDD, checar sintaxe e reportar cobertura contra a spec — dispare com "validar feature", "QA check", "rodar cenários BDD", "validar testes da feature", "conferir cobertura", "feature concluída", "validar implementação". Nunca pule a validação QA de uma feature concluída.'
---

# Gherkin E2E — QA Agent (Geração + Validação)

## Modos de Operação

Esta skill opera em dois modos. **Sempre determine o modo antes de agir.**

### Modo A — Gerar novos cenários
Quando o usuário pede para **criar** cenários ou a feature ainda não tem `.feature`. Siga [Workflow — Gerar Cenários](#workflow--gerar-cenários).

### Modo B — Validar feature concluída
**Este modo é obrigatório ao final de cada feature implementada.** Quando uma feature está com código pronto ou o usuário diz "validar feature X", siga [Workflow — Validar Feature Concluída](#workflow--validar-feature-concluída).

---

## Workflow — Gerar Cenários

### Etapa 1 — Entrevista Adaptativa

Leia a spec da feature (se existir em `docs/features/`) como contexto inicial. Em seguida, conduza a entrevista:

**Perguntas-base** (fazer todas):
1. Quais ações o usuário pode realizar nesta feature?
2. Quais regras de negócio validam essas ações?
3. Quais cenários de erro existem?
4. Quais dados precisam existir antes de cada cenário?

**Perguntas de follow-up** (adapte conforme respostas):
- Se usuário menciona validação → *"Quais são os limites? (mínimo, máximo, obrigatório)"*
- Se usuário menciona estado → *"O que acontece se os dados iniciais não existirem?"*
- Se usuário menciona integração → *"Quais outras features são dependências?"*
- Se usuário menciona feedback → *"Qual é a mensagem exata de sucesso/erro?"*
- Se usuário menciona UX → *"Há confirmação antes de ações destrutivas?"*

**Regra:** não invente cenários. Se o usuário não mencionou algo, pergunte. Se não souber, registre como `@pending` e siga em frente.

Para perguntas adaptativas detalhadas, veja [references/interview-prompts.md](references/interview-prompts.md).

### Etapa 2 — Estruturar os Cenários

Organize os cenários nesta ordem:

1. **Happy path** — cenário principal de sucesso
2. **Validações** — cada regra de negócio = um cenário
3. **Edge cases** — limites, vazios, duplicados
4. **Erros** — falhas esperadas, mensagens de erro
5. **Integração** — cenários que dependem de outras features

Para cada cenário, defina:
- **Título claro** em português (ex: "Cadastrar categoria com nome válido")
- **Given** — estado inicial (dados, pré-condições)
- **When** — ação do usuário
- **Then** — resultado esperado (estado, mensagem, UI)

### Etapa 3 — Gerar o Arquivo `.feature`

**Localização:** `tests/features/{feature-name}/`

**Naming:** `{acao}-{entidade}.feature` (ex: `CRUD-categorias.feature`, `alerta-orcamento.feature`)

**Convenções:**
- Todos os textos em **português brasileiro**
- Tag `@wip` nos cenários em desenvolvimento
- Usar `Scenario Outline` + `Examples` quando houver variação de dados
- Background para pré-condições compartilhadas (máx. 3 passos)
- Dados de exemplo em tabela quando aplicável

Para syntax Gherkin completa, veja [references/gherkin-syntax.md](references/gherkin-syntax.md).

Para exemplos reais, veja [references/examples/](references/examples/).

### Etapa 4 — Validar Sintaxe

Execute o script de validação:

```bash
python3 .agents/skills/gherkin-e2e/scripts/validate-feature.py tests/features/{feature-name}/{arquivo}.feature
```

O script verifica:
- Sintaxe Gherkin (Given/When/Then/And/But)
- Tags presentes
- Linguagem PT-BR (sem termos em inglês nos passos)
- Estrutura consistente

Se houver erros, corrija antes de entregar ao usuário.

### Etapa 5 — Criar Step Definitions

Crie `tests/features/{feature-name}/test_*.py` com step definitions em Python usando `pytest-bdd`. Use `parsers.parse()` para capturar parâmetros dos passos Gherkin. Garanta que há um `conftest.py` que ajusta o `sys.path` e importa fixtures compartilhadas.

### Formato de Entrega (Modo A)

Ao final, entregue ao usuário:
1. Arquivo(s) `.feature` criado(s)
2. Arquivo(s) `test_*.py` com step definitions
3. Resumo dos cenários gerados (quantidade, cobertura)
4. Perguntas pendentes (se houver cenários marcados `@pending`)
5. Confirmação de que a validação de sintaxe passou

---

## Workflow — Validar Feature Concluída

**Este workflow é obrigatório ao final de cada feature implementada.** Se uma feature foi marcada como "concluída" ou "implementada" em `docs/tasks.md`, este workflow DEVE ser executado antes de considerar a feature realmente finalizada.

### Etapa V1 — Localizar Artefatos

1. Leia `docs/features/{NNN}-{slug}/spec.md` para obter os critérios de aceite
2. Leia `docs/features/{NNN}-{slug}/tasks.md` para verificar o status das tarefas
3. Liste os arquivos `.feature` existentes em `tests/features/{NNN}-{slug}/`
4. Liste os arquivos `test_*.py` correspondentes

### Etapa V2 — Validar Sintaxe de Todos os `.feature`

Para cada arquivo `.feature` encontrado:

```bash
python3 .agents/skills/gherkin-e2e/scripts/validate-feature.py tests/features/{feature-name}/{arquivo}.feature
```

Corrija qualquer erro de sintaxe encontrado.

### Etapa V3 — Executar Testes BDD

Execute os testes BDD da feature:

```bash
python3 -m pytest tests/features/{feature-name}/ -v --tb=short
```

Se houver falhas:
- Analise o erro (step definition faltando? regressão?)
- Corrija o código ou o step definition
- Re-execute até todos passarem

Se houver cenários marcados `@wip` ou `@pending`, reporte ao usuário.

### Etapa V4 — Verificar Cobertura Contra a Spec

Cruze os cenários BDD com os critérios de aceite da `spec.md`. Para cada critério de aceite da spec, verifique se existe pelo menos um cenário BDD que o cubra.

Produza uma tabela de cobertura:

| Critério de Aceite (spec.md) | Cenário BDD correspondente | Status |
|------------------------------|---------------------------|--------|
| Criar ativo com sucesso | `Criar ativo com sucesso` | ✅ coberto |
| Venda sem saldo rejeitada | `Venda sem saldo (Unhappy Path)` | ✅ coberto |
| ... | — | ❌ descoberto |

Se houver critérios descobertos, **adicione cenários BDD** para cobri-los (use o Modo A, Etapas 2-5, sem entrevista — os critérios de aceite da spec já são o insumo).

### Etapa V5 — Executar Testes Unitários da Feature

Além dos testes BDD, execute os testes unitários relacionados à feature:

```bash
python3 -m pytest services/common/tests/ services/api/tests/ services/scheduler/tests/ services/telegram/tests/ -v --tb=short -k "investimento"  # ajuste o filtro para a feature
```

Se houver falhas, corrija antes de prosseguir.

### Etapa V6 — Relatório Final de QA

Produza um relatório resumido:

```
📋 Relatório QA — Feature {NNN}-{slug}
=======================================

✅ Sintaxe Gherkin: {N} arquivo(s) validado(s) sem erros
✅ Testes BDD: {X}/{Y} cenários passando
✅ Testes unitários: {A} passando
📊 Cobertura da spec: {B}/{C} critérios de aceite cobertos ({(B/C*100):.0f}%)

Pendências:
- (listar cenários @wip/@pending se houver)
- (listar critérios descobertos se houver)

Conclusão: {APROVADA / REPROVADA — CORRIGIR PENDÊNCIAS}
```

Se houver pendências, corrija-as ANTES de marcar a feature como concluída.

---

## Regra de Integração com AGENTS.md

O workflow de desenvolvimento (`AGENTS.md`, seção "Regra obrigatória") determina que:

> Ao final da implementação de cada feature, o agente QA (`gherkin-e2e`, Modo B — Validar Feature Concluída) DEVE ser invocado.

O agente que estiver implementando a feature deve, após terminar o código:
1. Acionar esta skill com o prompt: `validar feature {NNN}-{slug}`
2. Resolver todas as pendências reportadas pelo QA
3. Só então marcar a feature como concluída em `docs/tasks.md`

**Nenhuma feature é considerada concluída sem o relatório QA aprovado.**

## Referências

- [Syntax Gherkin](references/gherkin-syntax.md) — syntax completa com exemplos
- [Perguntas da Entrevista](references/interview-prompts.md) — roteiro adaptativo detalhado
- [Exemplos](references/examples/) — features reais do projeto
