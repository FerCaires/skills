#!/usr/bin/env bash
# copy-skills.sh — Copia skills/agentes do repo central para o projeto alvo.
#
# Uso:
#   bash copy-skills.sh \
#     --target /path/to/project \
#     --layout cursor \
#     --skills "(figuras)/pm-ptbr,tdd-ptbr" \
#     --agents "(agentes)/senior-dev-python.md"
#
# Opções:
#   --target DIR       (obrigatório) Raiz do projeto alvo.
#   --layout LAYOUT    cursor (default) | devin | both
#   --skills LIST      Caminhos separados por vírgula no repo central.
#   --agents LIST      Arquivos .md de agente separados por vírgula.
#   --source PATH|URL  Checkout local ou URL (default: https://github.com/FerCaires/skills.git)

set -euo pipefail

SOURCE_URL="${SOURCE_URL:-https://github.com/FerCaires/skills.git}"
TARGET=""
SKILLS=""
AGENTS=""
LAYOUT="cursor"

usage() {
  sed -n '2,/^$/p' "$0" | sed 's/^# \?//' >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)  TARGET="$2";  shift 2 ;;
    --skills)  SKILLS="$2";  shift 2 ;;
    --agents)  AGENTS="$2";  shift 2 ;;
    --source)  SOURCE_URL="$2"; shift 2 ;;
    --layout)  LAYOUT="$2";  shift 2 ;;
    --help|-h) usage ;;
    *) echo "Opção desconhecida: $1" >&2; usage ;;
  esac
done

[[ -z "$TARGET" ]] && { echo "Erro: --target é obrigatório." >&2; usage; }
[[ -z "$SKILLS" && -z "$AGENTS" ]] && { echo "Erro: informe --skills e/ou --agents." >&2; usage; }
[[ "$LAYOUT" != "cursor" && "$LAYOUT" != "devin" && "$LAYOUT" != "both" ]] && {
  echo "Erro: --layout deve ser cursor, devin ou both." >&2; exit 1;
}

TARGET="$(cd "$TARGET" && pwd)"

if [[ -d "$SOURCE_URL" ]]; then
  TMP="$(cd "$SOURCE_URL" && pwd)"
  trap - EXIT
  echo "→ Usando checkout local: $TMP" >&2
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  echo "→ Clonando $SOURCE_URL ..." >&2
  git clone --depth 1 --quiet "$SOURCE_URL" "$TMP"
fi

resolve_skill_path() {
  local input="$1"
  if [[ -d "$TMP/$input" ]]; then
    echo "$TMP/$input"
    return 0
  fi
  local name
  name="$(basename "$input")"
  local found
  found="$(find "$TMP" -maxdepth 4 -type d -name "$name" 2>/dev/null | grep -v '/.git/' | head -1 || true)"
  [[ -n "$found" ]] && { echo "$found"; return 0; }
  return 1
}

resolve_agent_path() {
  local input="$1"
  if [[ -f "$TMP/$input" ]]; then
    echo "$TMP/$input"
    return 0
  fi
  local name
  name="$(basename "$input")"
  local found
  found="$(find "$TMP" -maxdepth 4 -type f -name "$name" 2>/dev/null | grep -v '/.git/' | head -1 || true)"
  [[ -n "$found" ]] && { echo "$found"; return 0; }
  return 1
}

copy_to_layout() {
  local layout="$1"
  local skills_dir agents_dir
  case "$layout" in
    cursor) skills_dir="$TARGET/.cursor/skills"; agents_dir="$TARGET/.cursor/agents" ;;
    devin)  skills_dir="$TARGET/.devin/skills";  agents_dir="$TARGET/.devin/agents" ;;
  esac
  mkdir -p "$skills_dir" "$agents_dir"

  if [[ -n "$SKILLS" ]]; then
    IFS=',' read -ra SKILL_ARRAY <<< "$SKILLS"
    for s in "${SKILL_ARRAY[@]}"; do
      s="$(echo "$s" | xargs)"
      [[ -z "$s" ]] && continue
      src="$(resolve_skill_path "$s" || true)"
      if [[ -z "$src" ]]; then
        echo "  ✗ skill não encontrada: $s" >&2
        return 1
      fi
      name="$(basename "$src")"
      dst="$skills_dir/$name"
      rm -rf "$dst"
      cp -R "$src" "$dst"
      echo "  ✓ [$layout] skill: $name → $skills_dir/$name" >&2
    done
  fi

  if [[ -n "$AGENTS" ]]; then
    IFS=',' read -ra AGENT_ARRAY <<< "$AGENTS"
    for a in "${AGENT_ARRAY[@]}"; do
      a="$(echo "$a" | xargs)"
      [[ -z "$a" ]] && continue
      src="$(resolve_agent_path "$a" || true)"
      if [[ -z "$src" ]]; then
        echo "  ✗ agente não encontrado: $a" >&2
        return 1
      fi
      name="$(basename "$src")"
      cp -f "$src" "$agents_dir/$name"
      echo "  ✓ [$layout] agent: $name → $agents_dir/$name" >&2
    done
  fi
}

echo "→ Copiando para $TARGET (layout: $LAYOUT) ..." >&2

if [[ "$LAYOUT" == "both" ]]; then
  copy_to_layout cursor
  copy_to_layout devin
else
  copy_to_layout "$LAYOUT"
fi

echo "" >&2
echo "Concluído." >&2
exit 0
