# Heurísticas de Detecção de Stack

Rode antes da entrevista. Confirme com o usuário — heurística ≠ decisão.

| Marcador | Stack detectada |
|----------|-----------------|
| `pyproject.toml` / `requirements.txt` | Python |
| `package.json` + `typescript` | Node/TS |
| `angular.json` | Angular |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `pom.xml` / `build.gradle*` | Java |
| `phaser` em deps ou `docs/GDD.md` | Jogo web |
| Nenhum marcador | Projeto novo |

Se detectado, confirme: "Detectei {stack} por {marcador}. Confirma ou é outra stack?"
