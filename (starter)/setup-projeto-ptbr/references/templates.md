# Templates — AGENTS.md e docs/workflow.md

Substitua `{placeholders}` pelos valores da entrevista.

## AGENTS.md

```markdown
# AGENTS.md — {project}

> Regras e contexto para agentes de IA neste repositório. **Leia antes de qualquer ação.**

## Descrição

{1–2 parágrafos: finalidade, público-alvo, resultado esperado.}

## Stack

- **Tipo:** {backend / frontend / monorepo / jogo / lib / docs}
- **Runtime:** {Python 3.12 / Node 20 / Angular 18 / Phaser 3 + TS}
- **Framework:** {FastAPI / NestJS / Angular / Phaser}
- **Banco:** {PostgreSQL 16 / SQLite / sem DB}
- **Integrações:** {Telegram / AWS / nenhuma}
- **Testes:** {pytest / Vitest / Karma + tdd-ptbr}
- **Locale:** {pt-BR / en}

## Comandos

| Ação | Comando |
|------|---------|
| Instalar deps | `{comando}` |
| Rodar em dev | `{comando}` |
| Testar | `{comando}` |
| Lint | `{comando}` |

## Skills disponíveis

Copiadas de `https://github.com/FerCaires/skills` para `{.cursor ou .devin}/`:

### Skills (`{.cursor/skills/}`)

| Skill | Quando usar |
|-------|-------------|
| {nome} | {trigger curta} |

### Agentes (`{.cursor/agents/}`)

| Agente | Quando usar |
|--------|-------------|
| {nome} | {trigger curta} |

> Skills específicas deste projeto: criar via `write-a-skill` em `{skills_dir}/`.

## Workflow

Fluxo completo em **[`docs/workflow.md`](docs/workflow.md)**.

```
{resumo: intake → pm → tech-lead → devs → qa → aprendizados}
```

### Gates de aprovação (obrigatórios)

| Gate | Quem aprova | Artefato | Bloqueio |
|------|-------------|----------|----------|
| Spec | **usuário** | `docs/features/{NNN}-{name}/spec.md` | Nenhum design ou código antes da aprovação explícita |
| Design | **usuário** | `docs/features/{NNN}-{name}/design.md` | Nenhum código antes da aprovação explícita |

O Tech Lead **produz** o design; o **usuário valida e aprova**. Sem "aprovação tácita" — aguardar confirmação explícita em cada gate.

Exceção: **lib/SDK** pula o gate de design (spec aprovada pelo usuário basta).

### Execução paralela

Sempre que possível, **features independentes** avançam em paralelo após seus gates:

- Duas ou mais features com **spec e design aprovados pelo usuário** podem entrar em `em_andamento` simultaneamente se **não houver dependência ou conflito de contrato/arquivo**.
- Backend e frontend da **mesma feature** podem implementar em paralelo **depois** que o design (com contratos de API/modelo) estiver aprovado pelo usuário.
- O PM marca dependências em `tasks.md` e no agregador `docs/tasks.md` (`bloqueado` / `depende_de: {NNN}`).
- Antes de paralelizar, verificar: escopo fechado, contratos explícitos no design, pastas/arquivos sem overlap não resolvido.

**Regras:**
- Nenhuma feature sem **spec aprovada pelo usuário** e **design aprovado pelo usuário**, exceto lib/docs.
- TDD obrigatório em toda task de dev (tdd-ptbr).
- QA (qa-ptbr + gherkin-e2e) ao final de cada feature.
- Preferir paralelismo seguro a fila serial desnecessária.

## Convenções

- **Commits:** Conventional Commits (`feat:`, `fix:`, `chore:`)
- **Branches:** trunk-based — `main` + `feat/{slug}` / `fix/{slug}`
- **PRs:** review + CI verde
- **Secrets:** nunca commitar `.env`

## Lacunas do catálogo

{lista de skills ausentes que o projeto precisará criar, ou "Nenhuma."}
```

## docs/workflow.md

```markdown
# Workflow — {project}

> Fluxo de uma demanda, do pedido bruto à validação. Tipo: **{tipo}**.

## Fluxograma

```
[usuário faz pedido]
        │
        ▼
   intake-ptbr             ← docs/prompts/{NNN}-{slug}.md
        │
        ▼
   pm-ptbr                 ← spec.md + tasks.md → **gate: aprovação do usuário**
        │
        ▼
   tech-lead-ptbr          ← design.md → **gate: aprovação do usuário** (pular se lib)
        │
        ├──────────────────────────┐   ← features independentes em paralelo
        ▼                          ▼
   dev + tdd-ptbr (feat A)    dev + tdd-ptbr (feat B)
        │                          │
        └──────────┬───────────────┘
                   ▼
   qa-ptbr + gherkin-e2e   ← validação (pode rodar em paralelo por feature)
        │
        ▼
   aprendizados            ← docs/aprendizados.md
```

## Gates de aprovação

| Gate | Quem aprova | Artefato |
|------|-------------|----------|
| Spec | **usuário** | `docs/features/{NNN}-{name}/spec.md` |
| Design | **usuário** | `docs/features/{NNN}-{name}/design.md` |
| Implementação | QA | `docs/features/{NNN}-{name}/tasks.md` (status `validado`) |

**Nenhum código é escrito antes dos dois primeiros gates.** O Tech Lead elabora o design; o usuário aprova spec e design explicitamente.

## Execução paralela

Features **independentes** (sem dependência em `tasks.md` / `docs/tasks.md`) podem avançar em paralelo:

| Cenário | Quando paralelizar |
|---------|-------------------|
| Features distintas (A, B, C) | Após spec **e** design de cada uma aprovados pelo usuário |
| Backend + frontend (mesma feature) | Após design aprovado com contratos de API/modelo explícitos |
| QA de features concluídas | Em paralelo, uma validação por feature |

**Não paralelizar** se: dependência não resolvida, overlap de arquivos/contratos, ou design ainda pendente de aprovação do usuário.

Marque dependências no agregador `docs/tasks.md`: `depende_de: {NNN}`, status `bloqueado` até o gate anterior da feature dependente ser aprovado.

## Estados

- Feature: `planejado` → `spec_aprovado` → `design_aprovado` → `em_andamento` → `concluido`
- Tarefa: `pendente` → `em_andamento` → `concluido` → `validado`

## Arquivos-canônico

- `AGENTS.md` — regras para agentes (ler sempre)
- `docs/workflow.md` — este arquivo
- `docs/features/{NNN}-{name}/` — spec, design, tasks por feature
- `docs/prompts/` — intake bruto
- `docs/aprendizados.md` — lições aprendidas
- `docs/tasks.md` — agregador global (PM mantém)
```
