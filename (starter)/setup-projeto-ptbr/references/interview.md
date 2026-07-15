# Roteiro de Entrevista — Setup de Projeto

> Uma dimensão por vez. Sem limite de perguntas até fechar cada dimensão.

## 1. Finalidade e público-alvo

**Pergunta-cravada:** qual problema este projeto resolve e quem usa?

- A) **Produto para usuários finais** — app/serviço com UI ou API pública. (Recomendado se mencionar "app", "sistema", "plataforma".)
- B) **Ferramenta interna** — uso restrito a equipe/empresa.
- C) **Biblioteca/SDK** — consumida por outros projetos.
- D) **Experimento/POC** — validar ideia rapidamente.
- E) **Documentação/repositório de skills** — meta-projeto, sem runtime de produto.

**Aprofundamento:**
- "Qual o resultado concreto para o usuário? (ex: controlar estoque, jogar roguelike, gerenciar finanças)"
- "Há prazo ou escopo de MVP definido?"

---

## 2. Tipo de projeto

**Pergunta-cravada:** qual a arquitetura de alto nível?

- A) **Backend puro** — API/serviço, sem UI própria.
- B) **Frontend puro** — UI que consome API externa.
- C) **Monorepo fullstack** — backend + frontend no mesmo repo.
- D) **Jogo web** — engine de jogo (Phaser, etc.).
- E) **Lib/SDK** — pacote publicável.
- F) **Docs-only** — site estático ou repo de documentação.

**Aprofundamento:**
- "Mais de um serviço backend? (API + worker + bot)"
- "Frontend admin e público separados?"

---

## 3. Stack principal

**Pergunta-cravada:** linguagem, framework e versão de runtime?

- A) **Python 3.12 + FastAPI** (Recomendado se Python backend)
- B) **Node 20 + NestJS/Express**
- C) **Angular 18+ standalone + Material** (Recomendado se frontend Angular)
- D) **Phaser 3 + TypeScript** (Recomendado se jogo)
- E) **Outro** — especificar versão exata

**Aprofundamento:**
- "Versão exata do runtime? (importante para CI e Docker)"
- "ORM/driver de DB?"

---

## 4. Banco de dados

**Pergunta-cravada:** qual persistência?

- A) **PostgreSQL** + migrations (Recomendado se relacional)
- B) **SQLite** — dev/protótipo
- C) **Sem banco** — stateless
- D) **Outro** — MongoDB, DynamoDB, etc.

Pule se lib pura ou docs-only.

---

## 5. Integrações externas

**Pergunta-cravada:** quais integrações no escopo?

- A) **Nenhuma no MVP** (Recomendado se incerto)
- B) **Telegram Bot API**
- C) **AWS serverless** (Lambda, DynamoDB, S3, CloudFront)
- D) **APIs REST de terceiros**
- E) **Mensageria** (SQS, RabbitMQ, Kafka)

**Aprofundamento:**
- "Deploy na AWS? Serverless ou containers?"
- "Webhooks inbound?"

---

## 6. Estratégia de testes

**Pergunta-cravada:** como garantir qualidade?

- A) **TDD obrigatório** — copiar `tdd-ptbr` (Recomendado se houver código)
- B) **TDD + Gherkin/e2e** — adicionar `gherkin-e2e` se houver UI ou fluxos críticos
- C) **Testes manuais por enquanto** — ainda copiar `tdd-ptbr` e registrar no AGENTS.md como meta

Pule se docs-only.

---

## 7. Layout de destino

**Pergunta-cravada:** onde instalar skills e agentes?

- A) **Cursor** — `.cursor/skills/` + `.cursor/agents/` (Recomendado se usuário usa Cursor)
- B) **Devin** — `.devin/skills/` + `.devin/agents/`
- C) **Ambos** — copiar para os dois layouts

---

## 8. Skills e agentes

Apresente a **lista pré-montada** (ver `skills-catalog.md`) baseada nas respostas anteriores.

Formato:

> Com base no que fechamos, recomendo copiar:
>
> **Skills:** pm-ptbr, tech-lead-ptbr, fastapi, ...
> **Agentes:** senior-dev-python.md, qa-ptbr.md
>
> Quer adicionar ou remover alguma?

**Aprofundamento:**
- "Quer `grill-with-docs` além do `grill-me`?"
- "Precisa de `deploy-aws-serverless`?"
