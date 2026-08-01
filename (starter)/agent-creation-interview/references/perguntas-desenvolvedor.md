# Roteiro de Entrevista — Agente de Desenvolvimento

Use este roteiro depois do bloco fundamental (Etapa 1 do SKILL.md). Conduza
por blocos, agrupando perguntas correlatas em chamadas de `ask_user_input_v0`
(máx. 3 por vez). Opções marcadas com ⭐ são as recomendadas para a maioria
dos casos — use isso para pré-selecionar sugestões, não para pular a
pergunta.

## 1. Especialidade e escopo técnico

- Especialidade principal: Backend ⭐ | Frontend | Mobile | Fullstack |
  Dados/ML | Infra/DevOps | Embarcado/Firmware | Outro
- Se Fullstack: pergunte a divisão de ênfase (ex.: 70% backend / 30%
  frontend) para calibrar profundidade nas próximas perguntas.
- Nível de senioridade que o agente deve simular: Júnior (segue padrões à
  risca, pergunta mais) | Pleno | Sênior ⭐ (questiona decisões, sugere
  alternativas) | Staff/Principal (foco em arquitetura e impacto amplo)

## 2. Linguagens e stack principal

- Linguagem(ns) principal(is) (texto livre, mas sugira as mais comuns como
  botões): Kotlin | Java | TypeScript/JavaScript | Python | Go | C# | Swift |
  Outro
- Versão/ecossistema relevante (ex.: Java 17+, Node 20+, Python 3.12) — só
  pergunte se for importante para o projeto do usuário.
- O agente deve trabalhar com apenas uma linguagem ou várias? Se várias,
  quais e em que contexto cada uma é usada.

## 3. Frameworks e bibliotecas

- Framework principal, de acordo com a linguagem escolhida (sugestões):
  - Backend Kotlin/Java: Spring Boot ⭐ | Ktor | Quarkus | Micronaut
  - Backend Node/TS: NestJS ⭐ | Express | Fastify
  - Backend Python: FastAPI ⭐ | Django | Flask
  - Frontend: React ⭐ | Next.js | Vue | Angular | Svelte
  - Mobile: React Native | Flutter | Swift/SwiftUI | Kotlin/Jetpack Compose
- Bibliotecas auxiliares relevantes (ORM, HTTP client, validação, state
  management, etc.) — texto livre, com exemplos comuns por stack.
- O agente deve seguir alguma versão/convenção específica dessas libs já
  usada no projeto do usuário?

## 4. Arquitetura e padrões de projeto

- Estilo arquitetural que o agente deve aplicar/preservar: Clean
  Architecture ⭐ | Arquitetura em camadas (Controller → UseCase → Service) |
  Hexagonal/Ports & Adapters | Microsserviços | Monolito modular | Serverless
  | Event-driven | DDD (Domain-Driven Design)
- Padrões de projeto que deve conhecer e aplicar (SOLID sempre implícito):
  Repository, Factory, Strategy, Observer, Adapter, CQRS, Saga — pergunte se
  há algum obrigatório no projeto.
- O agente deve **seguir uma convenção já existente no projeto** (aponte um
  exemplo/arquivo de referência) ou **propor a melhor prática do zero**?

## 5. Testes e qualidade

- Tipos de teste que o agente deve escrever/exigir: Unitário ⭐ |
  Integração ⭐ | End-to-end (E2E) | Contrato (contract testing) | Performance
- Frameworks de teste, por stack (sugestões): JUnit5 + MockK/Mockito
  (Kotlin/Java) | Jest/Vitest (JS/TS) | PyTest (Python) | Cypress/Playwright
  (E2E)
- Cobertura mínima esperada (se houver meta definida no projeto).
- O agente deve escrever teste junto com toda funcionalidade nova por padrão
  (TDD/teste obrigatório) ou só quando solicitado?

## 6. Persistência e dados

- Tipo de banco: Relacional (PostgreSQL/MySQL) ⭐ | NoSQL (MongoDB, DynamoDB)
  | Cache (Redis) | Múltiplos
- ORM/ferramenta de acesso a dados (ex.: JPA/Hibernate, Prisma, SQLAlchemy,
  jOOQ) ou SQL puro.
- Estratégia de migrações de schema (Flyway, Liquibase, Alembic) se
  relevante.

## 7. Convenções, estilo e qualidade de código

- Linter/formatter que o time usa (ktlint, ESLint+Prettier, Black, etc.).
- Convenções de nomenclatura específicas do projeto (se houver).
- O agente deve recusar código que viole essas convenções, ou só sugerir
  ajustes?

## 8. Versionamento, Git e CI/CD

- Estratégia de branches: GitFlow | Trunk-based ⭐ | Feature branches simples
- Padrão de commits: Conventional Commits ⭐ | Livre | Outro padrão do time
- O agente participa de code review? Se sim, com que nível de rigor
  (bloqueante vs. sugestivo)?
- Deve validar/conhecer o pipeline de CI/CD (o que precisa passar antes de
  um PR ser aceito)?

## 9. Documentação

- O agente deve gerar/manter documentação junto do código: comentários,
  README, OpenAPI/Swagger, ADRs (Architecture Decision Records)?
- Nível de detalhe esperado (mínimo necessário vs. exaustivo).

## 10. Colaboração e nível de revisão esperado

- O agente deve revisar código de outras pessoas/agentes, ou só produzir o
  próprio código?
- Como ele deve se posicionar diante de decisões técnicas discordantes:
  aceitar e seguir, ou defender a própria recomendação com justificativa
  técnica antes de ceder?

---

Depois de percorrer os 10 blocos, volte para a Etapa 3 do SKILL.md
(resumo e aprovação do escopo).
