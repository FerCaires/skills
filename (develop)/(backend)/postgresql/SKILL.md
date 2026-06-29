---
name: postgresql
description: Modelagem e migrações PostgreSQL 16, SQLAlchemy ORM e Alembic. Use quando criar ou alterar tabelas, modelos ORM, migrations, índices, init.sql, ou consultas SQL. Também use para revisar schemas de banco e constraints.
---

# PostgreSQL 16 — ControleEstoqueLashDesigner

## Quick Start

```sql
-- Conectar no container
docker compose exec db psql -U lash -d estoque

-- Aplicar migrations (via backend)
docker compose exec backend alembic upgrade head
```

## Modelo de dados (SDD.md seção 4)

### Tabelas

```sql
CREATE TABLE produtos (
    nome         VARCHAR(255) PRIMARY KEY,  -- PK natural, NÃO serial
    preco        DECIMAL(10,2) NOT NULL,
    quantidade   INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE usuarios (
    nome              VARCHAR(255) PRIMARY KEY,  -- PK natural, NÃO serial
    situacao          VARCHAR(10) NOT NULL CHECK (situacao IN ('ativa','inativa')),
    telegram_chat_id  VARCHAR(100)
);

CREATE TABLE vendas (
    id                  SERIAL PRIMARY KEY,  -- ÚNICA tabela com surrogate key
    nome_produto        VARCHAR(255) NOT NULL REFERENCES produtos(nome),
    nome_usuario        VARCHAR(255) NOT NULL REFERENCES usuarios(nome),
    data_compra         DATE NOT NULL DEFAULT CURRENT_DATE,
    quantidade_comprada INTEGER NOT NULL CHECK (quantidade_comprada > 0),
    preco_pago          DECIMAL(10,2) NOT NULL
);
```

### Índices

```sql
CREATE INDEX idx_vendas_usuario_data ON vendas (nome_usuario, data_compra);
CREATE INDEX idx_vendas_produto ON vendas (nome_produto);
```

## Decisões de design críticas

1. **PKs naturais**: `produtos.nome` e `usuarios.nome` são VARCHAR PKs. Não usar `SERIAL` ou `IDENTITY` para essas tabelas. O SDD.md é explícito sobre isso.

2. **Surrogate key só em vendas**: apenas a tabela `vendas` usa `id SERIAL PRIMARY KEY`.

3. **Foreign keys**: `vendas.nome_produto → produtos(nome)` e `vendas.nome_usuario → usuarios(nome)`. São VARCHAR FKs referenciando VARCHAR PKs.

4. **DECIMAL para dinheiro**: `preco` e `preco_pago` usam `DECIMAL(10,2)`, nunca `FLOAT` ou `REAL`.

5. **CHECK constraint**: `quantidade_comprada > 0` garante que não existam vendas com quantidade zero ou negativa.

## SQLAlchemy Models

```python
from sqlalchemy import String, Integer, Numeric, Date, ForeignKey, CheckConstraint
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from decimal import Decimal
from datetime import date

class Base(DeclarativeBase):
    pass

class Produto(Base):
    __tablename__ = "produtos"
    nome: Mapped[str] = mapped_column(String(255), primary_key=True)
    preco: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    quantidade: Mapped[int] = mapped_column(Integer, default=0)

class Usuario(Base):
    __tablename__ = "usuarios"
    nome: Mapped[str] = mapped_column(String(255), primary_key=True)
    situacao: Mapped[str] = mapped_column(String(10), default="ativa")
    telegram_chat_id: Mapped[str | None] = mapped_column(String(100), nullable=True)

class Venda(Base):
    __tablename__ = "vendas"
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    nome_produto: Mapped[str] = mapped_column(String(255), ForeignKey("produtos.nome"))
    nome_usuario: Mapped[str] = mapped_column(String(255), ForeignKey("usuarios.nome"))
    data_compra: Mapped[date] = mapped_column(Date, default=date.today)
    quantidade_comprada: Mapped[int] = mapped_column(Integer)
    preco_pago: Mapped[Decimal] = mapped_column(Numeric(10, 2))
```

## init.sql

O arquivo `db/init.sql` é executado na primeira inicialização do container PostgreSQL. Deve conter apenas `CREATE TABLE` e `CREATE INDEX`. Migrations subsequentes são gerenciadas pelo Alembic.

## Migrations com Alembic

```bash
# Gerar migration a partir dos modelos
alembic revision --autogenerate -m "descricao_da_mudanca"

# Aplicar
alembic upgrade head

# Reverter
alembic downgrade -1
```

O Alembic deve estar configurado com `target_metadata = Base.metadata` e usar o `DATABASE_URL` da env.

## Convenções

- Nomes de tabelas e colunas em **português** (seguindo SDD.md).
- `CURRENT_DATE` para `data_compra` default, não `NOW()` (é DATE, não TIMESTAMP).
- Constraints nomeadas explicitamente nos modelos para facilitar debug.
- Sempre verificar se o Alembic detecta mudanças corretamente após alterar modelos.
