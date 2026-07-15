# Catálogo de Skills Copiáveis

> Fonte: `https://github.com/FerCaires/skills`. Copie via `scripts/copy-skills.sh`.

## Figuras

| Skill | Caminho | Quando usar |
|-------|---------|-------------|
| pm-ptbr | `(figuras)/pm-ptbr` | Planejar feature: entrevista exaustiva (padrão Game Design Director), spec.md + tasks.md |
| tech-lead-ptbr | `(figuras)/tech-lead-ptbr` | Design técnico: entrevista exaustiva (padrão PM/GDD), design.md |
| roguelike-gdd | `(figuras)/roguelike-gdd` | GDD e contratos para jogos roguelike |

## Documentação e processo

| Skill | Caminho | Quando usar |
|-------|---------|-------------|
| intake-ptbr | `(documentacao)/intake-ptbr` | Capturar pedido em docs/prompts/ |
| aprendizados | `(documentacao)/aprendizados` | Lições em docs/aprendizados.md |
| gherkin-e2e | `(documentacao)/gherkin-e2e` | Cenários BDD .feature |
| grill-me | `(documentacao)/grill-me` | Entrevista implacável sobre plano |
| grill-with-docs | `(documentacao)/grill-with-docs` | Grill-me + CONTEXT.md/ADRs |
| write-a-skill | `(documentacao)/write-a-skill` | Criar skills do projeto — **sempre copiar** |

## Backend

| Skill | Caminho | Quando usar |
|-------|---------|-------------|
| fastapi | `(develop)/(backend)/fastapi` | Python 3.12 + FastAPI + SQLAlchemy |
| postgresql | `(develop)/(backend)/postgresql` | Postgres 16 + Alembic |
| telegram-bot | `(develop)/(backend)/telegram-bot` | Bot Telegram + APScheduler |
| docker | `(develop)/(backend)/docker` | Compose, Dockerfiles |

## Frontend

| Skill | Caminho | Quando usar |
|-------|---------|-------------|
| angular-material | `(develop)/(frontend)/angular-material` | Angular 18+ + Material |
| frontend-design | `(develop)/(frontend)/frontend-design` | UI production-grade |
| phaser3-impl | `(develop)/(frontend)/phaser3-impl` | Jogos Phaser 3 + TS |

## Testes e CI/CD

| Skill | Caminho | Quando usar |
|-------|---------|-------------|
| tdd-ptbr | `(testes)/tdd-ptbr` | TDD obrigatório — **copiar com código** |
| deploy-aws-serverless | `(CI/CD)/deploy-aws-serverless` | Deploy AWS via GitHub Actions |

## Agentes

| Agente | Arquivo | Quando usar |
|--------|---------|-------------|
| senior-dev-python | `(agentes)/senior-dev-python.md` | Backend FastAPI |
| senior-dev-angular | `(agentes)/senior-dev-angular.md` | Frontend Angular |
| qa-ptbr | `(agentes)/qa-ptbr.md` | QA e validação |

## Seleção por tipo

### Backend Python/FastAPI
Skills: pm-ptbr, tech-lead-ptbr, intake-ptbr, aprendizados, grill-me, gherkin-e2e, write-a-skill, fastapi, postgresql*, docker*, telegram-bot*, tdd-ptbr
Agentes: senior-dev-python.md, qa-ptbr.md

### Frontend Angular
Skills: pm-ptbr, tech-lead-ptbr, intake-ptbr, aprendizados, grill-me, gherkin-e2e, write-a-skill, angular-material, frontend-design, tdd-ptbr
Agentes: senior-dev-angular.md, qa-ptbr.md

### Monorepo Python + Angular
União das listas acima.

### Jogo Phaser
Skills: roguelike-gdd, phaser3-impl, intake-ptbr, aprendizados, write-a-skill, tdd-ptbr
Agentes: nenhum (GDD como contrato)

### Lib/SDK
Skills: intake-ptbr, aprendizados, write-a-skill, tdd-ptbr

### Docs-only
Skills: write-a-skill

### AWS serverless (adicional)
Skills: deploy-aws-serverless

## Lacunas conhecidas

Registre no AGENTS.md se o projeto precisar:
- NestJS/Express/Fastify, Go, Rust, Java, Ruby — sem skill técnica no catálogo
- Agentes dev Node/Go/Rust — só Python e Angular existem
- CI genérico (GitHub Actions) — só deploy-aws-serverless
