---
name: deploy-aws-serverless
description: 'Configura deploy serverless na AWS via GitHub Actions com OIDC, SAM, Lambda, DynamoDB, S3 e CloudFront. Cobre desde o setup inicial (OIDC provider, IAM role) até o workflow CI/CD completo. Use quando criar pipelines de deploy serverless, configurar OIDC para GitHub Actions, escrever templates SAM, ou fazer deploy de Lambda + frontend estático. Também dispare quando o usuário mencionar "deploy na AWS", "GitHub Actions deploy", "sam deploy", "CI/CD serverless", "OIDC setup", "criar workflow de deploy" ou "configurar deploy automático".'
---

# Deploy AWS Serverless com GitHub Actions

## Quick Start

```bash
# 1. Setup OIDC (uma vez por conta)
./scripts/setup-oidc.sh <aws-account-id> <org>/<repo>

# 2. Adicionar secrets no GitHub
# Settings > Secrets > Actions:
#   AWS_DEPLOY_ROLE_ARN (ARN da role do passo 1)
#   mais secrets da aplicação (tokens, senhas, etc.)

# 3. Criar .github/workflows/deploy.yml
# (ver seção "Template SAM" e referência github-workflow.md)

# 4. Fazer push — GitHub Actions executa o deploy automaticamente
```

## Workflows

### 1. Setup OIDC Provider e IAM Role (executar uma vez)

> Referência completa: `references/setup-oidc.md`

O script `setup-oidc.sh` cria os recursos necessários para autenticação OIDC:

- **OIDC Identity Provider** para `token.actions.githubusercontent.com`
- **Role IAM** `GitHubActionsDeployRole` com trust policy restrita ao repositório
- **Policy inline** com permissões escopadas ao prefixo do stack

**Permissões típicas da role:**

| Serviço | Escopo |
|---------|--------|
| CloudFormation | CRUD stacks com prefixo do projeto |
| Lambda | CRUD functions com prefixo |
| DynamoDB | CRUD tables com prefixo |
| S3 | Buckets com prefixo |
| CloudFront | Distributions, invalidação |
| SSM Parameter Store | Parâmetros com prefixo |
| IAM | Roles com prefixo |
| EventBridge Scheduler | Schedules com prefixo |

> O ARN da role é exibido no final. Salvar como `AWS_DEPLOY_ROLE_ARN` no GitHub Secrets.

### 2. GitHub Secrets

**Obrigatório para todos os projetos:**

| Secret | Descrição |
|--------|-----------|
| `AWS_DEPLOY_ROLE_ARN` | ARN da role IAM criada no passo 1 |

**Secrets da aplicação** — variam por projeto. Exemplos típicos:

| Categoria | Exemplos |
|-----------|----------|
| Tokens de API externa | Telegram, Slack, Stripe, etc. |
| Senhas de acesso | Login do app, admin, service accounts |
| Chaves | PIX, criptografia, signing keys |

> Esses secrets são injetados no SSM Parameter Store pelo workflow e lidos pelas Lambdas em runtime. **Nunca devem ser hardcoded no `template.yaml`.**

### 3. Scripts de build do Lambda

Cada função Lambda precisa de scripts que produzem um `.zip` pronto para upload. O `CodeUri` no template SAM aponta para esses zips.

**Regras universais:**
- Instalar deps com `pip --platform manylinux2014_x86_64 --only-binary=:all:` no diretório de build
- Copiar código fonte da aplicação
- Remover `__pycache__`, `tests/`, `*.pyc`, `*.pyo`
- Verificar que o zip descompactado < 250MB (limite da Lambda)
- Usar `requirements-lambda.txt` separado (apenas deps de produção, sem pytest/moto/dev)

> Referência completa: `references/build-scripts.md`

### 4. Template SAM

**Regras universais (aprendidas com erros reais de deploy):**

1. **NUNCA usar `{{resolve:ssm-secure:...}}` em `Environment.Variables`** — CloudFormation não suporta. A Lambda lê secrets do SSM em runtime via `boto3` (`ssm.get_parameter(WithDecryption=True)`).

2. **NUNCA definir variáveis reservadas do Lambda**: `AWS_EXECUTION_ENV`, `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SESSION_TOKEN`, `LAMBDA_TASK_ROOT`, etc. O runtime Lambda as define automaticamente. Definir no template causa erro `PropertyValidation`.

3. **`CORS.AllowedMethods` da Function URL** — Valores válidos: `GET, PUT, HEAD, POST, PATCH, DELETE, *`. `OPTIONS` **não** é aceito e causa erro `PropertyValidation`.

4. **Nomes de tabelas DynamoDB** — Injetar via `!Ref` como env vars da Lambda, nunca hardcoded.

5. **Permissão `ssm:GetParameter`** — Toda Lambda que lê secrets em runtime precisa de IAM policy escopada a `arn:aws:ssm:${AWS::Region}:${AWS::AccountId}:parameter/${AWS::StackName}/*`.

6. **Outputs obrigatórios** — O template deve exportar no mínimo:
   - `FrontendUrl` — URL do CloudFront
   - `BackendUrl` — URL da Lambda Function URL
   - `FrontendBucketName` — Nome do bucket S3
   - `DistributionId` — ID da distribuição CloudFront

7. **Usar OAC, não OAI** — `OriginAccessControl` com `SigningBehavior: always` e `SigningProtocol: sigv4`. A bucket policy usa `cloudfront.amazonaws.com` como principal com condição `AWS:SourceArn` na distribuição. OAI (`S3OriginConfig.OriginAccessIdentity`) é legado e incompatível com buckets de acesso público bloqueado.

   **⚠️ Ao migrar de OAI para OAC:** mantenha `S3OriginConfig: {}` (vazio) no origin. O CloudFront precisa dele para saber que é origem S3. Só colocar `OriginAccessControlId` sem `S3OriginConfig` causa o erro `"Exactly one of CustomOriginConfig, VpcOriginConfig and S3OriginConfig must be specified"`.

   ```yaml
   # ❌ ERRADO — removeu S3OriginConfig
   Origins:
     - Id: S3Origin
       DomainName: !GetAtt FrontendBucket.RegionalDomainName
       OriginAccessControlId: !Ref CloudFrontOriginAccessControl

   # ✅ CORRETO — S3OriginConfig vazio + OriginAccessControlId
   Origins:
     - Id: S3Origin
       DomainName: !GetAtt FrontendBucket.RegionalDomainName
       S3OriginConfig: {}
        OriginAccessControlId: !Ref CloudFrontOriginAccessControl
   ```

8. **CORS: Function URL OU middleware, nunca ambos** — Se o `FunctionUrlConfig` no template SAM define `Cors`, a Lambda Function URL já adiciona headers CORS na borda. A aplicação (FastAPI, Express, etc.) **não** deve ter middleware CORS — isso causa duplicação do header `Access-Control-Allow-Origin` e o erro `"multiple values, but only one is allowed"`.

   ```python
   # ❌ ERRADO — middleware CORS no FastAPI + FunctionUrlConfig.Cors
   app.add_middleware(CORSMiddleware, allow_origins=["*"], ...)

   # ✅ CORRETO — só o FunctionUrlConfig.Cors no template.yaml
   # Nenhum middleware CORS no código da aplicação
   ```

### 5. Workflow GitHub Actions

Estrutura canônica de `.github/workflows/deploy.yml`:

```
jobs:
  test:
    - pytest (ou equivalente para o backend)
    - testes do frontend (ng test, vitest, jest, etc.)

  deploy (needs: test, só na main):
    1. Setup Python + Node
    2. Instalar SAM CLI
    3. OIDC auth → aws-actions/configure-aws-credentials
    4. Inject secrets → SSM Parameter Store
    5. Build Lambda packages (scripts específicos do projeto)
    6. sam validate
    7. sam build
    8. Limpar changesets falhados (evita bloqueio em re-deploys)
    9. sam deploy (com --resolve-s3, --no-confirm-changeset, --no-fail-on-empty-changeset)
    10. Diagnóstico em falha (describe-stack-events)
    11. Obter outputs do stack (URLs, bucket, distribution)
    12. Build frontend com URL do backend (só conhecida após deploy)
    13. Sync S3 + Invalidate CloudFront
    14. Deployment summary
```

**Pontos críticos:**
- Usar OIDC (`permissions: id-token: write`), nunca IAM access keys
- Secrets injetados no SSM **ANTES** do `sam deploy`
- Frontend build **DEPOIS** do deploy (URL do backend é dinâmica)
- Step de diagnóstico condicional em falha (`if: failure()`)

> Referência completa: `references/github-workflow.md`

### 6. SSM Parameter Store

As Lambdas leem secrets do SSM em runtime via `ssm.get_parameter(WithDecryption=True)`. O workflow injeta os valores **antes** do deploy:

```yaml
- name: Inject secrets into SSM Parameter Store
  run: |
    PREFIX="/${{ env.SAM_STACK_NAME }}"
    aws ssm put-parameter \
      --name "${PREFIX}/nome-do-secret" \
      --type SecureString \
      --value "${{ secrets.NOME_DO_SECRET }}" \
      --overwrite
    # Repetir para cada secret da aplicação
```

O mapeamento entre `secrets.GITHUB_SECRET_NAME` → `/<stack>/ssm-parameter-name` é definido pelo projeto. A Lambda deve ler do mesmo path.

### 7. Frontend

O build do frontend ocorre **após** o SAM deploy porque a URL do backend (Lambda Function URL) só é conhecida nesse ponto. O workflow injeta a URL no build:

```yaml
- name: Build frontend with production backend URL
  run: |
    BACKEND_URL="${{ steps.outputs.outputs.backend_url }}"
    API_URL=$(echo "$BACKEND_URL" | sed 's:/*$::')
    # Injetar URL no arquivo de ambiente do framework
    # Angular: frontend/src/environments/environment.prod.ts
    # React: .env.production ou REACT_APP_API_URL
    # Vue: .env.production ou VITE_API_URL
    cd frontend && npm ci && npm run build
```

## Checklist de deploy

- [ ] `setup-oidc.sh` executado na conta AWS (uma vez por conta)
- [ ] GitHub Secrets configurados (`AWS_DEPLOY_ROLE_ARN` + secrets da aplicação)
- [ ] Workflow `.github/workflows/deploy.yml` criado
- [ ] SAM template exporta `FrontendUrl`, `BackendUrl`, `FrontendBucketName`, `DistributionId`
- [ ] Template NÃO usa `{{resolve:ssm-secure}}` em `Environment.Variables`
- [ ] Template NÃO define variáveis reservadas do Lambda (`AWS_EXECUTION_ENV`, `AWS_REGION`, etc.)
- [ ] CloudFront usa OAC (`OriginAccessControl`), não OAI
- [ ] CloudFront origin mantém `S3OriginConfig: {}` junto com `OriginAccessControlId`
- [ ] Bucket policy compatível com OAC (`cloudfront.amazonaws.com` + `AWS:SourceArn`)
- [ ] Lambdas têm permissão `ssm:GetParameter` para `/<stack>/*`
- [ ] Scripts de build geram `.zip` nos paths esperados pelo template
- [ ] `requirements-lambda.txt` sem dependências de teste/dev
- [ ] `sam validate` passa sem lint errors
- [ ] SSM injection executado **antes** do `sam deploy`
- [ ] Limpeza de changesets falhados antes do deploy
- [ ] `--resolve-s3`, `--no-confirm-changeset`, `--no-fail-on-empty-changeset`
- [ ] Diagnóstico de falha com `describe-stack-events`
- [ ] Frontend build **após** deploy (URL do backend dinâmica)
- [ ] Sync S3 + Invalidate CloudFront após build do frontend

## Troubleshooting comum

### Erros de deploy (CloudFormation / SAM)

| Erro | Causa | Solução |
|------|-------|---------|
| `SSM Secure reference is not supported` | Template usa `{{resolve:ssm-secure}}` em `Environment.Variables` | Remover do template. Lambda lê do SSM em runtime. |
| `AWS::EarlyValidation::PropertyValidation` | Variável reservada ou `OPTIONS` no CORS da Function URL | Remover vars reservadas. Remover `OPTIONS` do `CORS.AllowedMethods`. |
| `sam build` não encontra arquivo `.zip` | `CodeUri` aponta para zip não gerado | Executar scripts de build das Lambdas antes do `sam build`. |
| Lambda não carrega secrets | Parâmetro SSM ausente ou sem permissão IAM | Verificar injection no workflow e IAM policy `ssm:GetParameter`. |
| Changeset preso | Changeset anterior falhou e não foi limpo | Step de limpeza de changesets no workflow resolve isso. |
| `Exactly one of CustomOriginConfig, VpcOriginConfig and S3OriginConfig must be specified` | Ao migrar de OAI para OAC, o `S3OriginConfig` foi removido do origin. CloudFront precisa dele (mesmo vazio) para identificar origem S3. | Adicionar `S3OriginConfig: {}` no origin, junto com `OriginAccessControlId`. |

### Erros de acesso (CloudFront + S3)

| Erro | Causa | Solução |
|------|-------|---------|
| `AccessDenied` XML do S3 | Mismatch OAI/OAC: bucket policy usa um mecanismo, distribution usa o outro | Distribution deve usar `OriginAccessControlId` (OAC). Bucket policy usa `cloudfront.amazonaws.com` + `AWS:SourceArn`. Se migrou de OAI, recrie o origin. |
| `403` após deploy bem-sucedido | Distribuição CloudFront propagando (5-10 min) ou cache | Aguardar. Depois: `aws cloudfront create-invalidation --distribution-id <id> --paths "/*"` |
| Erro de CORS no frontend | Function URL não permite origem do CloudFront | Conferir `CORS.AllowOrigins`: deve conter o domínio do CloudFront. |
| `AccessDenied` na Function URL | Lambda retorna 403 no handler | Conferir lógica de auth. Com `AuthType: NONE`, a URL é pública — proteção fica a cargo do código. |
| `Access-Control-Allow-Origin contains multiple values` | CORS duplicado: Function URL + middleware da aplicação (FastAPI CORSMiddleware) ambos adicionam o header | Remover middleware CORS do código. O `FunctionUrlConfig.Cors` no template SAM é suficiente. |
