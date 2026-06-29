# skills

Repositório centralizado de skills e agentes de IA para reutilização entre projetos.

As skills seguem o formato `SKILL.md` com frontmatter (`name`, `description`) e são
organizadas em pastas por categoria. Para instalar uma skill em outro projeto, copie
a pasta correspondente para `.devin/skills/` (ou `.agents/skills/` / `.opencode/skills/`,
conforme o agente alvo) do projeto de destino.

## Índice

- [Como navegar](#como-navegar)
- [Categorias](#categorias)
  - [Agentes (subagentes)](#agentes-subagentes)
  - [Figuras (personas/orquestradores)](#figuras-personasorquestradores)
  - [Documentação e Processo](#documentação-e-processo)
  - [Desenvolvimento — Backend](#desenvolvimento--backend)
  - [Desenvolvimento — Frontend](#desenvolvimento--frontend)
  - [Testes](#testes)
  - [Starter (bootstrap de projeto)](#starter-bootstrap-de-projeto)
  - [Meta (autoria de skills)](#meta-autoria-de-skills)
- [Fluxo recomendado entre skills](#fluxo-recomendado-entre-skills)
- [Convenções do repositório](#convenções-do-repositório)

## Como navegar

Cada skill é uma pasta contendo um `SKILL.md` (instruções principais) e,
opcionalmente, `references/` (documentação de apoio), `scripts/` (utilitários
determinísticos) e `assets/` (templates/ícones). Os arquivos `(agentes)/*.md`
são agentes no formato subagent (não skill com pasta), mas estão listados
aqui por fazerem parte do catálogo.

> **Total:** 19 skills/agentes catalogados.

## Categorias

### Agentes (subagentes)

Agentes no formato `mode: subagent` — personas de execução que recebem uma
tarefa e a implementam. Vivem em `(agentes)/`.

| Agente | Arquivo | Quando usar |
|--------|---------|-------------|
| **senior-dev-python** | `(agentes)/senior-dev-python.md` | Implementar backend FastAPI + scheduler APScheduler: modelos SQLAlchemy, schemas Pydantic, rotas, serviços Telegram, migrations Alembic, consolidador mensal. |
| **senior-dev-angular** | `(agentes)/senior-dev-angular.md` | Implementar frontend Angular 18+ standalone com Material: páginas, componentes, services, models, rotas, config Nginx. |
| **qa-ptbr** | `(agentes)/qa-ptbr.md` | Revisar implementações concluídas: rodar testes automatizados (pytest/Karma), validar critérios de aceite, testar regras de negócio e contratos de API, reportar bugs. |

### Figuras (personas/orquestradores)

Personas que conduzem entrevistas estruturadas com o usuário e produzem
artefatos de planejamento/design (spec, design, GDD). Vivem em `(figuras)/`.

| Skill | Pasta | Quando usar |
|-------|-------|-------------|
| **pm-ptbr** | `(figuras)/pm-ptbr/` | Planejar nova feature: ler SDD, quebrar em tarefas atômicas, definir critérios de aceite, gerar `spec.md` e `tasks.md`, manter agregador `docs/tasks.md`. Conduz entrevista de escopo. |
| **tech-lead-ptbr** | `(figuras)/tech-lead-ptbr/` | Gerar design técnico (`design.md`) a partir de spec aprovada: revisar arquitetura, coordenar integração entre serviços, definir contratos de API/modelagem. Conduz entrevista técnica. |
| **roguelike-gdd** | `(figuras)/roguelike-gdd/` | Atuar como Game Designer Sênior para jogos roguelike: conduzir entrevista exaustiva (11 áreas), refinar o GDD, persistir em `docs/GDD.md` e fatiar em contratos de feature `docs/{NNN}-{name}/gdd.md`. Não gera código. |

### Documentação e Processo

Skills de captura, memória, validação e autoria de documentação. Vivem em
`(documentacao)/`.

| Skill | Pasta | Quando usar |
|-------|-------|-------------|
| **intake-ptbr** | `(documentacao)/intake-ptbr/` | Capturar pedido bruto do usuário em `docs/prompts/{NNN}-{slug}.md` antes de acionar PM/bug-fix/etc. Garante rastreabilidade da demanda original. |
| **aprendizados** | `(documentacao)/aprendizados/` | Extrair, documentar e consultar lições aprendidas em `docs/aprendizados.md` para evitar repetição de erros. Consultar no início de qualquer implementação. |
| **gherkin-e2e** | `(documentacao)/gherkin-e2e/` | Gerar cenários E2E em Gherkin (`.feature`) e validar features concluídas: rodar BDD, checar sintaxe, reportar cobertura contra a spec. Obrigatório ao final de cada feature. |
| **grill-me** | `(documentacao)/grill-me/` | Entrevistar o usuário implacavelmente sobre um plano/design até chegar a entendimento compartilhado, resolvendo cada ramo da árvore de decisão. |
| **grill-with-docs** | `(documentacao)/grill-with-docs/` | Variante do `grill-me` que desafia o plano contra o modelo de domínio existente, afia terminologia e atualiza `CONTEXT.md`/ADRs inline. |
| **write-a-skill** | `(documentacao)/write-a-skill/` | Criar, revisar e melhorar skills — escrever novos `SKILL.md` do zero ou auditar/refinar skills existentes. |

### Desenvolvimento — Backend

Skills técnicas de implementação backend. Vivem em `(develop)/(backend)/`.
Todas exigem carregar `tdd-ptbr` antes de escrever código.

| Skill | Pasta | Quando usar |
|-------|-------|-------------|
| **fastapi** | `(develop)/(backend)/fastapi/` | Implementar rotas, modelos ORM, schemas, serviços, migrations no backend Python 3.12 + FastAPI + SQLAlchemy 2.0 async + Alembic + Pydantic v2. |
| **postgresql** | `(develop)/(backend)/postgresql/` | Modelagem e migrações PostgreSQL 16: criar/alterar tabelas, modelos SQLAlchemy, migrations Alembic, índices, init.sql, constraints. |
| **telegram-bot** | `(develop)/(backend)/telegram-bot/` | Integração Telegram Bot API (python-telegram-bot) + APScheduler: notificações de estoque baixo, consolidador mensal, scheduler. |
| **docker** | `(develop)/(backend)/docker/` | Infraestrutura Docker: docker-compose, Dockerfiles multi-stage, healthchecks, volumes, redes, variáveis de ambiente. |

### Desenvolvimento — Frontend

Skills técnicas de implementação frontend. Vivem em `(develop)/(frontend)/`.

| Skill | Pasta | Quando usar |
|-------|-------|-------------|
| **angular-material** | `(develop)/(frontend)/angular-material/` | Implementar páginas, componentes, serviços, modelos e rotas em Angular 18+ standalone + Angular Material. Configurar Nginx e build de produção. |
| **frontend-design** | `(develop)/(frontend)/frontend-design/` | Criar interfaces frontend distintas e production-grade com alta qualidade de design. Evita estéticas genéricas de IA. Integra com Angular 17+ (standalone, OnPush, signals). |
| **phaser3-impl** | `(develop)/(frontend)/phaser3-impl/` | Implementar features de jogos web em Phaser 3 + TypeScript a partir de contrato `gdd.md`. Object pooling, game states, spritesheet, deploy AWS (S3 + CloudFront). |

### Testes

| Skill | Pasta | Quando usar |
|-------|-------|-------------|
| **tdd-ptbr** | `(testes)/tdd-ptbr/` | Obrigar o ciclo TDD (Red-Green-Refactor) em toda task de desenvolvimento. Nenhuma linha de código de produção é escrita antes do teste que a valida. |

### Starter (bootstrap de projeto)

| Skill | Pasta | Quando usar |
|-------|-------|-------------|
| **scaffold-ptbr** | `(starter)/scaffold-ptbr/` | Bootstrap completo de projeto novo: conduz entrevista estruturada (tipo/stack/DB/integrações/CI/testes/convenções), detecta via heurísticas e scaffolds `AGENTS.md`, `docs/workflow.md`, `README.md`, `.gitignore` e esqueleto de código mínimo; copia skills/agentes relevantes deste repo para `.devin/` do projeto alvo via `scripts/copy-skills.sh`. |

### Meta (autoria de skills)

| Skill | Pasta | Quando usar |
|-------|-------|-------------|
| **write-a-skill** *(ativa)* | `.devin/skills/write-a-skill/` | Skill Devin ativa no repositório para criar/revisar skills. Cópia idêntica a `(documentacao)/write-a-skill/` — esta é a versão carregada pelo Devin CLI. |

## Fluxo recomendado entre skills

```
[usuário faz pedido]
        │
        ▼
   intake-ptbr           ← captura bruta em docs/prompts/
        │
        ▼
   pm-ptbr               ← entrevista de escopo → spec.md + tasks.md
        │
        ▼
   tech-lead-ptbr        ← entrevista técnica → design.md
        │
        ▼
   ┌─────┴─────┐
   ▼           ▼
 senior-dev-  senior-dev-   ← cada um carrega tdd-ptbr + a skill técnica
   python       angular     (fastapi / postgresql / telegram-bot / docker
   │           │            / angular-material / frontend-design)
   └─────┬─────┘
        ▼
   qa-ptbr  +  gherkin-e2e  ← validação contra spec + cenários BDD
        │
        ▼
   aprendizados            ← registrar lições para próximas features
```

Para jogos roguelike, o fluxo é paralelo:

```
   roguelike-gdd   →  phaser3-impl   (feature por feature, via gdd.md)
```

## Convenções do repositório

- Pastas de categoria usam parênteses: `(agentes)`, `(figuras)`,
  `(documentacao)`, `(develop)`, `(testes)`, `(starter)`.
- Subpastas de skill contêm `SKILL.md` com frontmatter `name` + `description`.
- Skills técnicas (backend/frontend) **exigem** `tdd-ptbr` carregada antes de
  escrever código.
- Skills de persona (`pm-ptbr`, `tech-lead-ptbr`, `roguelike-gdd`) conduzem
  entrevistas com no máximo 15 perguntas, uma por turno, sempre oferecendo
  uma `Resposta recomendada`.
- Toda skill deve seguir o padrão definido em `write-a-skill` (Quick Start,
  description < 1024 chars, SKILL.md < 500 linhas, references/ para conteúdo
  avançado).
- Textos de interface e notificação em **português brasileiro** quando
  aplicável (skills pt-BR).
