# Workflow GitHub Actions de Deploy

> Leia esta referência ao criar ou modificar `.github/workflows/deploy.yml`.

## Template completo

Substitua os placeholders `<...>` pelos valores do seu projeto.

```yaml
name: Deploy to AWS

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

env:
  AWS_REGION: us-east-1
  SAM_STACK_NAME: <nome-do-stack>
  PYTHON_VERSION: "<versao-python>"
  NODE_VERSION: "<versao-node>"

jobs:
  test:
    name: Testes
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Instalar dependencias Python
        working-directory: <diretorio-backend>
        run: pip install -r requirements-dev.txt

      - name: Testes backend
        working-directory: <diretorio-backend>
        run: python -m pytest tests/ -v --tb=short

      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Instalar dependencias Node
        working-directory: <diretorio-frontend>
        run: npm ci

      - name: Testes frontend
        working-directory: <diretorio-frontend>
        run: npm test -- --watch=false --browsers=ChromeHeadless

  deploy:
    name: Deploy para AWS
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Instalar AWS SAM CLI
        run: pip install aws-sam-cli

      - name: Configurar credenciais AWS (OIDC)
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_DEPLOY_ROLE_ARN }}
          aws-region: ${{ env.AWS_REGION }}

      # --- Inject secrets into SSM (ANTES do deploy) ---
      # Adicione um aws ssm put-parameter para CADA secret da aplicação.
      # O nome do parâmetro SSM deve bater com o que a Lambda usa em runtime.
      - name: Inject secrets into SSM Parameter Store
        run: |
          PREFIX="/${{ env.SAM_STACK_NAME }}"
          aws ssm put-parameter \
            --name "${PREFIX}/<nome-do-parametro>" \
            --type SecureString \
            --value "${{ secrets.<NOME_DO_SECRET> }}" \
            --overwrite

      # --- Build Lambda packages ---
      # Liste aqui os scripts de build do seu projeto.
      - name: Build Lambda packages
        run: |
          bash scripts/<build-backend>.sh
          bash scripts/<build-scheduler>.sh

      - name: SAM Validate
        run: sam validate --region ${{ env.AWS_REGION }}

      - name: SAM Build
        run: sam build

      # Limpar changesets falhados evita bloqueio em re-deploys
      - name: Limpar changesets antigos falhados
        run: |
          set +e
          echo "=== Limpando changesets antigos falhados ==="
          aws cloudformation list-change-sets \
            --stack-name ${{ env.SAM_STACK_NAME }} \
            --region ${{ env.AWS_REGION }} \
            --output json 2>/dev/null | python3 -c "
          import sys, json, subprocess
          try:
            data = json.load(sys.stdin)
            for cs in data.get('Summaries', []):
              if cs.get('Status') == 'FAILED':
                cs_id = cs['ChangeSetId']
                print(f'  Deletando changeset falhado: {cs_id}')
                subprocess.run(['aws', 'cloudformation', 'delete-change-set',
                  '--change-set-name', cs_id,
                  '--region', '${{ env.AWS_REGION }}'],
                  capture_output=True, text=True)
            print('  Limpeza concluida.')
          except Exception as ex:
            print(f'  Erro ao limpar changesets: {ex}')
          "

      - name: SAM Deploy
        id: sam_deploy
        run: |
          sam deploy \
            --stack-name ${{ env.SAM_STACK_NAME }} \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
            --resolve-s3 \
            --no-confirm-changeset \
            --no-fail-on-empty-changeset \
            --parameter-overrides <StageName=prod>

      - name: Diagnostico de falha do deploy
        if: failure() && steps.sam_deploy.outcome == 'failure'
        run: |
          echo "=== Eventos do CloudFormation ==="
          aws cloudformation describe-stack-events \
            --stack-name ${{ env.SAM_STACK_NAME }} \
            --region ${{ env.AWS_REGION }} \
            --output json | python3 -c "
          import sys, json
          try:
            data = json.load(sys.stdin)
            for e in data.get('StackEvents', []):
              status = e.get('ResourceStatus', '?')
              reason = e.get('ResourceStatusReason', '')
              if 'FAILED' in status:
                print(f\"[{e.get('Timestamp','?')}] {e.get('LogicalResourceId','?')}\")
                print(f\"  Status: {status}\")
                if reason:
                  print(f\"  Reason: {reason}\")
          except Exception as ex:
            print(f'Erro: {ex}')
          "

      - name: Get stack outputs
        id: outputs
        run: |
          FRONTEND_URL=$(aws cloudformation describe-stacks \
            --stack-name ${{ env.SAM_STACK_NAME }} \
            --query "Stacks[0].Outputs[?OutputKey=='FrontendUrl'].OutputValue" \
            --output text)
          BACKEND_URL=$(aws cloudformation describe-stacks \
            --stack-name ${{ env.SAM_STACK_NAME }} \
            --query "Stacks[0].Outputs[?OutputKey=='BackendUrl'].OutputValue" \
            --output text)
          BUCKET_NAME=$(aws cloudformation describe-stacks \
            --stack-name ${{ env.SAM_STACK_NAME }} \
            --query "Stacks[0].Outputs[?OutputKey=='FrontendBucketName'].OutputValue" \
            --output text)
          DISTRIBUTION_ID=$(aws cloudformation describe-stacks \
            --stack-name ${{ env.SAM_STACK_NAME }} \
            --query "Stacks[0].Outputs[?OutputKey=='DistributionId'].OutputValue" \
            --output text)
          echo "frontend_url=$FRONTEND_URL" >> $GITHUB_OUTPUT
          echo "backend_url=$BACKEND_URL" >> $GITHUB_OUTPUT
          echo "bucket_name=$BUCKET_NAME" >> $GITHUB_OUTPUT
          echo "distribution_id=$DISTRIBUTION_ID" >> $GITHUB_OUTPUT

      # --- Build do frontend (APÓS deploy) ---
      # A URL do backend só é conhecida depois que o stack sobe.
      # Substitua o path do arquivo de ambiente conforme o framework.
      - name: Build frontend with production URL
        run: |
          API_URL=$(echo "${{ steps.outputs.outputs.backend_url }}" | sed 's:/*$::')
          cat > <frontend>/src/environments/environment.prod.ts <<EOF
          export const environment = {
            production: true,
            apiUrl: '${API_URL}/api',
          };
          EOF
          cd <frontend> && npm ci && npm run build

      - name: Sync frontend to S3
        run: |
          aws s3 sync <frontend>/dist/<output-dir>/ \
            s3://${{ steps.outputs.outputs.bucket_name }}/ --delete

      - name: Invalidate CloudFront cache
        run: |
          aws cloudfront create-invalidation \
            --distribution-id ${{ steps.outputs.outputs.distribution_id }} \
            --paths "/*"

      - name: Deployment summary
        run: |
          echo "## Deploy concluido!" >> $GITHUB_STEP_SUMMARY
          echo "**Frontend:** ${{ steps.outputs.outputs.frontend_url }}" >> $GITHUB_STEP_SUMMARY
```

## Padrões obrigatórios

### OIDC sempre, nunca access keys

```yaml
permissions:
  id-token: write
  contents: read

- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_DEPLOY_ROLE_ARN }}
    aws-region: us-east-1
```

### SAM deploy flags

```bash
sam deploy \
  --stack-name $STACK_NAME \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  --resolve-s3 \
  --no-confirm-changeset \
  --no-fail-on-empty-changeset
```

`--resolve-s3` deixa o SAM gerenciar o bucket de artifacts. `--no-fail-on-empty-changeset` evita erro quando não há mudanças. `--no-confirm-changeset` automatiza.

### SSM injection ANTES do deploy

As Lambdas leem secrets do SSM na inicialização (`cold start`). Se o parâmetro não existir, a Lambda inicia sem o secret. Por isso a injeção deve vir **antes** do `sam deploy`.

### Frontend build DEPOIS do deploy

A URL do backend (Lambda Function URL) é gerada pelo CloudFormation e só existe após o `sam deploy`. O build do frontend, que precisa dessa URL hardcoded no bundle, deve acontecer depois.

### Diagnóstico de falha

Sempre incluir step condicional (`if: failure()`) que imprime eventos do CloudFormation com status `FAILED`. Isso evita ter que acessar o console AWS para debugar erros de deploy.

## Outputs esperados do template.yaml

O SAM template deve exportar estes 4 outputs — o workflow depende deles:

```yaml
Outputs:
  FrontendUrl:
    Value: !Sub "https://${CloudFrontDistribution.DomainName}"
  BackendUrl:
    Value: !GetAtt BackendFunctionUrl.FunctionUrl
  FrontendBucketName:
    Value: !Ref FrontendBucket
  DistributionId:
    Value: !Ref CloudFrontDistribution
```

## Placeholders a substituir

| Placeholder | Substituir por |
|-------------|---------------|
| `<nome-do-stack>` | Nome do stack CloudFormation (ex: `meu-app`) |
| `<versao-python>` | Python runtime version (ex: `"3.12"`) |
| `<versao-node>` | Node version (ex: `"20"`) |
| `<diretorio-backend>` | Diretório do código backend (ex: `backend`) |
| `<diretorio-frontend>` | Diretório do código frontend (ex: `frontend`) |
| `<nome-do-parametro>` | Nome do parâmetro no SSM (ex: `api-token`) |
| `<NOME_DO_SECRET>` | Nome do secret no GitHub (ex: `API_TOKEN`) |
| `<build-backend>` | Script de build da Lambda principal |
| `<build-scheduler>` | Script de build da Lambda secundária |
| `<StageName=prod>` | Parâmetros do template SAM (remova se não usar) |
| `<frontend>/dist/<output-dir>/` | Path de output do build do frontend |

## Workflow sem frontend

Se o projeto **não tem frontend** (só API), remover:
- Job `test` → steps do frontend
- Steps de build do frontend, sync S3, invalidate CloudFront
- Outputs `FrontendUrl`, `FrontendBucketName`, `DistributionId` do step de outputs

Se o projeto **não tem scheduler/worker**, remover o script de build correspondente e ajustar o template SAM.
