# Setup OIDC para GitHub Actions

> Leia esta referência quando precisar criar ou modificar o setup de OIDC para deploy na AWS via GitHub Actions.

## Visão geral

OIDC (OpenID Connect) permite que o GitHub Actions assuma uma role IAM na AWS sem armazenar credenciais de longa duração. O fluxo:

1. GitHub emite um token OIDC para o workflow
2. GitHub Actions troca o token por credenciais temporárias AWS via `sts:AssumeRoleWithWebIdentity`
3. AWS valida o token contra o OIDC provider e a trust policy da role
4. Credenciais temporárias são retornadas (válidas por 1h)

## Recursos criados

### OIDC Identity Provider

```bash
aws iam create-open-id-connect-provider \
  --url "https://token.actions.githubusercontent.com" \
  --thumbprint-list "6938fd4e98bab03faadb97b34396831e3780aea" \
  --client-id-list "sts.amazonaws.com"
```

> O thumbprint pode mudar. Conferir o atual: https://github.com/actions/runner-images (buscar por "thumbprint").

### IAM Role com Trust Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<org>/<repo>:*"
        }
      }
    }
  ]
}
```

- `<org>/<repo>` — ex: `FerCaires/meu-projeto`
- `:*` no final permite qualquer branch, tag ou pull request
- Para restringir a branches específicos, use `repo:<org>/<repo>:ref:refs/heads/main`

## Permissões da role

A policy inline deve cobrir os serviços usados no deploy, escopados ao prefixo do stack:

| Serviço | Ações mínimas | Recurso |
|---------|--------------|---------|
| CloudFormation | `CreateStack`, `UpdateStack`, `DeleteStack`, `DescribeStacks`, `DescribeStackEvents`, `CreateChangeSet`, `ExecuteChangeSet`, `DeleteChangeSet`, `DescribeChangeSet` | `arn:aws:cloudformation:*:<account>:stack/${PREFIX}*` |
| Lambda | `CreateFunction`, `UpdateFunctionCode`, `UpdateFunctionConfiguration`, `GetFunction`, `DeleteFunction`, `CreateFunctionUrlConfig`, `UpdateFunctionUrlConfig` | `arn:aws:lambda:*:<account>:function:${PREFIX}*` |
| DynamoDB | `CreateTable`, `UpdateTable`, `DeleteTable`, `DescribeTable` | `arn:aws:dynamodb:*:<account>:table/${PREFIX}*` |
| S3 | `CreateBucket`, `PutBucketPolicy`, `PutObject`, `DeleteObject`, `ListBucket`, `GetBucketLocation` | `arn:aws:s3:::${PREFIX}*` e `arn:aws:s3:::${PREFIX}*/*` |
| CloudFront | `CreateDistribution`, `UpdateDistribution`, `GetDistribution`, `GetDistributionConfig`, `CreateInvalidation` | `*` (CloudFront não suporta resource-level perms para Create) |
| SSM | `PutParameter`, `GetParameter`, `DeleteParameter` | `arn:aws:ssm:*:<account>:parameter/${PREFIX}/*` |
| IAM | `CreateRole`, `DeleteRole`, `GetRole`, `PassRole`, `PutRolePolicy`, `DeleteRolePolicy`, `AttachRolePolicy`, `DetachRolePolicy` | `arn:aws:iam::<account>:role/${PREFIX}*` |
| Scheduler | `CreateSchedule`, `UpdateSchedule`, `DeleteSchedule`, `GetSchedule` | `arn:aws:scheduler:*:<account>:schedule/*/${PREFIX}*` |
| Logs | `CreateLogGroup`, `DeleteLogGroup`, `DescribeLogGroups`, `PutRetentionPolicy` | `arn:aws:logs:*:<account>:log-group:/aws/lambda/${PREFIX}*` |

> **`${PREFIX}`** é o prefixo do stack (ex: `meu-app`). Todas as ações são escopadas a recursos com esse prefixo.

## Script de setup (`scripts/setup-oidc.sh`)

O script deve ser idempotente:
1. Criar o OIDC provider (verificar se já existe antes)
2. Criar ou atualizar a role IAM com trust policy
3. Anexar policy inline com as permissões acima
4. Exibir o ARN da role

Uso:
```bash
./scripts/setup-oidc.sh <aws-account-id> <org>/<repo> [stack-prefix]
```

Exemplo:
```bash
./scripts/setup-oidc.sh 123456789012 meu-org/meu-projeto meu-app
```

## Após o setup

Copiar o ARN exibido e adicionar como secret no GitHub:
- **Nome:** `AWS_DEPLOY_ROLE_ARN`
- **Valor:** `arn:aws:iam::123456789012:role/GitHubActionsDeployRole`

Configurar também os secrets da aplicação (tokens, senhas, chaves) — um secret no GitHub para cada parâmetro que será injetado no SSM.
