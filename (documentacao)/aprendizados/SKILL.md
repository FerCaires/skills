---
name: aprendizados
description: 'Extrai, documenta e consulta aprendizados acumulados do projeto para evitar repetição de erros. Use quando o usuário disser "aprenda com esse ajuste", "guarde esse aprendizado", "aprenda com esse erro", "documente esse padrão", "registre isso para o futuro", "lição aprendida", "isso é importante para as próximas implementações", ou variações similares. Também ative no início de qualquer implementação de feature para consultar aprendizados anteriores.'
---

# Aprendizados — Memória Acumulada do Projeto

## Quick Start

**Ao iniciar qualquer implementação**, leia `docs/aprendizados.md` e aplique as lições ali registradas.

**Quando o usuário disser "aprenda com esse ajuste"** (ou variações):
1. Leia o conteúdo atual de `docs/aprendizados.md`
2. Extraia o aprendizado da conversa (ajuste feito, por quê, impacto)
3. Adicione nova entrada no arquivo
4. Confirme com o usuário

---

## Fluxo de Trabalho

### 1. Consultar aprendizados (antes de implementar)

Sempre que for implementar uma feature, corrigir um bug, ou fazer qualquer alteração no código:

```
1. Leia docs/aprendizados.md
2. Identifique aprendizados relevantes para a tarefa atual
3. Aplique-os durante a implementação
4. Se um aprendizado evitar um erro, mencione isso ao usuário
```

### 2. Registrar novo aprendizado

Quando o usuário sinalizar que algo deve ser aprendido (ex: "aprenda com esse ajuste", "guarde esse padrão", "lição aprendida"):

#### Extrair o aprendizado
Identifique na conversa:
- **O que foi feito** (qual ajuste, correção, ou decisão)
- **Por que foi feito** (motivo, problema que resolveu)
- **Impacto** (o que melhora ou previne)

#### Atualizar `docs/aprendizados.md`

Adicione uma nova entrada no **final** do arquivo (antes de `---` final, se houver) usando o formato de item de lista:

```md
- `AAAA-MM-DD` — **Título:** descrição concisa do ajuste/decisão, motivo e impacto.
```

Cada aprendizado é **um item de lista**, atômico e ordenado do mais antigo para o mais recente.

Se o arquivo não existir, crie-o com o cabeçalho:

```md
# Aprendizados do Projeto

Registro acumulativo de decisões, ajustes e lições aprendidas durante o desenvolvimento.
Consulte este arquivo antes de iniciar qualquer implementação, pois as lições listadas
são de observância obrigatória.
```

#### Confirmar
Após registrar, confirme com o usuário:
> "Aprendizado registrado em `docs/aprendizados.md`. Toda nova implementação consultará automaticamente essa lição."

---

## Exemplo

### Como fica `docs/aprendizados.md`

```md
# Aprendizados do Projeto

Registro acumulativo de decisões, ajustes e lições aprendidas durante o desenvolvimento.
Consulte este arquivo antes de iniciar qualquer implementação.

---

- `2026-06-04` — **Fluxo de implementação:** toda feature passa por PM → Tech Lead → Senior Dev → QA.
- `2026-06-04` — **Formato de data:** configurar locale pt-BR globalmente no Angular com
  `registerLocaleData` + `LOCALE_ID` para que `date:'shortDate'` renderize `dd/MM/yyyy`.
  Necessário porque o locale padrão é en-US. Afeta `app.config.ts`. Usar `shortDate` nos
  templates, não formatos customizados.
```
