# Bancas de Perguntas por Dimensão Técnica

Bancas para conduzir a entrevista técnica em profundidade — mesmo espírito do PM e do Game Design Director. **Leia apenas a seção da dimensão que vai iniciar.**

## Sumário

1. [Contratos de API](#1-contratos-de-api)
2. [Modelagem de dados](#2-modelagem-de-dados)
3. [Schemas e tipos](#3-schemas-e-tipos)
4. [Integração entre serviços](#4-integração-entre-serviços)
5. [Frontend](#5-frontend)
6. [Auth e segurança](#6-auth-e-segurança)
7. [Config e secrets](#7-config-e-secrets)
8. [Observabilidade](#8-observabilidade)
9. [Performance](#9-performance)
10. [Compatibilidade e migrations](#10-compatibilidade-e-migrations)
11. [Estratégia de testes](#11-estratégia-de-testes)
12. [Riscos e rollback](#12-riscos-e-rollback)
13. [Paralelismo e dependências](#13-paralelismo-e-dependências)
14. [Atribuição de agents](#14-atribuição-de-agents)

---

## 1. Contratos de API

- Quais endpoints/eventos novos ou alterados (método + path)?
- 404 vs 200 vazio? 409 vs 400? Quando cada status?
- Paginação, filtros, ordenação — cursor ou offset?
- Idempotência em POST/PUT/retry?
- Shape mínimo de request/response estável para frontend paralelizar?

**Cravar antes de fechar:** lista de contratos com status/erros e shape mínimo.

---

## 2. Modelagem de dados

- Entidades novas/alteradas? PKs naturais vs surrogate?
- Constraints, unicidade, FKs, índices?
- Soft-delete ou hard-delete?
- Migration: expand/contract ou breaking?

**Cravar antes de fechar:** entidades + constraints críticas + estratégia de migration.

Pule se a feature não toca persistência.

---

## 3. Schemas e tipos

- Campos obrigatórios vs opcionais? Defaults?
- Decimal vs float? datetime timezone-aware?
- Validação no schema vs no serviço?
- Types TS espelham o contrato da API?

**Cravar antes de fechar:** lista de schemas/types com campos e regras (sem corpo de classe).

---

## 4. Integração entre serviços

- Quais serviços toca (db, backend, scheduler, frontend, bots)?
- Mesmo engine/schema entre backend e worker?
- Transação distribuída vs eventual consistency?
- Ordem de deploy / feature flags?

**Cravar antes de fechar:** mapa de dependências entre serviços + ponto de falha principal.

---

## 5. Frontend

- Rotas novas, guards, lazy load?
- Forms reativos vs template-driven?
- Estados: loading, empty, error?
- Service methods e models TS alinhados aos contratos?

**Cravar antes de fechar:** rotas + services afetados. Pule se backend puro.

---

## 6. Auth e segurança

- Quem pode chamar cada endpoint/ação?
- Secrets/PII em logs?
- Papel novo ou reaproveita auth existente?

**Cravar antes de fechar:** matriz papel→ação (mesmo simples) + regra de secrets.

---

## 7. Config e secrets

- Env vars novas? Nomes e defaults de dev?
- Secrets fora do git (`.env` / secret store)?
- Healthcheck precisa de nova dependência?

**Cravar antes de fechar:** lista de env vars + onde documentar (`.env.example`).

---

## 8. Observabilidade

- Logs estruturados: quais eventos?
- Métricas/alertas de falha crítica?
- Correlation/request-id entre serviços?

**Cravar antes de fechar:** eventos mínimos de log/alerta.

---

## 9. Performance

- Volume esperado (registros, RPS)?
- Queries N+1? Paginação obrigatória?
- Sync vs job async para operações longas?

**Cravar antes de fechar:** ordem de grandeza + decisão de paginação/async se aplicável.

---

## 10. Compatibilidade e migrations

- Breaking change de API? Versionamento?
- Migration irreversível?
- Janela de coexistência old/new?

**Cravar antes de fechar:** breaking ou não; plano expand/contract se breaking.

---

## 11. Estratégia de testes

- Unit / integration / e2e por camada?
- O que mockar (Telegram, DB, HTTP externo)?
- Critérios Given/When/Then cobrem o design?
- TDD: cada implementação tem teste correspondente?

**Cravar antes de fechar:** estratégia por camada + mocks + obrigação TDD explícita.

---

## 12. Riscos e rollback

- Top 1–3 riscos técnicos do design?
- Rollback em 1–3 passos?
- Feature flag necessária?

**Cravar antes de fechar:** riscos nomeados + rollback.

---

## 13. Paralelismo e dependências

- Quais tarefas podem rodar em paralelo após design aprovado?
- `depende_de` explícito no tasks.md?
- Backend + frontend paralelos com contratos fechados?

**Cravar antes de fechar:** grafo de dependências; lista do que pode paralelizar.

---

## 14. Atribuição de agents

- Cada tarefa tem agent correto (python/angular/qa)?
- Tarefa atômica o suficiente para um agent sozinho?
- Skills técnicas a carregar (fastapi, angular-material, tdd-ptbr…)?

**Cravar antes de fechar:** tabela tarefa → agent → skills; nenhuma tarefa guarda-chuva.
