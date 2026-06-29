---
name: docker
description: Infraestrutura Docker com docker-compose, Dockerfiles multi-stage e orquestração de 4 serviços (db, backend, frontend, scheduler). Use quando criar ou modificar Dockerfiles, docker-compose.yml, .env, healthchecks, volumes ou redes.
---

# Docker — ControleEstoqueLashDesigner

## Quick Start

```bash
cp .env.example .env
# Preencher variáveis no .env
docker compose up --build
docker compose down -v   # derruba tudo, remove volumes
```

## Serviços

| Serviço   | Imagem base       | Porta | Depende de       |
|-----------|-------------------|-------|------------------|
| `db`      | postgres:16-alpine | 5432  | —                |
| `backend` | python:3.12-slim   | 8000  | db (healthy)     |
| `frontend`| nginx:alpine (multi-stage c/ node:20) | 80 | backend |
| `scheduler`| python:3.12-slim  | —     | db (healthy)     |

## docker-compose.yml (estrutura SDD.md seção 7)

```yaml
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 5s
      retries: 5

  backend:
    build: ./backend
    depends_on:
      db:
        condition: service_healthy
    environment:
      DATABASE_URL: ${DATABASE_URL}
      TELEGRAM_BOT_TOKEN: ${TELEGRAM_BOT_TOKEN}
      TELEGRAM_ADMIN_CHAT_ID: ${TELEGRAM_ADMIN_CHAT_ID}
      TELEGRAM_PIX_KEY: ${TELEGRAM_PIX_KEY}
    ports:
      - "8000:8000"

  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

  scheduler:
    build: ./scheduler
    depends_on:
      db:
        condition: service_healthy
    environment:
      DATABASE_URL: ${DATABASE_URL}
      TELEGRAM_BOT_TOKEN: ${TELEGRAM_BOT_TOKEN}
      TELEGRAM_PIX_KEY: ${TELEGRAM_PIX_KEY}

volumes:
  pgdata:
```

## Dockerfiles

### Backend (Python)

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Scheduler (Python)

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "-m", "app.main"]
```

### Frontend (Angular multi-stage)

```dockerfile
# Stage 1: build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build -- --configuration production

# Stage 2: serve
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/frontend/browser /usr/share/nginx/html
```

## Variáveis de ambiente (.env)

```env
POSTGRES_USER=lash
POSTGRES_PASSWORD=<senha>
POSTGRES_DB=estoque
DATABASE_URL=postgresql+asyncpg://lash:<senha>@db:5432/estoque
TELEGRAM_BOT_TOKEN=<token>
TELEGRAM_ADMIN_CHAT_ID=<chat_id>
TELEGRAM_PIX_KEY=<chave_pix>
```

## Health checks

- **db**: `pg_isready -U ${POSTGRES_USER}` — backend e scheduler dependem de `condition: service_healthy`.
- **backend**: não tem healthcheck explícito, mas `frontend` depende dele para proxy reverso.
- **scheduler**: independente, só depende do db estar healthy.

## Volumes

- `pgdata`: volume nomeado para persistir dados do PostgreSQL entre restarts.

## Comandos úteis

```bash
docker compose up --build          # build + start tudo
docker compose up -d               # detached
docker compose logs -f backend     # logs de um serviço
docker compose exec backend bash   # shell no container
docker compose restart backend     # reinicia um serviço
docker compose down -v             # remove tudo (incluindo volume pgdata!)
```
