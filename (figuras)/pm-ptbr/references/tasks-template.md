# Tasks: [Nome da Feature]

> Tracker detalhado de tarefas para esta feature. Espelhado no agregador global `docs/tasks.md`.
>
> **Cada linha da tabela é uma tarefa atômica:** concerne único, camada única, ≤1 dia, testável e mergeable isoladamente. Antes de preencher, decomponha a feature seguindo a seção "Decomposição em Tarefas Atômicas" do SKILL.md.

## Status: pendente

| # | Descrição | Camada | Agent | Status | Depende de |
|---|-----------|--------|-------|--------|-----------|
| 1 | Descrição concisa (1 verbo, 1 objeto) | backend | senior-dev-python | pendente | — |
| 2 | Outra tarefa atômica | frontend | senior-dev-angular | pendente | 1 |

### Critérios de aceite — Tarefa 1
- [ ] Critério verificável 1 (Given/When/Then quando possível)
- [ ] Critério verificável 2

### Critérios de aceite — Tarefa 2
- [ ] Critério verificável 1

<!-- Checklist de atomicidade (use mentalmente ao revisar cada linha):
  [ ] Concerne único (sem "e" conectando dois objetivos)
  [ ] Camada única (backend OU frontend OU infra OU docs, nunca mistura)
  [ ] Testável isoladamente (critérios de aceite não dependem de tarefa futura)
  [ ] Mergeable em 1 PR sem quebrar main
  [ ] Tamanho ≤ 1 dia útil
  [ ] Resultado verificável (artefato concreto ao final)
  [ ] Dependências declaradas explicitamente na coluna "Depende de"
-->
