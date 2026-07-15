# Template — design.md

Use ao gerar `docs/features/{featureName}/design.md`. Adapte seções N/A ao tipo da feature. **Zero código de produção** — só contrato legível.

```markdown
# Design Técnico: [Nome da Feature]

## Visão geral
[1-2 parágrafos com a abordagem técnica escolhida e justificativa]

## Decisões de arquitetura
| Decisão | Alternativas consideradas | Justificativa |
|---------|--------------------------|---------------|
| [Decisão 1] | [Alt A, Alt B] | [Por que escolhemos esta] |

## Modelagem de dados
### Tabelas novas ou alteradas
- Tabela: `[nome]`
- Operação: criar / alterar / remover
- Mudança: colunas, tipos, constraints, índices (linguagem natural)

### Schemas / modelos / types novos
- `NomeSchema` — campos: `campo: tipo`, regras
- `NomeModel` — colunas ORM
- `NomeInterface` (TS) — campos com tipo
- Listar nome, caminho do arquivo, campos e validações. **Não escrever o corpo da classe.**

## Contratos de API
### `METHOD /api/recurso`
- **Descrição:**
- **Parâmetros / body:** campo, tipo, obrigatório/opcional, regras
- **Resposta sucesso:** shape
- **Erros:** status → situação

## Contratos de frontend
### Rotas novas
| Rota | Componente | Guard | Descrição |
|------|-----------|-------|-----------|
| `/rota` | `ComponentName` | — | |

### Services / modelos novos
- `ServiceName.metodo(params) -> Observable<Retorno>` — assinatura e comportamento
- **Não escrever o corpo.**

## Integração com scheduler / workers (se aplicável)
- **Job / trigger:** nome e cron
- **Dependências:** env vars, tabelas, schemas
- **Pontos de falha:**

## Estratégia de testes
- **Unitários / Integração / E2E:** o que cobre cada camada
- **Mocks:** externos a mockar
- **Localização:** paths de teste do projeto
- Obrigações: TDD; 1 cenário feliz + 1 erro por route/service/schema crítico

## Paralelismo
- Tarefas que podem rodar em paralelo após `design_aprovado`:
- Dependências (`depende_de`):

## Tarefas revisadas (espelha docs/tasks.md)
| # | Tarefa | Agent | Skills | Status | Depende de |
|---|--------|-------|--------|--------|------------|
| 1 | | | | pendente | — |

### Observações por tarefa
- Tarefa 1: [interfaces a respeitar, armadilhas, arquivos existentes]

## Checklist de aderência ao SDD.md
- [ ] Contratos/modelos alinhados ao SDD
- [ ] Env vars e infra conforme SDD
- [ ] Regras de negócio críticas do SDD preservadas
- [ ] Locale/mensagens conforme convenção do projeto

## Checklist de TDD
- [ ] Cada implementação tem teste correspondente
- [ ] Estratégia por camada definida
- [ ] Mocks identificados
- [ ] Cobertura mínima: feliz + erro nos pontos críticos
```
