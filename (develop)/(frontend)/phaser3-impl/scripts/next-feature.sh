#!/usr/bin/env bash
#
# Lista as features em docs/ no padrão {NNN}-{name}/ (com gdd.md), ordenadas,
# com status de implementação lido de IMPL.md, e aponta a próxima pendente.
#
# Uso: bash .devin/skills/phaser3-impl/scripts/next-feature.sh [docs_dir]
#
# Convenção de status (em docs/{NNN}-{name}/IMPL.md):
#   **Status:** pendente | em andamento | implementado
#
# A próxima feature é a primeira (em ordem NNN) que possui gdd.md e:
#   - não tem IMPL.md, OU
#   - IMPL.md com Status != "implementado".

set -euo pipefail

DOCS_DIR="${1:-docs}"

if [ ! -d "$DOCS_DIR" ]; then
  echo "Diretório $DOCS_DIR não encontrado." >&2
  exit 1
fi

next=""

# find com regex: pastas de 3 dígitos + hífen + nome. Ordena numericamente.
while IFS= read -r dir; do
  name="$(basename "$dir")"

  if [ ! -f "$dir/gdd.md" ]; then
    continue
  fi

  impl="$dir/IMPL.md"
  if [ ! -f "$impl" ]; then
    status="sem IMPL.md (pendente)"
  else
    s="$(grep -iE '^[[:space:]]*\*\*Status:\*\*' "$impl" | head -1 | sed -E 's/^[[:space:]]*\*\*[Ss]tatus:\*\*[[:space:]]*//I')"
    status="${s:-status indefinido em IMPL.md}"
  fi

  printf '%s : %s\n' "$name" "$status"

  if [ -z "$next" ]; then
    if [ ! -f "$impl" ] || ! grep -iEq '^[[:space:]]*\*\*Status:\*\*[[:space:]]*implementado' "$impl"; then
      next="$name"
    fi
  fi
done < <(find "$DOCS_DIR" -maxdepth 1 -mindepth 1 -type d -regex '.*/[0-9][0-9][0-9]-[^/]*' | sort)

echo "---"
if [ -n "$next" ]; then
  echo "PRÓXIMA: $next"
else
  echo "PRÓXIMA: (nenhuma feature pendente — todas implementadas ou sem gdd.md)"
fi
