#!/usr/bin/env bash
# scan-skills.sh — Varre o repo de skills, compara com o README.md e reporta drift.
#
# Uso:
#   bash scripts/scan-skills.sh            # reporta drift (exit 0 = sync, 1 = drift)
#   bash scripts/scan-skills.sh --fix-total # corrige apenas o total e TOC (não toca nas tabelas)
#
# O script detecta:
#   - Skills/agentes no filesystem que faltam no README.
#   - Entradas no README que não existem no filesystem.
#   - Total desatualizado.
#   - Skills com SKILL.md alterado (git diff) para revisão de descrição.
#
# Categorias são detectadas automaticamente da configuração abaixo.
# (agentes) = arquivos .md; demais = subpastas com SKILL.md.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

README="README.md"
FIX_TOTAL=0
[[ "${1:-}" == "--fix-total" ]] && FIX_TOTAL=1

# ─── Configuração de categorias ──────────────────────────────────────────
# Formato: dir|display_name|type
# type: "agent" (arquivos .md) ou "skill" (subpastas com SKILL.md)
# A ordem define a ordem esperada no README.

CATEGORIES=(
  "(agentes)|Agentes (subagentes)|agent"
  "(figuras)|Figuras (personas/orquestradores)|skill"
  "(documentacao)|Documentação e Processo|skill"
  "(develop)/(backend)|Desenvolvimento — Backend|skill"
  "(develop)/(frontend)|Desenvolvimento — Frontend|skill"
  "(testes)|Testes|skill"
  "(starter)|Starter (bootstrap de projeto)|skill"
  "(CI/CD)|CI/CD|skill"
)

# ─── Helpers ─────────────────────────────────────────────────────────────

fm_field() {
  local file="$1" field="$2"
  local val
  val="$(awk -F"'" "/^${field}: '.*'/ {print \$2; exit}" "$file" 2>/dev/null || true)"
  if [[ -z "$val" ]]; then
    val="$(awk -F": " "/^${field}: / {sub(/^${field}: /, \"\"); print; exit}" "$file" 2>/dev/null || true)"
  fi
  echo "$val"
}

list_skills() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  for sub in "$dir"/*/; do
    [[ -f "${sub}SKILL.md" ]] && echo "${sub%/}"
  done
}

list_agents() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  for f in "$dir"/*.md; do
    [[ -f "$f" ]] && echo "$f"
  done
}

# ─── Varredura ───────────────────────────────────────────────────────────

declare -a FOUND_NAMES=()
declare -a FOUND_PATHS=()
declare -a FOUND_CATS=()

scan_category() {
  local dir="$1" display="$2" type="$3"
  if [[ "$type" == "agent" ]]; then
    while IFS= read -r f; do
      [[ -z "$f" ]] && continue
      local name
      name="$(fm_field "$f" "name")"
      [[ -z "$name" ]] && name="$(basename "$f" .md)"
      FOUND_NAMES+=("$name")
      FOUND_PATHS+=("$f")
      FOUND_CATS+=("$display")
    done < <(list_agents "$dir")
  else
    while IFS= read -r sub; do
      [[ -z "$sub" ]] && continue
      local name
      name="$(fm_field "${sub}/SKILL.md" "name")"
      [[ -z "$name" ]] && name="$(basename "$sub")"
      FOUND_NAMES+=("$name")
      FOUND_PATHS+=("$sub")
      FOUND_CATS+=("$display")
    done < <(list_skills "$dir")
  fi
}

echo "→ Varrendo categorias..." >&2
for cat in "${CATEGORIES[@]}"; do
  IFS='|' read -r dir display type <<< "$cat"
  scan_category "$dir" "$display" "$type"
done

TOTAL=${#FOUND_NAMES[@]}
echo "  Encontrados: $TOTAL skills/agentes" >&2

# ─── Comparação com README ───────────────────────────────────────────────

# Nomes nas tabelas do README (linhas começando com |, coluna **nome**).
README_NAMES="$(grep '^|' "$README" | grep -oE '\*\*[a-zA-Z0-9_-]+\*\*' | tr -d '*' | sort -u || true)"

declare -a MISSING_IN_README=()
declare -a MISSING_IN_FS=()

for i in "${!FOUND_NAMES[@]}"; do
  local_name="${FOUND_NAMES[$i]}"
  if ! echo "$README_NAMES" | grep -qx "$local_name"; then
    MISSING_IN_README+=("$local_name — cat: ${FOUND_CATS[$i]}, path: ${FOUND_PATHS[$i]}")
  fi
done

for rname in $README_NAMES; do
  found=0
  for i in "${!FOUND_NAMES[@]}"; do
    if [[ "${FOUND_NAMES[$i]}" == "$rname" ]]; then
      found=1; break
    fi
  done
  [[ $found -eq 0 ]] && MISSING_IN_FS+=("$rname")
done

README_TOTAL="$(grep -oE 'Total:\*\* [0-9]+' "$README" | grep -oE '[0-9]+' || true)"

# ─── Report ──────────────────────────────────────────────────────────────

DRIFT=0
echo "" >&2

if [[ ${#MISSING_IN_README[@]} -gt 0 ]]; then
  echo "⚠ Skills/agentes no filesystem mas AUSENTES no README:" >&2
  for m in "${MISSING_IN_README[@]}"; do
    echo "  + $m" >&2
  done
  DRIFT=1
fi

if [[ ${#MISSING_IN_FS[@]} -gt 0 ]]; then
  echo "⚠ Entradas no README que NÃO existem no filesystem:" >&2
  for m in "${MISSING_IN_FS[@]}"; do
    echo "  - $m" >&2
  done
  DRIFT=1
fi

if [[ -n "$README_TOTAL" && "$README_TOTAL" != "$TOTAL" ]]; then
  echo "⚠ Total no README ($README_TOTAL) ≠ total no filesystem ($TOTAL)" >&2
  DRIFT=1
fi

# Skills alteradas via git diff.
CHANGED="$(git diff --name-only HEAD 2>/dev/null | grep 'SKILL.md$' || true)"
if [[ -n "$CHANGED" ]]; then
  echo "" >&2
  echo "ℹ Skills com SKILL.md alterado (revise a coluna 'Quando usar' no README se a description mudou):" >&2
  echo "$CHANGED" | sed 's/^/  ~ /' >&2
fi

# Verifica se o TOC tem entradas para todas as categorias com itens.
echo "" >&2
TOC_MISSING=""
for cat in "${CATEGORIES[@]}"; do
  IFS='|' read -r dir display type <<< "$cat"
  has_items=0
  for i in "${!FOUND_NAMES[@]}"; do
    if [[ "${FOUND_CATS[$i]}" == "$display" ]]; then has_items=1; break; fi
  done
  [[ $has_items -eq 0 ]] && continue
  if ! grep -q "\[$display\]" "$README"; then
    TOC_MISSING+=" $display"
  fi
done
if [[ -n "$TOC_MISSING" ]]; then
  echo "⚠ Categorias sem entrada no TOC do README:$TOC_MISSING" >&2
  DRIFT=1
fi

if [[ $DRIFT -eq 0 ]]; then
  echo "✓ README em sync com o filesystem." >&2
  exit 0
fi

# ─── Fix total apenas ────────────────────────────────────────────────────

if [[ $FIX_TOTAL -eq 1 ]]; then
  echo "" >&2
  echo "→ Corrigindo total no README..." >&2
  if grep -q '<!-- BEGIN TOTAL -->' "$README"; then
    sed -i "/<!-- BEGIN TOTAL -->/,/<!-- END TOTAL -->/{
      s/Total:\*\* [0-9]*/Total:** $TOTAL/
    }" "$README"
    echo "  ✓ Total atualizado para $TOTAL." >&2
  else
    echo "  ⚠ Marcadores <!-- BEGIN TOTAL --> não encontrados. Atualize manualmente." >&2
  fi
  echo "  Para adicionar/remover linhas das tabelas, edite o README manualmente." >&2
  echo "  As descrições curadas devem ser escritas à mão (não auto-geradas)." >&2
fi

exit 1
