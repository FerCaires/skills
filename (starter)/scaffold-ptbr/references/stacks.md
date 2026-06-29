# Heurísticas de Detecção e Esqueletos por Stack

> Use este arquivo em duas fases: (1) **antes da entrevista**, rode as heurísticas para pré-popular dimensões 1–3; (2) **na geração do scaffold**, siga o esqueleto da stack confirmada.

## Tabela de conteúdo

1. [Heurísticas de detecção](#heurísticas-de-detecção)
2. [.gitignore por stack](#gitignore-por-stack)
3. [Esqueleto — Python/FastAPI](#esqueleto--pythonfastapi)
4. [Esqueleto — Node/TypeScript (NestJS/Express)](#esqueleto--nodetypescript-nestjsexpress)
5. [Esqueleto — Go](#esqueleto--go)
6. [Esqueleto — Rust (Axum)](#esqueleto--rust-axum)
7. [Esqueleto — Java/Spring Boot](#esqueleto--javaspring-boot)
8. [Esqueleto — Ruby/Rails](#esqueleto--rubyrails)
9. [Esqueleto — Angular (frontend puro)](#esqueleto--angular-frontend-puro)
10. [Esqueleto — Monorepo fullstack](#esqueleto--monorepo-fullstack)
11. [Esqueleto — Jogo web (Phaser)](#esqueleto--jogo-web-phaser)
12. [Esqueleto — Lib/SDK](#esqueleto--libsdk)

---

## Heurísticas de detecção

Rode em ordem. Pare no primeiro match.

| Marcador (arquivo/dir) | Stack | Tipo inferido |
|------------------------|-------|---------------|
| `phaser` em qualquer `package.json` OU `docs/GDD.md` | Node/TS + Phaser | Jogo web |
| `pyproject.toml` + `package.json` em pastas distintas | Python + Node/TS | Monorepo fullstack |
| `package.json` com `workspaces` OU múltiplos `package.json` | Node/TS | Monorepo Node |
| `pyproject.toml` / `requirements.txt` / `Pipfile` | Python | Backend |
| `package.json` com `@angular/core` em deps | Angular | Frontend |
| `package.json` sem `@angular/core`, sem `phaser` | Node/TS | Backend ou frontend genérico |
| `go.mod` | Go | Backend ou lib |
| `Cargo.toml` | Rust | Backend ou lib |
| `pom.xml` / `build.gradle*` | Java | Backend |
| `Gemfile` | Ruby | Backend |
| `composer.json` | PHP | Backend |
| `mix.exs` | Elixir | Backend |
| `deno.json` / `deno.jsonc` | Deno/TS | Backend ou lib |
| Nenhum marcador | — | Projeto novo (decidir na entrevista) |

**Comandos auxiliares:**
- `ls -la` na raiz para ver marcadores.
- `cat package.json | jq '.dependencies, .devDependencies, .workspaces'` se Node.
- `cat pyproject.toml` para ver toolchain (poetry, uv, hatch).
- `git remote -v` para inferir convenções (GitHub → Actions; GitLab → GitLab CI).

---

## .gitignore por stack

### Python
```
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/
.env
.env.*
!.env.example
.pytest_cache/
.ruff_cache/
.coverage
htmlcov/
dist/
build/
```

### Node/TypeScript
```
node_modules/
dist/
build/
.env
.env.*
!.env.example
*.log
.cache/
.npm/
.pnpm-store/
.turbo/
coverage/
```

### Go
```
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
vendor/
.env
!.env.example
```

### Rust
```
/target
**/*.rs.bk
Cargo.lock
.env
!.env.example
```

### Java (Maven)
```
target/
*.class
*.jar
*.war
.idea/
*.iml
.mvn/wrapper/maven-wrapper.jar
.env
!.env.example
```

### Ruby
```
/.bundle/
/vendor/bundle/
log/*.log
tmp/
.env
!.env.example
coverage/
```

### Angular (frontend)
```
dist/
node_modules/
.angular/cache/
coverage/
*.log
.env
!.env.example
```

---

## Esqueleto — Python/FastAPI

```
{project}/
├── .devin/
│   ├── skills/          # populado por copy-skills.sh
│   └── agents/          # populado por copy-skills.sh
├── docs/
│   └── workflow.md
├── src/
│   └── {package}/
│       ├── __init__.py
│       ├── main.py            # app FastAPI mínima (healthcheck)
│       ├── config.py          # pydantic-settings, lê .env
│       └── deps.py            # dependências injetáveis (DB session, etc.)
├── tests/
│   ├── __init__.py
│   └── test_smoke.py          # teste que só valida import + healthcheck
├── migrations/                # se Alembic
│   └── README.md              # placeholder
├── .env.example
├── .gitignore
├── AGENTS.md
├── README.md
├── pyproject.toml             # poetry/uv, deps: fastapi, uvicorn, pydantic-settings, pytest, ruff, black
└── Dockerfile                 # multi-stage (python:3.12-slim)
```

**`pyproject.toml` base (Poetry):**
```toml
[tool.poetry]
name = "{package}"
version = "0.1.0"
description = "{descrição}"
authors = ["{autor}"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^3.12"
fastapi = "^0.110"
uvicorn = {extras = ["standard"], version = "^0.27"}
pydantic-settings = "^2.2"

[tool.poetry.group.dev.dependencies]
pytest = "^8.0"
pytest-asyncio = "^0.23"
ruff = "^0.4"
black = "^24.3"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"

[tool.ruff]
line-length = 100

[tool.black]
line-length = 100
```

**`src/{package}/main.py` (placeholder, sem lógica):**
```python
"""Entry point. Lógica de negócio fica em routers/services — implementar via features."""
from fastapi import FastAPI

app = FastAPI(title="{project}", version="0.1.0")


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok"}
```

**`Dockerfile` (multi-stage):**
```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
RUN pip install --no-cache-dir poetry
COPY pyproject.toml poetry.lock* ./
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ ./src/
EXPOSE 8000
CMD ["uvicorn", "{package}.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## Esqueleto — Node/TypeScript (NestJS/Express)

```
{project}/
├── .devin/
├── docs/workflow.md
├── src/
│   ├── index.ts              # bootstraps app
│   ├── config.ts            # lê env vars (zod ou dotenv)
│   └── health.controller.ts # /health
├── test/
│   └── smoke.spec.ts
├── .env.example
├── .gitignore
├── AGENTS.md
├── README.md
├── package.json
├── tsconfig.json
├── eslint.config.js
├── prettier.config.js
└── Dockerfile
```

**`package.json` base:**
```json
{
  "name": "{project}",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "vitest run",
    "test:watch": "vitest",
    "lint": "eslint .",
    "format": "prettier --write ."
  },
  "dependencies": {
    "fastify": "^4.26",
    "zod": "^3.22"
  },
  "devDependencies": {
    "typescript": "^5.4",
    "tsx": "^4.7",
    "vitest": "^1.4",
    "eslint": "^9.0",
    "@typescript-eslint/eslint-plugin": "^7.4",
    "prettier": "^3.2"
  }
}
```

> Para NestJS, prefira `nest new` do CLI e só ajuste `AGENTS.md`/`docs/workflow.md`/`.devin/`.

---

## Esqueleto — Go

```
{project}/
├── .devin/
├── docs/workflow.md
├── cmd/
│   └── {project}/
│       └── main.go          # HTTP server com /health
├── internal/
│   └── config/
│       └── config.go        # lê env vars
├── .env.example
├── .gitignore
├── AGENTS.md
├── README.md
├── go.mod
├── Dockerfile
└── Makefile                 # targets: build, test, run, lint
```

**`go.mod` base:**
```
module github.com/{user}/{project}

go 1.22

require (
    github.com/labstack/echo/v4 v4.11.4
)
```

---

## Esqueleto — Rust (Axum)

```
{project}/
├── .devin/
├── docs/workflow.md
├── src/
│   ├── main.rs              # axum server com /health
│   └── config.rs            # lê env via std::env
├── tests/
│   └── smoke.rs
├── .env.example
├── .gitignore
├── AGENTS.md
├── README.md
├── Cargo.toml
└── Dockerfile
```

**`Cargo.toml` base:**
```toml
[package]
name = "{project}"
version = "0.1.0"
edition = "2021"

[dependencies]
axum = "0.7"
tokio = { version = "1", features = ["full"] }

[dev-dependencies]
tower = { version = "0.4", features = ["util"] }
```

---

## Esqueleto — Java/Spring Boot

Use o Spring Initializr (`start.spring.io`) para gerar a base, depois ajuste:
- Adicione `.devin/`, `docs/workflow.md`, `AGENTS.md`.
- Configure `.gitignore` (seção Java acima).
- Skeleton já vem com `pom.xml`/`build.gradle`, `src/main/java/.../Application.java`, `src/test/...`.

---

## Esqueleto — Ruby/Rails

Use `rails new {project} --api` (se backend puro) ou sem `--api` (se fullstack). Depois:
- Adicione `.devin/`, `docs/workflow.md`, `AGENTS.md`.
- Skeleton Rails já é completo por convenção.

---

## Esqueleto — Angular (frontend puro)

Use `ng new {project}` (Angular CLI) para gerar a base. Depois:
- Adicione `.devin/`, `docs/workflow.md`, `AGENTS.md`.
- Confirme `.gitignore` (seção Angular acima).
- Adicione `proxy.conf.json` se for consumir API local.

---

## Esqueleto — Monorepo fullstack

```
{project}/
├── .devin/
├── docs/workflow.md
├── backend/
│   └── (esqueleto Python/FastAPI acima)
├── frontend/
│   └── (esqueleto Angular acima)
├── docker-compose.yml        # orquestra backend + frontend + DB
├── .gitignore                # união Python + Node
├── AGENTS.md                 # cobre ambos
└── README.md
```

**`docker-compose.yml` base:**
```yaml
services:
  backend:
    build: ./backend
    ports: ["8000:8000"]
    env_file: ./backend/.env
    depends_on: [db]
  frontend:
    build: ./frontend
    ports: ["4200:80"]
    depends_on: [backend]
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes: [pgdata:/var/lib/postgresql/data]
    ports: ["5432:5432"]
volumes:
  pgdata:
```

---

## Esqueleto — Jogo web (Phaser)

Use `npm create vite@latest {project} -- --template vanilla-ts`, depois instale `phaser`. Estrutura:

```
{project}/
├── .devin/
├── docs/
│   ├── workflow.md
│   └── GDD.md               # placeholder para roguelike-gdd preencher
├── src/
│   ├── main.ts              # instancia Phaser.Game
│   ├── scenes/
│   │   └── Boot.scene.ts    # cena vazia
│   └── config.ts
├── public/
├── .gitignore
├── AGENTS.md
├── README.md
├── package.json
└── tsconfig.json
```

---

## Esqueleto — Lib/SDK

Estrutura mínima, sem runtime:

```
{project}/
├── .devin/
├── docs/workflow.md
├── src/
│   └── {package}/
│       ├── __init__.py      # exports públicos
│       └── _internal.py     # placeholder
├── tests/
│   └── test_public_api.py
├── .gitignore
├── AGENTS.md
├── README.md
└── pyproject.toml           # ou package.json, Cargo.toml, go.mod conforme stack
```

**Sem Dockerfile, sem compose, sem DB.** Lib é publicável, não roda como serviço.
