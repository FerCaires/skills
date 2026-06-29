# Spec: [Nome da Feature]

> **ID:** `{NNN}` (gerado por `./scripts/next-demand-id.sh`)
> **Origem da demanda:** `docs/prompts/{MMM}-{slug}.md` (se aplicável)

## Objetivo
[1-2 parágrafos descrevendo o que a feature entrega e por quê]

## Histórias de usuário
- Como [papel], quero [ação] para [benefício].
- ...

## Regras de negócio
- [Regra 1]
- [Regra 2]
- ...

## Tarefas atômicas

### Tarefa 1: [descrição concisa]
- **Camada:** [db | backend | scheduler | frontend]
- **Agent responsável:** [senior-dev-python | senior-dev-angular]
- **Depende de:** [tarefa X ou "nenhuma"]
- **Critério de aceite:**
  - [ ] [Verificável e específico]
  - [ ] [Outro critério]

### Tarefa 2: [descrição concisa]
- ...

## Ordem de execução
1. Tarefa X (sem dependências)
2. Tarefa Y (depende de X)
3. ...

## Dependências externas
- [Serviço externo, variável de ambiente, migração prévia, etc.]

## Skills e agentes relevantes
Mapeamento de skills e agentes (descobertos em `.opencode/`, `.agents/`, `.claude/` e/ou `.devin/`) que serão usados pelas tarefas desta feature:

| Nome | Tipo | Caminho | Por que é relevante | Tarefas que a usam |
|------|------|---------|---------------------|--------------------|
| [nome] | skill | `.agents/skills/fastapi` | [1 frase] | T1, T3 |
| [nome] | agent | `.agents/agents/qa-ptbr` | [1 frase] | T5 |
| ... | ... | ... | ... | ... |

> Esta seção é obrigatória. Registre o caminho completo para desambiguar entre tools. Remova linhas vazias. Se nenhuma skill/agente for relevante, escreva "Nenhuma skill/agente específico necessário".

## Riscos e mitigação
- Risco: [descrição] → Mitigação: [ação]
