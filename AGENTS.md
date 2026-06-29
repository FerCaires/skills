# AGENTS.md — Repositório de Skills

> Regras obrigatórias para qualquer agente de IA que atue neste repo. **Leia antes de qualquer ação.**

## O que é este repo

Repositório centralizado de skills e agentes de IA (formato `SKILL.md` com frontmatter `name` + `description`), organizados em pastas por categoria com parênteses: `(agentes)`, `(figuras)`, `(documentacao)`, `(develop)`, `(testes)`, `(starter)`, `(CI/CD)`.

O `README.md` é o **catálogo público** — tem tabelas por categoria com descrições curadas de cada skill/agente. Ele deve refletir exatamente o que existe no filesystem.

## Regra de ouro: README em sync antes de qualquer push

**Antes de qualquer `git push` para qualquer branch**, execute obrigatoriamente:

```bash
bash scripts/scan-skills.sh
```

Este script varre todas as categorias, compara com o `README.md` e reporta drift:
- Skills/agentes no filesystem que faltam no README.
- Entradas no README que não existem mais no filesystem.
- Total desatualizado.
- Categorias sem entrada no TOC.
- Skills com `SKILL.md` alterado (para revisar se a descrição no README mudou).

### Se o script reportar drift (exit 1)

**NÃO faça push.** Corrija o `README.md` primeiro:

1. **Skills novas** (sinalizadas com `+`): adicione uma linha na tabela da categoria correspondente, no formato:
   ```
   | **nome** | `(categoria)/nome/` | Descrição curada de "quando usar" (não copie o frontmatter bruto — escreva uma versão curta e acionável). |
   ```
   Para agentes (em `(agentes)/`), use a coluna "Arquivo" em vez de "Pasta":
   ```
   | **nome** | `(agentes)/nome.md` | Descrição curada. |
   ```

2. **Skills removidas** (sinalizadas com `-`): delete a linha correspondente da tabela.

3. **Total desatualizado**: rode `bash scripts/scan-skills.sh --fix-total` para corrigir automaticamente o total entre os marcadores `<!-- BEGIN TOTAL -->` / `<!-- END TOTAL -->`, ou edite manualmente.

4. **Categoria sem TOC**: adicione uma linha `  - [Nome da Categoria](#anchor)` no índice, abaixo de `- [Categorias](#categorias)`.

5. **Skills alteradas** (sinalizadas com `~`): leia o `SKILL.md` alterado e verifique se a coluna "Quando usar" no README ainda reflete a skill. Se a `description` do frontmatter mudou significativamente, atualize a descrição curada no README.

6. **Re-run**: após corrigir, rode `bash scripts/scan-skills.sh` novamente. Só faça push quando o script retornar `✓ README em sync com o filesystem.` (exit 0).

### O que NÃO fazer

- ❌ Fazer push com drift detectado.
- ❌ Copiar o `description` do frontmatter diretamente para o README — ele é longo; escreva uma versão curta e acionável.
- ❌ Reordenar tabelas existentes arbitrariamente — mantenha a ordem atual; só adicione novos ao final da tabela da categoria.
- ❌ Editar as seções "Fluxo recomendado entre skills" ou "Convenções do repositório" sem revisão manual — elas são conteúdo curado.

## Convenções do repo

- Pastas de categoria usam parênteses: `(agentes)`, `(figuras)`, `(documentacao)`, `(develop)`, `(testes)`, `(starter)`, `(CI/CD)`.
- Skills são subpastas com `SKILL.md` (frontmatter `name` + `description`).
- Agentes são arquivos `.md` soltos em `(agentes)/`.
- Toda skill deve seguir o padrão `write-a-skill` (Quick Start, description < 1024 chars, SKILL.md < 500 linhas, `references/` para conteúdo avançado).
- Skills técnicas (backend/frontend) **exigem** `tdd-ptbr` carregada antes de escrever código.
- Skills de persona conduzem entrevistas **sem limite de perguntas** (exaustivas), uma por turno, sempre oferecendo uma `Resposta recomendada`.
- Textos em **português brasileiro** quando aplicável (skills pt-BR).

## Categorias e ordem esperada no README

1. Agentes (subagentes) — `(agentes)/`
2. Figuras (personas/orquestradores) — `(figuras)/`
3. Documentação e Processo — `(documentacao)/`
4. Desenvolvimento — Backend — `(develop)/(backend)/`
5. Desenvolvimento — Frontend — `(develop)/(frontend)/`
6. Testes — `(testes)/`
7. Starter (bootstrap de projeto) — `(starter)/`
8. CI/CD — `(CI/CD)/`
9. Meta (autoria de skills) — `.devin/skills/write-a-skill/` (cópia ativa)

> Se criar uma nova categoria, adicione-a à lista `CATEGORIES` no `scripts/scan-skills.sh` e ao TOC do README.

## Scripts disponíveis

| Script | O que faz |
|--------|-----------|
| `scripts/scan-skills.sh` | Varre categorias, compara com README, reporta drift. Exit 0 = sync, 1 = drift. |
| `scripts/scan-skills.sh --fix-total` | Corrige apenas o total no README (entre marcadores). Não toca nas tabelas. |
| `(starter)/scaffold-ptbr/scripts/copy-skills.sh` | Copia skills/agentes deste repo para `.devin/` de outro projeto. |
