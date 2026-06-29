# Roteiro de Entrevista — Scaffold

> Use este roteiro **uma dimensão por vez**. Leia a seção da dimensão atual, faça a primeira pergunta-cravada, espere a resposta, aplique o Framework de Clarificação e avance. Máximo 15 perguntas no total — pare antes se não houver mais dúvida material.

## Tabela de conteúdo

1. [Tipo de projeto](#1-tipo-de-projeto)
2. [Stack principal](#2-stack-principal)
3. [Estrutura (monorepo vs polyrepo)](#3-estrutura-monorepo-vs-polyrepo)
4. [Banco de dados](#4-banco-de-dados)
5. [Integrações externas](#5-integrações-externas)
6. [Container/orquestração](#6-containerorquestração)
7. [CI/CD](#7-cicd)
8. [Testes](#8-testes)
9. [Lint/format](#9-lintformat)
10. [Observabilidade](#10-observabilidade)
11. [Convenções](#11-convenções)
12. [Skills/agentes a copiar](#12-skillsagentes-a-copiar)

---

## 1. Tipo de projeto

**Pergunta-cravada:** qual o tipo e qual problema de negócio?

- A) **Backend puro** — API/serviço sem UI própria; frontend é consumidor externo. (Recomendado se o pedido mencionar "API", "serviço", "webhook".)
- B) **Frontend puro** — UI que consome API externa; sem backend próprio.
- C) **Monorepo fullstack** — backend + frontend no mesmo repo.
- D) **Jogo web** — frontend com engine de jogo (Phaser, etc.).
- E) **Lib/SDK** — biblioteca publicável, sem runtime próprio.
- F) **Docs-only** — documentação/static site.

**Aprofundamento (se necessário):**
- "Tem mais de um serviço backend? (ex: API + worker + scheduler)"
- "Há frontend admin e frontend público separados?"
- "É um produto, uma ferramenta interna, ou um experimento?"

---

## 2. Stack principal

**Pergunta-cravada:** qual a linguagem/framework central e a versão de runtime?

- A) **Python 3.12 + FastAPI** — async, OpenAPI nativo, ideal para APIs. (Recomendado se Python.)
- B) **Node 20 LTS + NestJS/Express/Fastify** — TypeScript first-class.
- C) **Go 1.22+** — binário único, baixo overhead.
- D) **Rust (stable) + Axum/Actix** — performance máxima.
- E) **Java 21 + Spring Boot 3** — enterprise, DI pesada.
- F) **Ruby 3.3 + Rails 7** — convenção sobre configuração.

**Aprofundamento:**
- "Versão específica do runtime? (importante para Dockerfile e CI matrix)"
- "ORM escolhido? (SQLAlchemy, Prisma, GORM, Hibernate, ActiveRecord)"
- "Async ou sync? (Python: async/await; Node: sempre async; Go: goroutines)"

---

## 3. Estrutura (monorepo vs polyrepo)

**Pergunta-cravada:** como organizar o código?

- A) **Polyrepo** — um repo por serviço/frontend. Simples, deploys independentes. (Recomendado se 1 serviço apenas.)
- B) **Monorepo com workspaces** — backend e frontend no mesmo repo, mas com `package.json` workspaces (Node) ou pastas `backend/`+`frontend/` separadas. (Recomendado se fullstack.)
- C) **Monorepo com turbo/nx** — task runner, cache de build, dep graph. Útil só se 3+ apps.

**Aprofundamento:**
- "Nomenclatura de pastas: `src/`, `backend/src/`, `apps/api/`?"
- "Shared code entre serviços? (types, schemas, utils)"
- "Cada app tem próprio Dockerfile ou um compose orquestra tudo?"

---

## 4. Banco de dados

**Pergunta-cravada:** qual o banco e como migrar?

- A) **PostgreSQL 16 + Alembic/Prisma Migrate** — relacional robusto, migrations versionadas. (Recomendado se relacional.)
- B) **SQLite** — dev/test local, sem servidor. Bom para libs e protótipos.
- C) **MongoDB** — documental, schema flexível.
- D) **Redis** — cache/fila, não BD primário.
- E) **Sem banco** — stateless, ou persistência externa.

**Aprofundamento:**
- "Versão específica do Postgres? (16, 15, 14)"
- "Migrations automáticas ou manuais? (Alembic auto vs SQL escrito)"
- "PKs naturais (ex: nome) ou surrogate (auto-increment/UUID)?"
- "Seed de dados para dev? (fixture, dump, script)"

---

## 5. Integrações externas

**Pergunta-cravada:** quais integrações externas o projeto terá?

- A) **Nenhuma no MVP** — scaffold deixa hook pronto mas sem implementação. (Recomendado se incerto.)
- B) **Telegram Bot API** — notificações/bot. (Copia `telegram-bot` skill.)
- C) **APIs REST de terceiros** — Stripe, SendGrid, etc.
- D) **Mensageria** — RabbitMQ/Kafka/SQS.
- E) **OAuth/SSO** — Google, GitHub, etc.

**Aprofundamento:**
- "Credenciais via env vars? Quais nomes?"
- "Tem sandbox/dev environment do provedor?"
- "Webhooks inbound? Precisam de assinatura/HMAC?"

---

## 6. Container/orquestração

**Pergunta-cravada:** como o projeto roda localmente e em prod?

- A) **Docker Compose** — `docker-compose.yml` com serviço(s) + DB. (Recomendado para maioria.)
- B) **Dockerfile single-stage** — só um serviço, sem compose.
- C) **Kubernetes/Helm** — deploy em k8s, charts Helm.
- D) **Sem container** — runtime direto (bun, python venv, go run). Válido para libs.

**Aprofundamento:**
- "Multi-stage build? (imagem final menor)"
- "Healthcheck no Dockerfile/compose?"
- "Volumes para DB e cache em dev?"

---

## 7. CI/CD

**Pergunta-cravada:** qual o pipeline de CI/CD?

- A) **GitHub Actions** — workflows em `.github/workflows/`. (Recomendado se GitHub.)
- B) **GitLab CI** — `.gitlab-ci.yml`.
- C) **Sem CI no scaffold** — manual por enquanto, adicionar depois.

**Aprofundamento:**
- "Matrix de versões? (ex: Python 3.11 + 3.12)"
- "Cache de deps? (actions/cache, pip cache, npm cache)"
- "Deploy automático em push na main ou manual?"

---

## 8. Testes

**Pergunta-cravada:** qual o framework e a estratégia de testes?

- A) **pytest + pytest-asyncio** (Python) / **Vitest/Jest** (Node) / **go test** (Go) — unit + integration. (Recomendado.)
- B) **Acrescentar Playwright/Cypress** para e2e se houver UI.
- C) **TDD obrigatório** — copia `tdd-ptbr` e referencia no `AGENTS.md`.

**Aprofundamento:**
- "Cobertura mínima? (ex: 80%)"
- "Testes de integração usam DB real (docker) ou mocked?"
- "Gherkin/BDD? (copia `gherkin-e2e`)"

---

## 9. Lint/format

**Pergunta-cravada:** quais ferramentas de lint/format?

- A) **ruff + black** (Python) / **eslint + prettier** (Node) / **gofmt + golangci-lint** (Go) — config no esqueleto. (Recomendado.)
- B) **Sem lint** — só format manual. (Não recomendado, aponte o risco.)

**Aprofundamento:**
- "Pre-commit hooks? (husky, pre-commit框架)"
- "Regras estritas ou warning-only?"

---

## 10. Observabilidade

**Pergunta-cravada:** como logs, métricas e alertas?

- A) **structlog/loguru** (Python) / **pino** (Node) — logs estruturados em JSON. (Recomendado.)
- B) **OpenTelemetry** — traces distribuídos.
- C) **Mínimo: print/console.log** — tudo bem para protótipo.

**Aprofundamento:**
- "Nível de log em dev vs prod? (DEBUG vs INFO)"
- "Alertas via Telegram/Slack? (relaciona com dimensão 5)"

---

## 11. Convenções

**Pergunta-cravada:** quais as convenções do projeto?

- A) **Conventional Commits** (`feat:`, `fix:`, `chore:`) — padrão de fato. (Recomendado.)
- B) **Gitmoji** — commits com emoji.
- C) **Branch model: trunk-based** (main + feature branches curtas). (Recomendado.)
- D) **Git Flow** (develop + release branches).

**Aprofundamento:**
- "Locale da UI e mensagens? (pt-BR, en, multi-idioma)"
- "Code style: tabs ou espaços? Aspas simples ou duplas?"
- "PRs exigem review? Quantos aprovadores?"

---

## 12. Skills/agentes a copiar

**Pergunta-cravada:** quais skills/agentes copiar do `https://github.com/FerCaires/skills`?

Apresente a **lista pré-montada** baseada no tipo+stack decididos (use `references/skills-catalog.md` para montar) e pergunte se o usuário quer adicionar/remover.

**Listas-base por tipo:**

### Backend puro (Python/FastAPI)
- `(figuras)/pm-ptbr` — planejar features
- `(figuras)/tech-lead-ptbr` — design técnico
- `(documentacao)/intake-ptbr` — capturar demandas
- `(documentacao)/aprendizados` — lições aprendidas
- `(documentacao)/grill-me` — entrevistas implacáveis
- `(documentacao)/gherkin-e2e` — BDD
- `(develop)/(backend)/fastapi` — implementar FastAPI
- `(develop)/(backend)/postgresql` — Postgres/Alembic (se DB relacional)
- `(develop)/(backend)/docker` — Docker/compose
- `(testes)/tdd-ptbr` — TDD obrigatório
- `(agentes)/senior-dev-python.md` — dev Python
- `(agentes)/qa-ptbr.md` — QA

### Frontend puro (Angular)
- `(figuras)/pm-ptbr`, `(figuras)/tech-lead-ptbr`
- `(documentacao)/intake-ptbr`, `(documentacao)/aprendizados`, `(documentacao)/grill-me`, `(documentacao)/gherkin-e2e`
- `(develop)/(frontend)/angular-material` — implementar Angular
- `(develop)/(frontend)/frontend-design` — design quality
- `(testes)/tdd-ptbr`
- `(agentes)/senior-dev-angular.md`, `(agentes)/qa-ptbr.md`

### Monorepo fullstack (Python + Angular)
- União das duas listas acima.

### Jogo web (Phaser)
- `(figuras)/roguelike-gdd` — Game Designer
- `(develop)/(frontend)/phaser3-impl` — implementar Phaser
- `(documentacao)/intake-ptbr`, `(documentacao)/aprendizados`
- `(testes)/tdd-ptbr`

### Lib/SDK
- `(documentacao)/intake-ptbr`, `(documentacao)/aprendizados`
- `(testes)/tdd-ptbr`
- Sem `pm-ptbr`/`tech-lead-ptbr` (lib não tem features no sentido de produto).

### Docs-only
- Apenas `(documentacao)/write-a-skill` se for repo de skills.

**Sempre copiar:**
- `(documentacao)/write-a-skill` — para o usuário poder criar novas skills específicas do projeto depois.

**Aprofundamento:**
- "Quer `grill-with-docs` além do `grill-me`? (desafia plano contra modelo de domínio)"
- "Alguma skill específica do domínio que não está no catálogo? (registra lacuna no AGENTS.md)"
