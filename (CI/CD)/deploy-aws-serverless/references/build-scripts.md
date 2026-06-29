# Scripts de Build para Lambda

> Leia esta referência ao criar ou modificar scripts de build de pacotes Lambda para SAM.

## Template genérico

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${ROOT_DIR}/<diretorio-do-codigo>"

BUILD_DIR="$(mktemp -d)"
OUTPUT="${ROOT_DIR}/<nome-do-output>.zip"
export BUILD_DIR OUTPUT
trap 'rm -rf "${BUILD_DIR}"' EXIT

echo "Building Lambda package in ${BUILD_DIR}..."

# 1. Instalar dependências de produção
pip install \
  --quiet \
  --platform manylinux2014_x86_64 \
  --target "${BUILD_DIR}" \
  --implementation cp \
  --python-version 3.12 \
  --only-binary=:all: \
  --upgrade \
  -r "${APP_DIR}/requirements-lambda.txt"

# 2. Copiar código fonte
rsync -a "${APP_DIR}/app/" "${BUILD_DIR}/app/"

# 3. Remover arquivos desnecessários (reduz tamanho do pacote)
find "${BUILD_DIR}" -type d -name tests -prune -exec rm -rf {} + 2>/dev/null || true
find "${BUILD_DIR}" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find "${BUILD_DIR}" -type f -name "*.pyc" -delete 2>/dev/null || true
find "${BUILD_DIR}" -type f -name "*.pyo" -delete 2>/dev/null || true

# 4. Gerar ZIP
rm -f "${OUTPUT}"
(cd "${BUILD_DIR}" && zip -qr "${OUTPUT}" .)

# 5. Verificar tamanho (limite Lambda: 250MB descompactado)
UNCOMPRESSED=$(python3 -c "
import zipfile
with zipfile.ZipFile('${OUTPUT}') as z:
    print(sum(i.file_size for i in z.infolist()))
")
echo "Uncompressed size: ${UNCOMPRESSED} bytes"
if [ "${UNCOMPRESSED}" -gt $((250 * 1024 * 1024)) ]; then
  echo "ERROR: Package exceeds 250MB Lambda limit" >&2
  exit 1
fi

echo "OK: ${OUTPUT} created"
```

## Regras importantes

### requirements-lambda.txt

Criar um arquivo separado do `requirements.txt` com **apenas dependências de produção**.

Exemplo para um backend FastAPI com Telegram:

```
fastapi>=0.115.0
mangum>=0.19.0
boto3>=1.34.0
pydantic>=2.5.0
pydantic-settings>=2.1.0
PyJWT>=2.8.0
python-telegram-bot>=21.0.0
```

> Adapte a lista ao seu projeto. O que importa é: **sem pytest, moto, httpx, sqlalchemy, asyncpg, alembic ou qualquer dependência de dev/teste.**

### Flags do pip

| Flag | Propósito |
|------|-----------|
| `--platform manylinux2014_x86_64` | Compatível com runtime Lambda Python (Linux x86_64) |
| `--only-binary=:all:` | Evita build de pacotes com extensão C (falha sem compilador) |
| `--target <dir>` | Instala no diretório de build para empacotamento |
| `--implementation cp` | CPython (runtime da Lambda) |
| `--python-version 3.12` | Versão do runtime |

### Lambdas que compartilham código

Quando duas Lambdas compartilham código (ex: backend e scheduler/worker), o script da segunda Lambda copia o código da primeira e sobrescreve apenas o handler:

```bash
# Copia código compartilhado
rsync -a "${BACKEND_DIR}/app/" "${BUILD_DIR}/app/"

# Sobrescreve handler específico da segunda Lambda
rsync -a "${WORKER_DIR}/app/handler.py" "${BUILD_DIR}/app/handler.py"
```

### Template SAM — CodeUri

O `CodeUri` no template SAM aponta para o `.zip` gerado:

```yaml
BackendFunction:
  Type: AWS::Serverless::Function
  Properties:
    CodeUri: backend-lambda.zip   # gerado pelo script de build
    Handler: app.handler.handler
```

### Verificação pós-build

```bash
# Listar primeiros arquivos do zip
unzip -l backend-lambda.zip | head -20

# Tamanho comprimido
ls -lh backend-lambda.zip

# Tamanho descompactado
unzip -l backend-lambda.zip | tail -1
```
