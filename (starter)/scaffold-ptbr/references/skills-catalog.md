# Catálogo de Skills Copiáveis

> Fonte: `https://github.com/FerCaires/skills`. Copie via `scripts/copy-skills.sh`. Seleção por tipo de projeto no fim do arquivo.

## Tabela de conteúdo

1. [Figuras (personas/orquestradores)](#figuras-personasorquestradores)
2. [Documentação e Processo](#documentação-e-processo)
3. [Desenvolvimento — Backend](#desenvolvimento--backend)
4. [Desenvolvimento — Frontend](#desenvolvimento--frontend)
5. [Testes](#testes)
6. [Agentes (subagentes)](#agentes-subagentes)
7. [Seleção por tipo de projeto](#seleção-por-tipo-de-projeto)

---

## Figuras (personas/orquestradores)

Vivem em `(figuras)/`. Conduzem entrevistas estruturadas.

| Skill | Caminho no repo | Quando usar |
|-------|-----------------|-------------|
| **pm-ptbr** | `(figuras)/pm-ptbr` | Planejar nova feature: entrevista de escopo, spec.md + tasks.md, agregador `docs/tasks.md`. |
| **tech-lead-ptbr** | `(figuras)/tech-lead-ptbr` | Gerar design técnico (`design.md`) a partir de spec aprovada. |
| **roguelike-gdd** | `(figuras)/roguelike-gdd` | Game Designer para jogos roguelike: entrevista exaustiva, GDD, contratos de feature. |

## Documentação e Processo

Vivem em `(documentacao)/`.

| Skill | Caminho no repo | Quando usar |
|-------|-----------------|-------------|
| **intake-ptbr** | `(documentacao)/intake-ptbr` | Capturar pedido bruto em `docs/prompts/{NNN}-{slug}.md` antes do PM. |
| **aprendizados** | `(documentacao)/aprendizados` | Extrair/documentar lições em `docs/aprendizados.md`. |
| **gherkin-e2e** | `(documentacao)/gherkin-e2e` | Cenários E2E em Gherkin (`.feature`) + validação BDD. |
| **grill-me** | `(documentacao)/grill-me` | Entrevistar implacavelmente sobre plano/design até entendimento compartilhado. |
| **grill-with-docs** | `(documentacao)/grill-with-docs` | Variante do `grill-me` que desafia contra modelo de domínio existente, atualiza `CONTEXT.md`/ADRs. |
| **write-a-skill** | `(documentacao)/write-a-skill` | Criar/revisar skills. **Copiar sempre** — permite ao usuário criar skills específicas do projeto. |

## Desenvolvimento — Backend

Vivem em `(develop)/(backend)/`. Todas exigem `tdd-ptbr` carregada antes de escrever código.

| Skill | Caminho no repo | Quando usar |
|-------|-----------------|-------------|
| **fastapi** | `(develop)/(backend)/fastapi` | Implementar rotas, modelos, schemas, serviços, migrations no backend Python 3.12 + FastAPI + SQLAlchemy 2.0 async + Alembic + Pydantic v2. |
| **postgresql** | `(develop)/(backend)/postgresql` | Modelagem e migrações PostgreSQL 16: tabelas, índices, constraints, init.sql. |
| **telegram-bot** | `(develop)/(backend)/telegram-bot` | Telegram Bot API + APScheduler: notificações, consolidador, scheduler. |
| **docker** | `(develop)/(backend)/docker` | Infraestrutura Docker: compose, Dockerfiles multi-stage, healthchecks, volumes. |

## Desenvolvimento — Frontend

Vivem em `(develop)/(frontend)/`.

| Skill | Caminho no repo | Quando usar |
|-------|-----------------|-------------|
| **angular-material** | `(develop)/(frontend)/angular-material` | Angular 18+ standalone + Material: páginas, componentes, services, rotas, Nginx. |
| **frontend-design** | `(develop)/(frontend)/frontend-design` | Interfaces frontend production-grade com alta qualidade de design. Evita estética genérica de IA. |
| **phaser3-impl** | `(develop)/(frontend)/phaser3-impl` | Jogos web em Phaser 3 + TypeScript a partir de contrato `gdd.md`. Object pooling, deploy AWS. |

## Testes

Vivem em `(testes)/`.

| Skill | Caminho no repo | Quando usar |
|-------|-----------------|-------------|
| **tdd-ptbr** | `(testes)/tdd-ptbr` | Obrigar TDD (Red-Green-Refactor) em toda task de dev. **Copiar sempre que houver código.** |

## Agentes (subagentes)

Vivem em `(agentes)/`. Arquivos `.md` soltos (não pastas), copiados para `.devin/agents/`.

| Agente | Arquivo no repo | Quando usar |
|--------|-----------------|-------------|
| **senior-dev-python** | `(agentes)/senior-dev-python.md` | Implementar backend FastAPI + scheduler: modelos, schemas, rotas, serviços Telegram, migrations, consolidador. |
| **senior-dev-angular** | `(agentes)/senior-dev-angular.md` | Implementar frontend Angular 18+ standalone com Material. |
| **qa-ptbr** | `(agentes)/qa-ptbr.md` | Revisar implementações: rodar testes, validar critérios de aceite, testar regras/contratos, reportar bugs. |

---

## Seleção por tipo de projeto

Listas-base. Apresente ao usuário na dimensão 12 da entrevista e pergunte se quer adicionar/remover.

### Backend puro (Python/FastAPI)
- `(figuras)/pm-ptbr`
- `(figuras)/tech-lead-ptbr`
- `(documentacao)/intake-ptbr`
- `(documentacao)/aprendizados`
- `(documentacao)/grill-me`
- `(documentacao)/gherkin-e2e`
- `(documentacao)/write-a-skill`
- `(develop)/(backend)/fastapi`
- `(develop)/(backend)/postgresql` *(se DB relacional)*
- `(develop)/(backend)/telegram-bot` *(se Telegram)*
- `(develop)/(backend)/docker` *(se container)*
- `(testes)/tdd-ptbr`
- `(agentes)/senior-dev-python.md`
- `(agentes)/qa-ptbr.md`

### Backend puro (Node/TS)
- Mesmas figuras/docs/testes acima.
- Sem skills backend técnicas (não há `nest`/`express` no catálogo ainda — registre a lacuna no `AGENTS.md`).
- `(agentes)/senior-dev-python.md` → **não copiar**. Sem dev-agente Node no catálogo ainda.
- `(agentes)/qa-ptbr.md` → copiar (QA é agnóstico de stack para testes gerais).

### Frontend puro (Angular)
- `(figuras)/pm-ptbr`, `(figuras)/tech-lead-ptbr`
- `(documentacao)/intake-ptbr`, `(documentacao)/aprendizados`, `(documentacao)/grill-me`, `(documentacao)/gherkin-e2e`, `(documentacao)/write-a-skill`
- `(develop)/(frontend)/angular-material`
- `(develop)/(frontend)/frontend-design`
- `(testes)/tdd-ptbr`
- `(agentes)/senior-dev-angular.md`, `(agentes)/qa-ptbr.md`

### Monorepo fullstack (Python + Angular)
- União de "Backend puro (Python/FastAPI)" + "Frontend puro (Angular)".

### Jogo web (Phaser)
- `(figuras)/roguelike-gdd`
- `(documentacao)/intake-ptbr`, `(documentacao)/aprendizados`, `(documentacao)/write-a-skill`
- `(develop)/(frontend)/phaser3-impl`
- `(testes)/tdd-ptbr`
- Sem `pm-ptbr`/`tech-lead-ptbr`/`qa-ptbr` (jogo usa GDD como contrato, não spec).

### Lib/SDK (Python)
- `(documentacao)/intake-ptbr`, `(documentacao)/aprendizados`, `(documentacao)/write-a-skill`
- `(testes)/tdd-ptbr`
- Sem `pm-ptbr`/`tech-lead-ptbr` (lib não tem features de produto).

### Docs-only
- Apenas `(documentacao)/write-a-skill` (se for repo de skills).

### Sempre copiar (qualquer projeto com código)
- `(documentacao)/write-a-skill`
- `(testes)/tdd-ptbr`

### Lacunas conhecidas (registre no `AGENTS.md` se o projeto precisar)
- Skill técnica para NestJS/Express/Fastify → não há no catálogo.
- Skill técnica para Go/Rust/Java/Ruby → não há no catálogo.
- Agente dev Node/Go/Rust/Java → não há no catálogo (só `senior-dev-python` e `senior-dev-angular`).
- Skill de CI/CD (GitHub Actions) → não há no catálogo.
- Skill de observabilidade (OpenTelemetry, Prometheus) → não há no catálogo.

Quando o usuário precisar de uma skill que não existe, registre a lacuna no `AGENTS.md` e sugira criá-la via `write-a-skill` depois do scaffold.
