#!/usr/bin/env bash
# copy-skills.sh — Copia skills/agentes selecionados do repo central para .devin/ do projeto alvo.
#
# Uso:
#   bash copy-skills.sh \
#     --target /path/to/new-project \
#     --skills "(figuras)/pm-ptbr,(develop)/(backend)/fastapi,tdd-ptbr" \
#     --agents "(agentes)/senior-dev-python.md,(agentes)/qa-ptbr.md"
#
# Opções:
#   --target DIR       (obrigatório) Diretório raiz do projeto alvo.
#   --skills LIST      (opcional)    Lista separada por vírgulas de caminhos de skills
#                                      no repo central (relativos à raiz do repo).
#                                      Aceita path completo "(figuras)/pm-ptbr" ou
#                                      nome curto "pm-ptbr" (resolve via find).
#   --agents LIST      (opcional)    Lista separada por vírgulas de arquivos de agente
#                                      (relativos à raiz do repo).
#   --source PATH|URL  (opcional, default https://github.com/FerCaires/skills.git)
#                                      URL do repo central de skills OU caminho local
#                                      para um checkout do repo (copia direto, sem clone).
#   --help, -h         Mostra esta ajuda.
#
# Comportamento:
#   1. Clona o repo central em um diretório temporário (shallow clone).
#   2. Cria .devin/skills/ e .devin/agents/ no target (se não existirem).
#   3. Para cada skill em --skills, copia a pasta correspondente para .devin/skills/.
#   4. Para cada agente em --agents, copia o arquivo .md para .devin/agents/.
#   5. Limpa o diretório temporário.
#   6. Imprime resumo do que foi copiado.
#
# Saída: código 0 em sucesso; não-zero em erro. Mensagens em stderr.

set -euo pipefail

SOURCE_URL="${SOURCE_URL:-https://github.com/FerCaires/skills.git}"
TARGET=""
SKILLS=""
AGENTS=""

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
    --help|-h) usage ;;
    *) echo "Opção desconhecida: $1" >&2; usage ;;
  esac
done

[[ -z "$TARGET" ]] && { echo "Erro: --target é obrigatório." >&2; usage; }
[[ -z "$SKILLS" && -z "$AGENTS" ]] && { echo "Erro: informe --skills e/ou --agents." >&2; usage; }

TARGET="$(cd "$TARGET" && pwd)"
SKILLS_DIR="$TARGET/.devin/skills"
AGENTS_DIR="$TARGET/.devin/agents"

# Determina a "raiz do repo central": diretório local se --source for path, clone tmp se for URL.
if [[ -d "$SOURCE_URL" ]]; then
  TMP="$(cd "$SOURCE_URL" && pwd)"
  IS_LOCAL=1
  trap - EXIT
  echo "→ Usando checkout local: $TMP" >&2
else
  TMP="$(mktemp -d)"
  IS_LOCAL=0
  trap 'rm -rf "$TMP"' EXIT
  echo "→ Clonando $SOURCE_URL em $TMP ..." >&2
  git clone --depth 1 --quiet "$SOURCE_URL" "$TMP"
fi

mkdir -p "$SKILLS_DIR" "$AGENTS_DIR"

# Resolve um path de skill: se for nome curto, encontra no repo via find.
resolve_skill_path() {
  local input="$1"
  if [[ -d "$TMP/$input" ]]; then
    echo "$TMP/$input"
    return 0
  fi
  # Nome curto: buscar pasta com esse nome em qualquer categoria.
  local name
  name="$(basename "$input")"
  local found
  found="$(find "$TMP" -maxdepth 3 -type d -name "$name" -path "*/skills/*" -o -type d -name "$name" -path "/*/*" 2>/dev/null | head -1 || true)"
  # Busca mais ampla: qualquer pasta com esse nome (categorias com parênteses).
  if [[ -z "$found" ]]; then
    found="$(find "$TMP" -maxdepth 3 -type d -name "$name" 2>/dev/null | grep -v '/.git/' | head -1 || true)"
  fi
  if [[ -n "$found" ]]; then
    echo "$found"
    return 0
  fi
  return 1
}

# Resolve um path de agente: arquivo .md relativo à raiz do repo.
resolve_agent_path() {
  local input="$1"
  if [[ -f "$TMP/$input" ]]; then
    echo "$TMP/$input"
    return 0
  fi
  local name
  name="$(basename "$input")"
  local found
  found="$(find "$TMP" -maxdepth 3 -type f -name "$name" 2>/dev/null | grep -v '/.git/' | head -1 || true)"
  if [[ -n "$found" ]]; then
    echo "$found"
    return 0
  fi
  return 1
}

copied_skills=()
copied_agents=()
missing=()

if [[ -n "$SKILLS" ]]; then
  IFS=',' read -ra SKILL_ARRAY <<< "$SKILLS"
  for s in "${SKILL_ARRAY[@]}"; do
    s="$(echo "$s" | xargs)"  # trim
    [[ -z "$s" ]] && continue
    src="$(resolve_skill_path "$s" || true)"
    if [[ -z "$src" ]]; then
      missing+=("skill: $s")
      continue
    fi
    name="$(basename "$src")"
    dst="$SKILLS_DIR/$name"
    rm -rf "$dst"
    cp -R "$src" "$dst"
    copied_skills+=("$name")
    echo "  ✓ skill: $name → .devin/skills/$name" >&2
  done
fi

if [[ -n "$AGENTS" ]]; then
  IFS=',' read -ra AGENT_ARRAY <<< "$AGENTS"
  for a in "${AGENT_ARRAY[@]}"; do
    a="$(echo "$a" | xargs)"
    [[ -z "$a" ]] && continue
    src="$(resolve_agent_path "$a" || true)"
    if [[ -z "$src" ]]; then
      missing+=("agent: $a")
      continue
    fi
    name="$(basename "$src")"
    dst="$AGENTS_DIR/$name"
    cp -f "$src" "$dst"
    copied_agents+=("$name")
    echo "  ✓ agent: $name → .devin/agents/$name" >&2
  done
fi

echo "" >&2
echo "Resumo:" >&2
echo "  Skills copiadas: ${#copied_skills[@]} (${copied_skills[*]:-nenhuma})" >&2
echo "  Agentes copiados: ${#copied_agents[@]} (${copied_agents[*]:-nenhum})" >&2
if [[ ${#missing[@]} -gt 0 ]]; then
  echo "  ⚠ Não encontrados no repo central: ${missing[*]}" >&2
  exit 2
fi
exit 0
