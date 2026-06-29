---
name: intake-ptbr
description: 'Captura o pedido bruto do usuário e a interpretação inicial da demanda em `docs/prompts/{NNN}-{slug}.md` **antes** de acionar o PM, bug-fix ou qualquer outro agent. Garante que a demanda original fique registrada e auditável, separada da `spec.md` reescrita pelo PM. Use no início de qualquer nova demanda/pedido/tarefa que gere trabalho — feature, bug, ajuste, refatoração, pesquisa, aprendizado. Também ative quando o usuário disser "criar", "implementar", "planejar", "corrigir", "refatorar", "preciso de", "vamos fazer", "quero que", "temos que", "adicione", "mude", "faça", ou iniciar uma frase que claramente é um pedido de trabalho.'
---

# Intake — Captura da Demanda Bruta

> **Propósito:** registrar o pedido original do usuário e a interpretação inicial **antes** que qualquer agent reescreva, refine ou especifique a demanda. É a fonte de verdade do que foi pedido.

---

## Quick Start

Quando o usuário enviar uma nova demanda:

1. **Identifique** se é uma demanda de trabalho (não conversa casual).
2. **Obtenha o próximo ID** rodando `./scripts/next-demand-id.sh prompt` na raiz do repo. O contador de prompts é **independente** dos contadores de features e bugs.
3. **Crie** `docs/prompts/{NNN}-{slug}.md` com:
   - **NNN** = ID retornado pelo script (3 dígitos, zero-padded)
   - **slug** curto em kebab-case, sem acentos (ex: `exportar-despesas-csv`)
   - Texto bruto (verbatim, em bloco de código)
   - Interpretação inicial (objetivo, escopo, critério de pronto, ambiguidades)
   - Tipo provável e agent de destino
4. **Confirme o entendimento** com o usuário se houver ambiguidade material.
5. **Passe o caminho do arquivo** como insumo primário para o próximo agent (PM, bug-fix, etc.).

> **Regra de ouro:** o intake **nunca substitui** a entrevista do PM. Ele captura o pedido bruto para rastreabilidade. A `spec.md` continua sendo a versão estruturada para o trabalho.
> **Numeração por tipo:** o ID do prompt entra em um contador **independente** do contador de features e bugs. Cada tipo (`prompt`, `feature`, `bug`) tem sua própria sequência.

---

## Workflows

### Workflow 1 — Captura inicial

1. **Receba a demanda** do usuário.
2. **Classifique o tipo** provável:
   - `feature` — nova funcionalidade → destino: `pm-ptbr`
   - `bug` — defeito/comportamento incorreto → destino: `bug-fix`
   - `ajuste` — mudança pequena em algo existente → destino: `tech-lead-ptbr` ou senior-dev direto
   - `refatoracao` — melhoria de código sem mudar comportamento → destino: `tech-lead-ptbr`
   - `pesquisa` — pergunta, exploração, levantamento → destino: nenhum (responder direto)
   - `aprendizado` — registrar lição aprendida → destino: `aprendizados`
3. **Crie a pasta `docs/prompts/`** se não existir.
4. **Obtenha o próximo ID** rodando na raiz do repo:
   ```bash
   ./scripts/next-demand-id.sh prompt            # próximo ID de prompt
   ./scripts/next-demand-id.sh prompt --check    # inspecionar último ID sem reservar
   ```
   O script retorna o próximo número disponível (3 dígitos, zero-padded) **no contador de prompts** (`docs/prompts/`). O contador de prompts é independente dos contadores de features e bugs.
5. **Defina o slug**: kebab-case, sem acentos, 3–6 palavras, derivado do pedido. Exemplos:
   - "Quero exportar despesas para CSV" → `exportar-despesas-csv`
   - "O dashboard fica carregando eternamente" → `001-dashboard-loading-infinito`
   - "Adicione um filtro por período" → `filtro-periodo-despesas`
6. **Crie o arquivo** `docs/prompts/{NNN}-{slug}.md` (ex: `001-exportar-despesas-csv.md`) com o template abaixo.
7. **Prossiga** com o agent adequado, **passando o caminho do intake** como referência obrigatória.

### Workflow 2 — Verificação de ambiguidade

Após registrar, avalie:

| Pergunta | Resposta | Ação |
|----------|----------|------|
| O pedido é claro o suficiente para iniciar trabalho? | Sim | Prosseguir com o agent de destino. |
| | Não | Fazer perguntas de clarificação **antes** de acionar o próximo agent. Registrar as respostas no mesmo intake, seção "Respostas de clarificação". |
| A demanda é continuação de uma feature existente? | Sim | Referenciar a feature em `docs/features/{x}/` no intake e prosseguir com a tarefa correspondente. |
| | Não | Prosseguir com criação de nova feature. |
| A demanda é uma confirmação, resposta ou continuação de trabalho já em curso? | Sim | **Não criar novo intake.** Apenas referenciar o intake anterior. |

> **Em caso de dúvida:** registre o intake. É barato e o pior que acontece é ter um arquivo a mais em `docs/prompts/`.

### Workflow 3 — Encaminhamento

| Tipo | Próximo agent | Comando |
|------|---------------|---------|
| `feature` nova | `pm-ptbr` | Acionar skill PM informando o caminho do intake |
| `bug` | `bug-fix` | Acionar skill bug-fix informando o caminho do intake |
| `ajuste` pequeno | `tech-lead-ptbr` ou senior-dev direto | Acionar skill específica |
| `refatoracao` | `tech-lead-ptbr` | Acionar skill tech-lead |
| `pesquisa` | nenhum | Responder diretamente (não criar intake, ou criar com tipo `pesquisa` se for exploração relevante) |
| `aprendizado` | `aprendizados` | Acionar skill aprendizados |

> **Regra de integração:** o próximo agent **deve ler o arquivo de intake** antes de iniciar seu trabalho. Trate o intake como insumo primário, não opcional.

---

## Template do arquivo de intake

```markdown
# Intake: {NNN}-{slug}

> Pedido bruto do usuário + interpretação inicial. Este arquivo é a fonte de verdade da demanda original e deve ser lido por qualquer agent subsequente (PM, Tech Lead, dev) antes de iniciar o trabalho.

- **ID da demanda:** {NNN} (gerado por `./scripts/next-demand-id.sh`)
- **Data/hora:** {YYYY-MM-DDTHH:MM}
- **Origem:** chat do opencode (sessão local)
- **Tipo provável:** {feature | bug | ajuste | refatoracao | pesquisa | aprendizado}
- **Status:** {aguardando-clarificacao | encaminhado | em-trabalho | concluido | cancelado}
- **Encaminhado para:** {pm-ptbr | bug-fix | tech-lead-ptbr | ... | nenhum}

## Texto bruto do usuário

\`\`\`
{texto exato enviado pelo usuário, sem alterações, em bloco de código}
\`\`\`

## Interpretação inicial

> O que eu entendi que está sendo pedido. Seja explícito sobre objetivo, escopo, critério de pronto, e ambiguidades.

- **Objetivo:** {o que o usuário quer alcançar}
- **Escopo percebido:**
  - **Dentro:** {o que parece estar dentro do escopo}
  - **Fora:** {o que parece estar fora do escopo}
- **Critério de "pronto" provável:** {como saberemos que a demanda foi atendida}
- **Skills/agents prováveis:** {lista de skills que provavelmente serão usadas}
- **Demandas existentes relacionadas:** {refs em `docs/features/{NNN}-{slug}/` ou `docs/bugs/{NNN}-{slug}/` ou `docs/tasks.md`, se houver}
- **Pontos ambíguos:** {tudo o que precisa ser clarificado antes de prosseguir}

## Respostas de clarificação (se houver)

> Esta seção é preenchida quando o agente faz perguntas de clarificação antes de encaminhar.

- **Pergunta:** {pergunta feita}
  **Resposta:** {resposta do usuário}
- ...

## Próximo passo

- [ ] {ação 1, ex: "Acionar PM para entrevista de escopo"}
- [ ] {ação 2, ex: "Confirmar com o usuário se o tipo é mesmo 'feature' ou se é 'ajuste'"}
- [ ] ...

## Desfecho (preenchido ao final)

> Preenchido quando o trabalho é concluído ou cancelado. Referencia onde a demanda virou código/documento.

- **Virou:** {`docs/features/{MMM}-{nova-feature}/spec.md` | `docs/bugs/{MMM}-{identificador}/` | `commit abc123` | `cancelado`}
- **Concluído em:** {YYYY-MM-DDTHH:MM}

## Histórico de encaminhamento

| Data/hora | De | Para | Observação |
|-----------|----|------|------------|
| {agora} | intake-ptbr | {próximo agent} | Encaminhado para início do trabalho |
| ... | ... | ... | ... |
```

---

## Quando NÃO usar esta skill

- **Perguntas conversacionais** (não há trabalho a fazer). Ex: "o que é FastAPI?", "como funciona o Angular?"
- **Continuação de trabalho já em andamento** onde o intake já foi feito — apenas referencie o intake existente.
- **Confirmações ou respostas** a perguntas do agent. Ex: "ok, pode seguir", "sim, é isso mesmo".
- **Saída do próprio sistema** (logs, mensagens de erro já tratadas por outras skills).

> **Dica de calibração:** se a frase do usuário **não termina** com uma expectativa de trabalho (algo vai ser produzido/alterado), não crie intake.

---

## Integração com outras skills

| Skill consumidora | Como usar o intake |
|-------------------|---------------------|
| `pm-ptbr` | Ler o intake **antes** da entrevista. Usar o texto bruto como ponto de partida, validar a interpretação, refinar com o usuário. A `spec.md` resultante deve referenciar o caminho do intake na seção "Origem da demanda". |
| `bug-fix` | Ler o intake **antes** da triagem. Usar o texto bruto como relato inicial do bug. O `index.md` do bug deve referenciar o caminho do intake. |
| `tech-lead-ptbr` | Ler o intake **antes** de gerar o `design.md`. Usar para contextualizar a decisão técnica. |
| `aprendizados` | Se o intake registra um aprendizado (não um trabalho), seguir o fluxo de `docs/aprendizados.md`. |

> **Padrão de referência na spec/design/bug-report:** incluir no início do documento:
> ```markdown
> **Origem da demanda:** `docs/prompts/{NNN}-{slug}.md`
> ```

---

## Exemplos

### Exemplo 1 — Demanda clara de feature

**Usuário:** "Quero adicionar uma funcionalidade de exportar despesas para CSV."

**Comando:** `./scripts/next-demand-id.sh prompt` → retorna `001` (primeiro prompt)

**Intake gerado:** `docs/prompts/001-exportar-despesas-csv.md`

```markdown
# Intake: 001-exportar-despesas-csv

- **ID da demanda:** 001
- **Data/hora:** 2026-06-16T14:30
- **Origem:** chat do opencode
- **Tipo provável:** feature
- **Status:** encaminhado
- **Encaminhado para:** pm-ptbr

## Texto bruto do usuário

\`\`\`
Quero adicionar uma funcionalidade de exportar despesas para CSV.
\`\`\`

## Interpretação inicial

- **Objetivo:** permitir que o usuário baixe um arquivo CSV com todas as despesas (provavelmente filtradas por período).
- **Escopo percebido:**
  - **Dentro:** endpoint backend `/api/despesas/export`, botão na tela de listagem de despesas.
  - **Fora:** formatação customizada, agendamento, envio por email.
- **Critério de "pronto" provável:** usuário consegue baixar um `.csv` com as despesas do período selecionado.
- **Skills/agents prováveis:** `pm-ptbr` (entrevista), `fastapi` (endpoint), `postgresql` (queries de filtro), `angular-material` (botão na UI).
- **Demandas existentes relacionadas:** `005-crud-despesas` (reaproveitar repository e filtros).
- **Pontos ambíguos:** quais colunas exatas no CSV? filtros disponíveis? encoding (UTF-8 vs latin1)?

## Próximo passo

- [x] Acionar PM para entrevista de escopo.
- [ ] Confirmar colunas, filtros e encoding do CSV na entrevista.

## Histórico de encaminhamento

| Data/hora | De | Para | Observação |
|-----------|----|------|------------|
| 2026-06-16T14:30 | intake-ptbr | pm-ptbr | Encaminhado para início do trabalho |
```

### Exemplo 2 — Bug reportado

**Usuário:** "O dashboard fica carregando eternamente quando não tem despesas cadastradas."

**Comando:** `./scripts/next-demand-id.sh prompt` → retorna `001` (primeiro prompt)

**Intake gerado:** `docs/prompts/001-dashboard-loading-infinito.md`

(O `bug-fix` skill então cria `docs/bugs/001-dashboard-loading-infinito/` — note que o intake e o bug têm IDs **independentes** porque cada tipo tem seu próprio contador. Ambos compartilham o slug `dashboard-loading-infinito` por referenciarem a mesma demanda.)

### Exemplo 3 — Pedido ambíguo (faz clarificação antes de encaminhar)

**Usuário:** "Precisamos melhorar o dashboard."

**Comando:** `./scripts/next-demand-id.sh prompt` → retorna `002` (segundo prompt)

**Intake gerado:** `docs/prompts/002-melhorar-dashboard.md`

```markdown
# Intake: 002-melhorar-dashboard

- **ID da demanda:** 002
- **Data/hora:** 2026-06-16T15:00
- **Origem:** chat do opencode
- **Tipo provável:** feature
- **Status:** aguardando-clarificacao
- **Encaminhado para:** nenhum

## Texto bruto do usuário

\`\`\`
Precisamos melhorar o dashboard.
\`\`\`

## Interpretação inicial

- **Objetivo:** incerto — "melhorar" é vago.
- **Escopo percebido:**
  - **Dentro:** incerto.
  - **Fora:** incerto.
- **Critério de "pronto" provável:** incerto.
- **Pontos ambíguos:** o que exatamente precisa melhorar? performance, visual, novas métricas, novos gráficos?

## Respostas de clarificação

- **Pergunta:** "O que você quer dizer com 'melhorar o dashboard'? Performance, visual, novos gráficos, novas métricas?"
  **Resposta:** "Quero adicionar um gráfico de pizza por categoria."
- **Pergunta:** "Esse gráfico deve estar na tela atual do dashboard ou em uma nova tela?"
  **Resposta:** "Na tela atual, ao lado do gráfico de evolução."

## Próximo passo

- [x] Clarificar escopo com o usuário.
- [ ] Manter o slug `melhorar-dashboard` (o ID fica reservado e a interpretação inicial é atualizada).
- [ ] Acionar `pm-ptbr` com escopo refinado.

## Histórico de encaminhamento

| Data/hora | De | Para | Observação |
|-----------|----|------|------------|
| 2026-06-16T15:00 | intake-ptbr | (pendente) | Aguardando clarificação |
```

> **Nota sobre IDs reservados:** o ID atribuído ao intake é "gasto" mesmo se a demanda for cancelada ou renomeada — isso preserva a contagem monotônica. Se múltiplos intakes forem criados para a mesma demanda, mantenha apenas o mais antigo e cancele os demais (mude o status para `cancelado` no campo Status).

---

## Versionamento e limpeza

- **Não delete** intakes antigos. Eles são histórico do projeto.
- Se um intake for criado por engano, marque-o como `cancelado` na seção "Status" e preencha "Desfecho" com `cancelado`. **O ID permanece reservado** — não é reusado, mesmo após cancelamento.
- Se múltiplos intakes forem criados para a mesma demanda, consolide em um único arquivo e referencie os demais como relacionados. Cancele os IDs redundantes.

---

## Referências

- Skill PM (consumidora): `.agents/skills/pm-ptbr/SKILL.md`
- Skill Bug Fix (consumidora): `.agents/skills/bug-fix/SKILL.md`
- Skill Tech Lead (consumidora): `.agents/skills/tech-lead-ptbr/SKILL.md`
- Script de numeração: `scripts/next-demand-id.sh`
- Memória global do projeto: `docs/tasks.md`
- Spec global: `SDD.md`
