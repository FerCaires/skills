# Deploy AWS — S3 + CloudFront

Orientação para publicar o jogo com carregamento instantâneo. Forneça **só quando o
usuário pedir** deploy/publicação.

## Sumário
1. [Visão geral](#1-visão-geral)
2. [Build](#2-build)
3. [Bucket S3](#3-bucket-s3)
4. [Distribuição CloudFront](#4-distribuição-cloudfront)
5. [Cache policies (o coração do "instantâneo")](#5-cache-policies-o-coração-do-instantâneo)
6. [Upload e invalidação](#6-upload-e-invalidação)
7. [Checklist final](#7-checklist-final)

---

## 1. Visão geral

```
Usuário → CloudFront (CDN, cache na borda) → S3 (origem, bucket PRIVADO)
```

- **S3** guarda os arquivos do build (`dist/`). Bucket **não público**.
- **CloudFront** serve via CDN com cache. Acesso à origem S3 via **OAC** (Origin Access Control — substituto moderno do OAI).
- **Carregamento instantâneo** vem de: assets hasheados com cache longo (1 ano) + `index.html` sempre fresco (no-cache) + CDN na borda.

> AWS evolui a console/API. Os **princípios** abaixo são estáveis; ao aplicar pela console, confira os nomes atuais de campos/policies.

---

## 2. Build

```bash
npm run build
# Gera dist/ com:
#   dist/index.html                  (não hasheado — entry point)
#   dist/assets/index.[hash].js      (hasheado)
#   dist/assets/index.[hash].css     (hasheado, se houver)
#   dist/assets/player.[hash].png    (assets importados pelo Vite → hasheados)
```

Por que isso importa: o Vite **hasha** todo asset importado de `src/`. Quando o conteúdo
muda, o hash muda, o nome muda → cache longo é seguro. O `index.html` referencia os novos
nomes hasheados, então ele **precisa** ser sempre buscado fresco.

> `base: './'` no `vite.config.ts` (já no scaffold) é **obrigatório** — gera caminhos
> relativos, evitando 404 no CloudFront.

---

## 3. Bucket S3

1. Crie um bucket (ex: `meu-jogo-prod`). **Bloqueie todo acesso público** (padrão).
2. **Não** habilite hosting estático no S3 — o CloudFront serve diretamente. (Hosting estático exige bucket público, o que evitamos com OAC.)
3. Faça upload do `dist/`:
   ```bash
   aws s3 sync dist/ s3://meu-jogo-prod/ --delete
   ```
4. Defina `Cache-Control` no `index.html` para **no-cache** (passo crítico — ver seção 5):
   ```bash
   aws s3api copy-object \
     --bucket meu-jogo-prod --key index.html \
     --copy-source meu-jogo-prod/index.html \
     --metadata-directive REPLACE \
     --cache-control "no-cache, no-store, must-revalidate" \
     --content-type "text/html"
   ```
   (Ou aplique o header no upload inicial com `--metadata`.)

---

## 4. Distribuição CloudFront

1. **Create distribution** → origin = o bucket S3 (escolha na lista).
2. **Origin access:** escolha **Origin Access Control (OAC)** — **não** OAI (legacy), **não** público.
   - A AWS gera/atualiza a **bucket policy** do S3 automaticamente para permitir leitura só via CloudFront. Aceite a atualização da policy.
3. **Default cache behavior** → veja seção 5.
4. **Viewer protocol policy:** Redirect HTTP to HTTPS.
5. **Web Application Firewall (WAF):** opcional (custo extra); geralmente dispensável para um jogo web estático.
6. **Default root object:** `index.html`.
7. Crie e aguarde o deploy (status *Deployed*).

---

## 5. Cache policies (o coração do "instantâneo")

A regra de ouro: **hashed → cache longo; entry (`index.html`) → no-cache**.

### Comportamento 1 — `index.html` (entry, sempre fresco)

- **Path pattern:** `index.html` (crie um behavior específico, com prioridade acima do default).
- **Cache policy:** use a gerenciada **CachingDisabled** (ou uma custom com min/max TTL = 0).
- **Origin request policy:** pode ser `AllViewer` ou só headers necessários.
- Combinado com o `Cache-Control: no-cache` setado no S3 (seção 3), garante que o usuário sempre busca o `index.html` mais novo, que por sua vez aponta para os assets hasheados corretos.

### Comportamento 2 — assets hasheados (`assets/*` e demais)

- **Path pattern:** `Default (*)` (cobre `assets/*`, imagens, fontes, JS, CSS hasheados).
- **Cache policy:** gerenciada **CachingOptimized** (ou custom com min TTL = 0, max TTL = 31536000 = 1 ano).
- **Segurança:** como o nome do arquivo muda quando o conteúdo muda (hash), cache de 1 ano é 100% seguro — nunca entrega asset velho.
- Isso é o que dá "carregamento instantâneo": no 2º acesso, assets vêm do cache da borda/CDN (ou do browser) sem round-trip à origem.

> Assets em `public/` (não hasheados pelo Vite) **não** devem ter cache longo — use cache curto ou no-cache para eles. Por isso o scaffold prefere `src/assets/` (importados e hasheados).

### Resumo

| Tipo de arquivo | Path | Cache policy | TTL |
|-----------------|------|--------------|-----|
| `index.html` | `index.html` | CachingDisabled | 0 (sempre fresco) |
| `assets/*.{js,css,png,...}` | `*` (default) | CachingOptimized | até 1 ano |
| `public/*` (não hasheado) | `*` | curto/no-cache | 0–60s |

---

## 6. Upload e invalidação

Fluxo de cada novo deploy:

```bash
# 1. Build
npm run build

# 2. Upload (sincroniza, removendo arquivos que sumiram)
aws s3 sync dist/ s3://meu-jogo-prod/ --delete

# 3. Reaplica no-cache no index.html (sync não reescreve metadata de objetos iguais)
aws s3api copy-object --bucket meu-jogo-prod --key index.html \
  --copy-source meu-jogo-prod/index.html --metadata-directive REPLACE \
  --cache-control "no-cache, no-store, must-revalidate" --content-type "text/html"

# 4. Invalidation — só o entry. Assets hasheados novos já têm nomes novos; os velhos podem expirar.
aws cloudfront create-invalidation --distribution-id EXXXXXXXXXXXX \
  --paths "/index.html"
```

**Por que invalidar só `/index.html`:** os assets têm nomes hasheados — versão nova = nome
novo, então não há stale. Invalidar `/*` a cada deploy é caro e desnecessário. Invalide
`/*` apenas se mudou algo em `public/` sem hash.

---

## 7. Checklist final

- [ ] `vite.config.ts` com `base: './'` e `assetsInlineLimit: 0`.
- [ ] `npm run build` passa (`tsc --noEmit` + `vite build`) sem erros.
- [ ] Bucket S3 criado e **privado** (acesso público bloqueado).
- [ ] CloudFront com **OAC** (não público, não OAI). Bucket policy atualizada pela AWS.
- [ ] Behavior `index.html` → **CachingDisabled** + `Cache-Control: no-cache` no objeto.
- [ ] Behavior default (`*`) → **CachingOptimized** (cache longo p/ assets hasheados).
- [ ] Default root object = `index.html`. HTTPS redirect on.
- [ ] Deploy: `s3 sync` → reaplica no-cache no index.html → invalida `/index.html`.
- [ ] Testar: abrir a URL CloudFront em janela anônima, conferir 200 + cache hit no 2º load.
