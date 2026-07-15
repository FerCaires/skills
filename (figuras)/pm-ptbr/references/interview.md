# Bancas de Perguntas por Dimensão da Spec

Bancas para conduzir a entrevista em profundidade — mesmo espírito do Game Design Director. **Leia apenas a seção da dimensão que vai iniciar** — não carregue tudo de uma vez.

## Sumário

1. [Objetivo + métrica](#1-objetivo--métrica-de-sucesso)
2. [Escopo + fora-de-escopo](#2-escopo--fora-de-escopo)
3. [Persona](#3-persona-primáriasecundária)
4. [Histórias de usuário](#4-histórias-de-usuário)
5. [Regras de negócio](#5-regras-de-negócio--edge-cases)
6. [Modelo de dados](#6-modelo-de-dados)
7. [Contratos](#7-contratos-rotas-schemas)
8. [Integrações](#8-integrações-externas)
9. [UX](#9-ux-telas-componentes)
10. [Permissões/segurança](#10-permissõessegurança)
11. [Performance](#11-performancelimites)
12. [Observabilidade](#12-observabilidade)
13. [Testes](#13-testes)
14. [Riscos e rollback](#14-riscos-e-rollback)

---

## 1. Objetivo + métrica de sucesso

- Qual **problema de negócio** concreto esta feature resolve? (não "melhorar a UX" — diga o atrito)
- Quem sofre hoje e com que frequência?
- Qual **métrica de sucesso** indica que funcionou? (%, tempo, volume, erro zero)
- Em quanto tempo esperamos ver o efeito?
- Se cortássemos esta feature, o que o usuário perde de verdade?

**Cravar antes de fechar:** problema em 1–2 frases, métrica numérica ou verificável, prazo/horizonte de validação.

---

## 2. Escopo + fora-de-escopo

- O que **entra** no MVP desta feature (lista fechada)?
- O que **explicitamente NÃO entra**? (negativo é decisão)
- Há pedidos "já que estamos mexendo" que devem ir para fora-de-escopo?
- Há overlap com feature `[FECHADO]` ou em andamento?
- Qual o menor recorte que ainda entrega valor?

**Cravar antes de fechar:** lista de inclusões, lista de exclusões, justificativa do corte.

---

## 3. Persona primária/secundária

- Quem é o **papel** que usa a feature (não "usuário genérico")?
- Qual o contexto de uso (frequência, dispositivo, urgência)?
- Há persona secundária (admin, operador, bot)?
- O benefício é o mesmo para todas as personas?

**Cravar antes de fechar:** persona primária nomeada + benefício mensurável/verificável.

---

## 4. Histórias de usuário

- Liste 3–5 histórias MVP no formato "Como [papel], quero [ação] para [benefício]".
- Qual história é a **mais crítica** (sem ela a feature não vale)?
- Alguma história é nice-to-have disfarçada de must?
- Cada história tem critério de aceite implícito testável?

**Cravar antes de fechar:** 3–5 histórias, prioridade, nenhuma história "guarda-chuva".

---

## 5. Regras de negócio + edge cases

- Quais validações são **obrigatórias** vs opcionais?
- O que acontece quando o usuário faz X inválido? (mensagem, status, retry)
- Concorrência: dois usuários no mesmo recurso ao mesmo tempo?
- Idempotência: reenvio/retry gera duplicata?
- Estados impossíveis que o sistema deve rejeitar?
- Volumes / limites de negócio (máx. itens, tetos, quotas)?

**Cravar antes de fechar:** regras em comportamento concreto (não adjetivos), edge cases cobertos, "e se X?" respondido.

---

## 6. Modelo de dados

- Quais entidades novas ou alteradas?
- Campos obrigatórios, tipos, defaults?
- Migrations: backward-compatible ou breaking?
- Índices / unicidade / soft-delete?
- Seed ou dados iniciais para dev/test?

**Cravar antes de fechar:** entidades + campos críticos, estratégia de migration, constraints.

Pule se a feature não toca persistência.

---

## 7. Contratos (rotas, schemas)

- Quais endpoints/eventos novos ou alterados?
- Códigos de erro: 404 vs 200 vazio? 409 vs 400?
- Paginação, filtros, ordenação?
- Contrato request/response estável o suficiente para frontend paralelo?

**Cravar antes de fechar:** lista de contratos com status/erros, shape mínimo de request/response.

Pule se não há API/evento.

---

## 8. Integrações externas

- Quais APIs/bots/filas entram no escopo?
- Env vars necessárias? Sandbox vs prod?
- Falha da integração: retry, fila, alerta, degradação?
- Webhooks inbound precisam de assinatura/HMAC?

**Cravar antes de fechar:** integrações nomeadas (ou "nenhuma"), falha tratada, secrets via env.

---

## 9. UX (telas, componentes)

- Quais telas/fluxos novos ou alterados?
- Estados vazios, loading, erro?
- Mensagens em pt-BR (ou locale do projeto)?
- Navegação / deep links / guards?

**Cravar antes de fechar:** telas listadas, estados cobertos, mensagens críticas.

Pule se backend puro.

---

## 10. Permissões/segurança

- Quem pode executar cada ação?
- Dados sensíveis? PII? logs sem secret?
- Auth existente cobre ou precisa de papel novo?

**Cravar antes de fechar:** matriz papel→ação (mesmo que simples), regra de secret/PII.

---

## 11. Performance/limites

- Volume esperado (registros, RPS, usuários simultâneos)?
- Paginação / cache / timeout?
- Operações longas: sync vs async/job?

**Cravar antes de fechar:** ordem de grandeza de volume + decisão de paginação/async se aplicável.

---

## 12. Observabilidade

- O que precisa aparecer em log estruturado?
- Métrica ou alerta de falha crítica?
- Como o operador sabe que quebrou?

**Cravar antes de fechar:** eventos de log/alerta mínimos (ou "mínimo: erros com request-id").

---

## 13. Testes

- Quais critérios Given/When/Then por história crítica?
- Unit vs integration vs e2e — o que é obrigatório nesta feature?
- Precisa de Gherkin (`.feature`)?
- Mocks de integração externa?

**Cravar antes de fechar:** critérios testáveis por tarefa crítica; estratégia de teste nomeada.

---

## 14. Riscos e rollback

- O que pode dar errado no deploy?
- Migration irreversível? Feature flag?
- Plano de rollback em 1–3 passos?
- Dependências de outras features (`depende_de`)?

**Cravar antes de fechar:** top 1–3 riscos + rollback; dependências explícitas para paralelismo.
