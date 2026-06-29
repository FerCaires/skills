# Templates de Meta-docs

> Use estes templates ao gerar `AGENTS.md`, `docs/workflow.md` e `README.md`. Substitua os placeholders `{entre-chaves}` pelos valores fechados na entrevista.

## Tabela de conteúdo

1. [AGENTS.md](#agentsmd)
2. [docs/workflow.md](#docsworkflowmd)
3. [README.md](#readmemd)

---

## AGENTS.md

```markdown
# AGENTS.md — {project}

> Regras e contexto para agentes de IA que atuam neste repo. **Leia antes de qualquer ação.**

## Descrição

{1–2 parágrafos do problema de negócio e do que o projeto faz. Preencher a partir da dimensão 1 da entrevista.}

## Stack

- **Tipo:** {backend puro / frontend puro / monorepo fullstack / jogo / lib / docs}
- **Runtime:** {Python 3.12 / Node 20 / Go 1.22 / Rust stable / Java 21 / Ruby 3.3}
- **Framework:** {FastAPI / NestJS / Echo / Axum / Spring Boot / Rails}
- **Banco:** {PostgreSQL 16 / SQLite / MongoDB / sem DB}
- **ORM/driver:** {SQLAlchemy 2.0 async / Prisma / GORM / Hibernate / ActiveRecord}
- **Container:** {Docker Compose / Dockerfile single / sem container}
- **CI:** {GitHub Actions / GitLab CI / sem CI ainda}
- **Testes:** {pytest / Vitest / go test / JUnit / RSpec}
- **Lint/format:** {ruff + black / eslint + prettier / gofmt + golangci-lint}
- **Locale:** {pt-BR / en / multi}

## Comandos

| Ação | Comando |
|------|---------|
| Instalar deps | `{poetry install / npm install / go mod download / cargo build}` |
| Rodar em dev | `{uvicorn {pkg}.main:app --reload / npm run dev / go run ./cmd/{project} / cargo run}` |
| Build | `{poetry build / npm run build / go build ./... / cargo build --release}` |
| Testar | `{pytest / npm test / go test ./... / cargo test}` |
| Lint | `{ruff check . / npm run lint / golangci-lint run}` |
| Format | `{black . / npm run format / gofmt -w .}` |

## Estrutura de pastas

```
{colar a árvore do esqueleto gerado, conforme references/stacks.md}
```

## Skills disponíveis

Copiadas de `https://github.com/FerCaires/skills` para `.devin/`:

### Skills (`.devin/skills/`)

| Skill | Quando usar |
|-------|-------------|
| {nome} | {descrição curta da trigger} |
| ... | ... |

### Agentes (`.devin/agents/`)

| Agente | Quando usar |
|--------|-------------|
| {nome} | {descrição curta da trigger} |
| ... | ... |

> Skills novas específicas deste projeto devem ser criadas em `.devin/skills/` via skill `write-a-skill`.

## Workflow

O fluxo de trabalho está em **[`docs/workflow.md`](docs/workflow.md)**. Resumo:

```
intake → pm → tech-lead → devs → qa → aprendizados
```

Nenhuma feature é implementada sem spec aprovada e design aprovado.

## Convenções

- **Commits:** Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`).
- **Branches:** trunk-based — `main` + feature branches curtas (`feat/{slug}`, `fix/{slug}`).
- **PRs:** exigem review + CI verde.
- **Code style:** {tabs/espaços}, {aspas}, {line-length}.
- **UI/mensagens:** {pt-BR / en}.
- **Env vars:** sempre via `.env` (em `.gitignore`); exemplo em `.env.example`.

## Regras de ouro

1. **Leia `AGENTS.md` antes de agir.**
2. **Siga o workflow** — nada de pular spec/design.
3. **TDD obrigatório** em toda task de dev (skill `tdd-ptbr`).
4. **Atualize `docs/tasks.md`** ao concluir etapa (PM/dev/QA).
5. **Não commite secrets** — `.env` fora do git.
```

---

## docs/workflow.md

```markdown
# Workflow — {project}

> Fluxo padrão de uma demanda, do pedido bruto à validação. Adaptado ao tipo **{tipo}** e stack **{stack}**.

## Fluxograma

```
[usuário faz pedido]
        │
        ▼
   intake-ptbr            ← captura bruta em docs/prompts/{NNN}-{slug}.md
        │
        ▼
   pm-ptbr                ← entrevista de escopo → spec.md + tasks.md
        │                   em docs/features/{NNN}-{name}/
        ▼
   tech-lead-ptbr         ← entrevista técnica → design.md
        │                   (pular se lib/SDK)
        ▼
   ┌─────┴─────┐
   ▼           ▼
 {dev-backend}  {dev-frontend}   ← cada um carrega tdd-ptbr + skill técnica
   │           │                  ({fastapi / postgresql / docker /
   │           │                   angular-material / frontend-design})
   └─────┬─────┘
        ▼
   qa-ptbr + gherkin-e2e  ← validação contra spec + cenários BDD
        │
        ▼
   aprendizados           ← registrar lições para próximas features
```

{Se jogo web, substituir o fluxo por:
```
roguelike-gdd → phaser3-impl   (feature por feature, via docs/GDD.md)
```
}

{Se lib/SDK, simplificar:
```
intake-ptbr → dev (tdd-ptbr) → qa-ptbr → aprendizados
```
}

## Gates de aprovação

| Gate | Quem aprova | Artefato |
|------|-------------|----------|
| Spec | usuário | `docs/features/{NNN}-{name}/spec.md` |
| Design | Tech Lead | `docs/features/{NNN}-{name}/design.md` |
| Implementação | QA | `docs/features/{NNN}-{name}/tasks.md` (status `validado`) |

**Nenhum código é escrito antes dos dois primeiros gates** (exceto libs, que pulam o gate de design).

## Estados

- **Feature:** `planejado` → `spec_aprovado` → `design_concluido` → `design_aprovado` → `em_andamento` → `concluido`
- **Tarefa:** `pendente` → `em_andamento` → `concluido` → `validado` | `bloqueado`

## Arquivos-canônico

- **SDD.md** — fonte da verdade técnica (arquitetura, stack, regras de negócio cross-feature). Criar/atualizar conforme features são implementadas.
- **docs/tasks.md** — agregador global de tarefas (recovery).
- **docs/features/{NNN}-{name}/** — pasta por feature com `spec.md`, `design.md`, `tasks.md`.
- **docs/prompts/{NNN}-{slug}.md** — intake bruto de cada demanda.
- **docs/aprendizados.md** — lições aprendidas acumuladas.
- **AGENTS.md** — regras e contexto para agentes (ler sempre).

## Ownership das atualizações

| Quem | Atualiza |
|------|----------|
| PM | `spec.md`, `tasks.md` da feature, agregador `docs/tasks.md` |
| Tech Lead | `design.md`, `SDD.md` quando arquitetura muda |
| Dev | `tasks.md` (status), código, testes |
| QA | `tasks.md` (status `validado`), `docs/aprendizados.md` |
| Qualquer um | `AGENTS.md` via PR se convenção mudar |
```

---

## README.md

```markdown
# {project}

{1 parágrafo: o que é, qual problema resolve.}

## Stack

{lista bullet da stack, igual ao AGENTS.md mas resumida.}

## Como rodar

### Pré-requisitos

- {Python 3.12+ / Node 20+ / Go 1.22+ / ...}
- {Docker + Docker Compose, se aplicável}

### Setup

```bash
{comando de install}
cp .env.example .env   # ajustar valores
{comando de migrate, se DB}
```

### Desenvolvimento

```bash
{comando de dev}
```

### Testes

```bash
{comando de test}
```

## Documentação

- [`AGENTS.md`](AGENTS.md) — regras e contexto para agentes de IA.
- [`docs/workflow.md`](docs/workflow.md) — fluxo de uma demanda, do pedido à validação.
- `docs/features/` — specs e designs por feature (criados pelo `pm-ptbr`).
- `docs/aprendizados.md` — lições aprendidas (criado pelo `aprendizados`).

## Skills e agentes

Ver catálogo em `.devin/skills/` e `.devin/agents/`. Skills copiadas de `https://github.com/FerCaires/skills`.

## Convenções

- Commits: Conventional Commits.
- Branches: trunk-based.
- Workflow: ver `docs/workflow.md`.

## Licença

{MIT / Apache-2.0 / proprietário / a definir}
```
