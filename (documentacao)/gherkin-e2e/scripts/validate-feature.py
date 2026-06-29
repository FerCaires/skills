#!/usr/bin/env python3
"""
Validador de sintaxe Gherkin para arquivos .feature.
Verifica: sintaxe básica, tags, linguagem PT-BR, estrutura.

Uso:
    python validate-feature.py <arquivo.feature>
    python validate-feature.py tests/features/categorias/CRUD-categorias.feature
"""

import re
import sys
from pathlib import Path


# Palavras-chave Gherkin válidas
GHERKIN_KEYWORDS = {
    "funcionalidade",
    "feature",
    "cenário",
    "scenario",
    "esquema do cenário",
    "scenario outline",
    "contexto",
    "context",
    "background",
    "dado",
    "dado que",
    "given",
    "quando",
    "when",
    "então",
    "then",
    "e",
    "and",
    "mas",
    "but",
    "antès de cada",
    "before each",
    "exemplos",
    "examples",
}

# Termos em inglês que não devem aparecer nos passos
ENGLISH_TERMS = [
    "click",
    "button",
    "field",
    "input",
    "submit",
    "form",
    "page",
    "navigate",
    "should",
    "must",
    "display",
    "show",
    "error message",
    "success message",
    "should be",
    "should have",
]

# Tags válidas do projeto
VALID_TAGS = {"@wip", "@smoke", "@regressao", "@p1", "@p2", "@p3"}


class ValidationIssue:
    def __init__(self, line: int, severity: str, message: str):
        self.line = line
        self.severity = severity  # "error", "warning", "info"
        self.message = message

    def __str__(self):
        icon = {"error": "❌", "warning": "⚠️", "info": "ℹ️"}[self.severity]
        return f"  Linha {self.line}: {icon} {self.message}"


def validate_feature(filepath: str) -> list[ValidationIssue]:
    issues = []
    path = Path(filepath)

    if not path.exists():
        issues.append(ValidationIssue(0, "error", f"Arquivo não encontrado: {filepath}"))
        return issues

    content = path.read_text(encoding="utf-8")
    lines = content.split("\n")

    has_funcionalidade = False
    has_cenario = False
    in_examples_table = False
    previous_keyword = None

    for i, line in enumerate(lines, 1):
        stripped = line.strip()

        # Pular linhas vazias e comentários
        if not stripped or stripped.startswith("#"):
            continue

        # Verificar #language no início
        if i == 1 and not stripped.startswith("#language:"):
            issues.append(ValidationIssue(i, "warning", "Arquivo sem declaração #language: (recomendado #language: pt)"))

        # Verificar tags
        if stripped.startswith("@"):
            tags = re.findall(r"@\w+", stripped)
            for tag in tags:
                if tag not in VALID_TAGS:
                    issues.append(ValidationIssue(i, "info", f"Tag não padrão: {tag}"))
            continue

        # Verificar palavras-chave Gherkin
        line_lower = stripped.lower()

        if line_lower.startswith("funcionalidade") or line_lower.startswith("feature"):
            has_funcionalidade = True
            continue

        if line_lower.startswith("cenário:") or line_lower.startswith("scenario:"):
            has_cenario = True
            in_examples_table = False
            continue

        if line_lower.startswith("esquema do cenário") or line_lower.startswith("scenario outline"):
            has_cenario = True
            in_examples_table = False
            continue

        if line_lower in ("contexto:", "context:", "background:"):
            previous_keyword = line_lower.rstrip(":")
            continue

        if line_lower in ("dado", "dado que", "given"):
            previous_keyword = "given"
            continue

        if line_lower in ("quando", "when"):
            previous_keyword = "when"
            continue

        if line_lower in ("então", "then"):
            previous_keyword = "then"
            continue

        if line_lower in ("e", "and"):
            if previous_keyword is None:
                issues.append(ValidationIssue(i, "warning", "'E' sem keyword anterior (Given/When/Then)"))
            continue

        if line_lower in ("mas", "but"):
            continue

        # Verificar tabela de Exemplos
        if line_lower in ("exemplos:", "examples:"):
            in_examples_table = True
            continue

        if in_examples_table:
            if stripped.startswith("|"):
                continue
            else:
                in_examples_table = False

        # Se chegou aqui, é um passo (step) — verificar conteúdo
        if previous_keyword in ("given", "when", "then"):
            # Verificar termos em inglês nos passos
            for term in ENGLISH_TERMS:
                if term.lower() in line_lower:
                    issues.append(ValidationIssue(i, "warning", f"Possível termo em inglês nos passos: '{term}'"))
                    break

    # Valações globais
    if not has_funcionalidade:
        issues.append(ValidationIssue(0, "error", "Arquivo não contém 'Funcionalidade' ou 'Feature'"))

    if not has_cenario:
        issues.append(ValidationIssue(0, "error", "Arquivo não contém nenhum 'Cenário' ou 'Scenario'"))

    return issues


def main():
    if len(sys.argv) < 2:
        print("Uso: python validate-feature.py <arquivo.feature>")
        sys.exit(1)

    filepath = sys.argv[1]
    issues = validate_feature(filepath)

    if not issues:
        print(f"✅ {filepath}: Validação passou sem erros.")
        sys.exit(0)

    errors = [i for i in issues if i.severity == "error"]
    warnings = [i for i in issues if i.severity == "warning"]
    infos = [i for i in issues if i.severity == "info"]

    print(f"\n📋 Validação de: {filepath}")
    print(f"   {len(errors)} erro(s), {len(warnings)} aviso(s), {len(infos)} info(s)\n")

    for issue in issues:
        print(str(issue))

    print()

    if errors:
        print("❌ Validação falhou.")
        sys.exit(1)
    else:
        print("⚠️  Validação passou com avisos.")
        sys.exit(0)


if __name__ == "__main__":
    main()
