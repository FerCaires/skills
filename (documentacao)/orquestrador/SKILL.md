---
name: orquestrador
description: Use quando você for o agente orquestrador ou quando for solicitado explicitamente a executar o pipeline de desenvolvimento fixo ponta-a-ponta (contexto→grill→spec→plan→workspace→implement→verify→review→finalize→finish). Não use para edições pontuais de um arquivo nem para responder perguntas.
---

# Orquestrador

Contrato único e fixo do ciclo de desenvolvimento ponta-a-ponta. Uma carga, sem hand-offs internos. Siga as etapas NA ORDEM e nunca pule as obrigatórias.

<EXTREMELY-IMPORTANT>
Toda decisão, clarificação ou aprovação passa pela ferramenta `question`. Você NUNCA decide sozinho. Se não houver resposta do usuário, pare no ponto de decisão, reporte a decisão pendente (opções e consequências) e aguarde — não avance chutando.
</EXTREMELY-IMPORTANT>

## Atalho permitido

Mudança puramente mecânica e sem superfície de design pode pular Grill, Spec e Plan, indo direto ao Workspace. Nenhum caminho pula Workspace, Verify ou Review. A etapa Plan é obrigatória sempre que houver spec.

## Etapa 0 — Contexto

Inspecione o repositório, suas instruções (`AGENTS.md`, `README`, specs existentes) e mudanças recentes antes de perguntar qualquer coisa. Não pergunte ao usuário fatos que o ambiente já responde.

Decida a forma do trabalho:
- Mecânica e sem superfície de design → pule Grill/Spec/Plan, vá ao Workspace.
- Requisitos ou design ambíguos → comece pelo Grill.
- Requisitos claros e merecem documento durável → comece pela Spec.

## Etapa 1 — Grill (decisões)

Resolva um eixo de decisão por vez. Use a ferramenta `question` para toda decisão do usuário:
- Opções conhecidas vão em `options`, cada uma com `label` conciso e `description` da consequência. Liste a recomendada primeiro.
- Quando não puder enumerar opções, chame `question` com `options: []` (texto livre).
- Não peça permissão para continuar quando não restar decisão.

Divida pedidos que abrangem subsistemas independentes antes de refinar cada parte. Não inicie implementação até requisitos e escopo estarem assentados. Sem resposta do usuário, pare e aguarde (não decida sozinho).

### Cenários de teste (obrigatório)

Após assentar requisitos e escopo, solicite ao usuário os **cenários de teste** no modelo **Gherkin E2E**, agrupados em três eixos. Use `question` (texto livre ou opções conforme o caso) para cada eixo:

1. **Happy path** — fluxo nominal, caminho feliz que deve funcionar.
2. **Unhappy path** — entradas inválidas, erros esperados, estados de falha que o sistema deve tratar.
3. **Edge cases** — limites (vazio, cheio, concorrência, off-by-one, Unicode, timeouts, etc.).

Cada cenário segue o formato Gherkin:

```gherkin
Cenário: <descrição>
  Dado <pré-condição>
  Quando <ação>
  Então <resultado esperado>
  E <pós-condição opcional>
```

Se o usuário não souber enumerar todos, comece com os happy paths e pergunte unhappy/edge em seguida. Não avance ao Plan sem ao menos um cenário happy path confirmado.

### Critérios de verificação (obrigatório)

Pergunte ao usuário **como cada task deve ser verificada** — quais comandos rodam, qual saída esperada, e qual o critério de "passando". Registre também verificações automáticas já existentes no repo (`npm test`, `pytest`, `tsc --noEmit`, linters) vs. novas a criar. Isto alimenta as seções `[S4]` e `[S5]` da spec e a etapa Verify.

**Portão:** só avance à Spec com requisitos, escopo, cenários de teste (mín. 1 happy path) e critérios de verificação assentados.

## Etapa 2 — Spec

Cada feature tem uma pasta dedicada em `docs/features/{NNN}-{featureName}/` (zero-padded de 3 dígitos, sequencial por ordem de criação — descubra o próximo número listando as pastas existentes). A spec vive em `docs/features/{NNN}-{featureName}/spec.md`. Edite o documento existente no lugar.

Template do `spec.md`:

```markdown
---
feature: <feature-name>
status: designed | in-progress | delivered
updated: YYYY-MM-DD
branch: <branch-name>
commits: <base-sha>..<head-sha>
---

# <Feature Name>

## Report

## [S1] Problema
Descreva o problema visível ao usuário.

## [S2] Design
Registre o comportamento escolhido e os contratos necessários.

## [S3] Fora de Escopo
Declare limites explícitos.

## [S4] Cenários de Teste (Gherkin E2E)
Cenários coletados no Grill, agrupados por eixo. Cada requisito de design (`[S2]`) deve ter ao menos um cenário que o exerce.

### Happy path
```gherkin
Cenário: <descrição>
  Dado <pré-condição>
  Quando <ação>
  Então <resultado esperado>
```

### Unhappy path
```gherkin
Cenário: <descrição>
  Dado <pré-condição>
  Quando <ação>
  Então <resultado esperado>
```

### Edge cases
```gherkin
Cenário: <descrição>
  Dado <pré-condição>
  Quando <ação>
  Então <resultado esperado>
```

## [S5] Verificação
Como garantir que a construção está correta. Para cada eixo de verificação: o comando exato, a saída esperada e o critério de "passando". Distinga verificações existentes no repo das a criar.
- Comando: `<cmd>` — Esperado: <saída> — Critério: PASS quando <condição>
```

Regras de design: deixe `Report` vazio e `status: designed`; mantenha âncoras `[Sn]` estáveis (nunca renumere); registre decisões e contratos precisos (não histórico de exploração); remova placeholders (TBD, "trate edge cases"). Cada requisito de design (`[S2]`) deve ser coberto por ao menos uma task no `plan.md` e por ao menos um cenário de teste em `[S4]`. Cada cenário em `[S4]` deve ter critério de verificação correspondente em `[S5]`.

**Portão:** obtenha aprovação do usuário sobre a spec via `question` antes de avançar ao Plan.

## Etapa 3 — Plan (fatiar em tasks atômicas)

O plano de implementação vive em `docs/features/{NNN}-{featureName}/plan.md` (mesma pasta da spec). Fatia a spec em tasks atômicas — a menor unidade de trabalho verificável independentemente. Para cada task:
- descrição curta;
- critério de aceite observável (resultado mensurável/verificável);
- `covers:` — seção(ões) da spec que implementa (ex.: `S2`, `S4` para cenários de teste);
- `tests:` — cenário(s) Gherkin de `[S4]` que a task deve fazer passar (quando aplicável);
- `verify:` — comando(s) de `[S5]` que atestam a task;
- `depends:` — apenas pré-requisitos reais; grafo acíclico.

Classifique o que pode rodar em paralelo (conjuntos de arquivos disjuntos) vs. sequencial/acoplado. Registre tudo no `## Tasks` do `plan.md` — é a fonte da delegação na etapa Implement. Toda task de design deve ter `covers:`; toda referência deve resolver. Toda task de comportamento deve indicar em `tests:` qual cenário Gherkin a valida.

Template do `plan.md`:

```markdown
# Plano — <Feature Name>

> **For agentic workers:** REQUIRED SUB-SKILL: Use compose:subagent (recommended) ou compose:execute para implementar este plano task-a-task.

**Goal:** <objetivo>
**Spec:** `docs/features/{NNN}-{featureName}/spec.md`

## Tasks

### Task 1: <descrição>
**Covers:** Sn
**Tests:** <cenário Gherkin de [S4] que esta task faz passar, ou "(n/a)" p/ config-only>
**Verify:** `<cmd de [S5]>` — Esperado: <saída>
**Depends:** (nenhuma)
**Files:** Create/Modify: <lista>
- [ ] **Step 1: <passo>** — Run/Espere
```

**Portão:** obtenha aprovação do usuário sobre o plano via `question` antes de avançar ao Workspace.

## Etapa 4 — Workspace

Nunca comece implementação em `main`/`master` sem consentimento explícito.
1. Compare `git rev-parse --git-dir` com `git rev-parse --git-common-dir`; se diferem, você já está num worktree — não aninhe outro.
2. Crie um worktree ligado sob `.worktrees/` (ou caminho indicado). Confirme que é ignorado (`git check-ignore -q`); se não for, escreva `*` em `.worktrees/.gitignore`. Então `git worktree add "$path" -b "$branch"`. Se o ambiente impedir worktree, reporte a limitação e trabalhe numa branch não-base.
3. Instale dependências conforme instruções do repo; prefira modos congelados (`bun ci`, `uv sync --frozen`). Confirme o toolchain utilizável.

**Portão:** só avance à Implement com worktree pronto e dependências instaladas.

## Etapa 5 — Implement (delegação a subagentes)

Use o `spec.md` (requisitos) e o `plan.md` (tasks) como fonte. Na primeira commit de implementação, marque `status: in-progress` no `spec.md`. Execute as tasks em ordem de dependência; rastreie com a ferramenta `task`.

Para cada task atômica independente, despache um subagente com: caminho do worktree; a task e seu critério de aceite; as seções relevantes da spec (`[S2]` design, `[S4]` cenários Gherkin que a task deve fazer passar, `[S5]` comando de verificação); e a verificação exigida (`verify:` do plan). Não passe histórico de sessão. Mantenha trabalho acoplado junto; os commits ficam com o orquestrador. Trate o relatório do subagente como alegação — inspecione o diff resultante e rode o `verify:` antes de aceitar.

Para mudanças de comportamento com reprodução barata: escreva teste falho, confirme que falha pelo motivo certo, implemente a menor correção, confirme que passa. Bug fix exige teste de regressão quando possível. Pule test-first para código gerado, config-only, protótipos descartáveis ou direção explícita do usuário.

Teste comportamento público; prefira implementações reais a mocks. Para falhas: reproduza antes de editar e identifique a causa-raiz; após 2 correções falhas, pare de remendar e re-derive a causa.

Continue pelas tasks sem pausas rotineiras de aprovação. Pare apenas para decisão de produto não resolvida, bloqueio sem contorno, ação destrutiva exigindo consentimento, ou conclusão.

**Portão:** só avance à Verify com todas as tasks implementadas e integradas.

## Etapa 6 — Verify

Antes de qualquer alegação de conclusão, rode os testes/typecheck/build relevantes do diretório correto e leia a saída. Use a seção `[S5]` do `spec.md` e o campo `verify:` de cada task do `plan.md` como a lista de comandos a executar — não invente comandos novos se os acordados ainda não passam. Registre cada comando e resultado. Marque falhas de baseline conhecidas como `PRE-EXISTING` com identificador curto. Não substitua saída prévia ou relatório de subagente por evidência fresca.

Verificação e revisão são estritamente sequenciais: aguarde todos os comandos de verificação terminarem antes de despachar o revisor.

**Portão:** só avance à Review com a verificação passando (ou falhas marcadas PRE-EXISTING). Todo cenário Gherkin de `[S4]` deve ter sido exercido por ao menos um comando de `[S5]` com resultado PASS.

## Etapa 7 — Review

Despache um subagente fresco para revisar a mudança completa. Forneça: seções aplicáveis da spec (`[S2]` design, `[S4]` cenários Gherkin, `[S5]` verificação) e critérios de aceite; caminho do worktree, branch base, SHA base, SHA head e o comando de diff; e um resumo compacto da verificação (uma linha por comando de `[S5]`: PASS/FAIL/PRE-EXISTING). Não forneça narrativa do implementador.

Exija conclusões separadas para: (1) conformidade com a spec — cada requisito de `[S2]` atendido e cada cenário de `[S4]` exercido; (2) correção (lógica, limites, erros, regressões, testes — incluindo happy/unhappy/edge); (3) consistência com o codebase.

Classifique critérios de aceite não atendidos, cenários Gherkin não exercidos e bugs de correção como críticos. Corrija críticos, re-verifique e re-revisa a área afetada. Rejeite achados incorretos com evidência técnica. Se o loop corrigir-e-revisar não convergir, pare e reporte o impasse ao usuário com os achados restantes (não force aprovação).

**Portão:** só avance à Finalize com a revisão passando.

## Etapa 8 — Finalize

Após a revisão passar e antes de finalizar a branch: marque `status: delivered`, atualize `updated:`, e registre o intervalo revisado `<base-sha>..<head-sha>` no frontmatter do `spec.md`. Marque as tasks concluídas no `plan.md`; deixe incompletas desmarcadas. Substitua a seção `Report` do `spec.md` por: o que foi construído (1-3 parágrafos); verificação (comandos e resultados); journey log (máx. 5 entradas úteis). Commit os documentos finalizados (`spec.md` + `plan.md`) na branch da feature.

## Etapa 9 — Finish

Não auto-finalize. Após Finalize, reporte branch, base, head SHA, worktree e caminho da pasta da feature (`docs/features/{NNN}-{featureName}/`), e sugira uma ação de fechamento. Use `question` para definir: ação de fechamento (merge local / abrir PR / só push / manter branch), branch base alvo, e manter ou remover o worktree. Nunca decida sozinho.