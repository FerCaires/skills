---
name: game-environment-prompt-interview
description: Conduz uma entrevista estruturada, por categorias, para levantar o necessário para descrever um pacote de assets de ambiente/cenário de jogo (bioma, vegetação, terreno, props, estilo, requisitos de sprite sheet) e compila em um prompt pronto para Midjourney, DALL-E, Stable Diffusion ou Nano Banana. O prompt sempre inclui um pedido explícito para a ferramenta de imagem também gerar um manifest.json técnico (categorias, ids e bounds de cada asset) junto com o sprite sheet — usado depois no fatiamento e individualização dos sprites. Use sempre que o usuário pedir para criar, desenhar ou gerar concept art de cenário, ambiente, bioma, mapa, tileset, sprite sheet de ambiente, asset pack, level art, background de jogo, ou "prompt para IA de imagem" de ambiente — mesmo sem as palavras "entrevista"/"skill". Acione para "criar o cenário do meu jogo", "prompt pros assets de ambiente", "gerar texturas/tiles/props do level". Não use para o personagem principal — existe a skill irmã game-character-prompt-interview.
---

# Entrevista de Ambiente/Cenário de Jogo

## Objetivo

Fazer perguntas curtas e organizadas por categoria para levantar tudo que é
necessário para descrever um pacote de assets de ambiente de jogo (bioma,
terreno, vegetação, props, estilo, requisitos técnicos), e no final compilar
essas respostas em **um único entregável: o prompt de imagem**.

Esse prompt, porém, deve **sempre** incluir, como parte final do pedido, uma
solicitação explícita para que a própria ferramenta de geração de imagem
produza também um `manifest.json` no formato indicado — junto com o sprite
sheet, na mesma execução. Quem gera o `manifest.json` é a ferramenta de
geração de imagem (ex.: Nano Banana, ou qualquer gerador com saída
estruturada), não esta skill. O resultado esperado, depois que o usuário
rodar o prompt na ferramenta escolhida, são **dois arquivos: o sprite sheet
(imagem) e o `manifest.json`** — usado depois para fatiar e individualizar
cada sprite. Nunca pule esse bloco de solicitação do manifest ao montar o
prompt final, mesmo que o usuário não peça explicitamente — pergunte os
parâmetros técnicos necessários (Etapa 7) e sempre inclua o pedido.

### Prompt de referência (usado como modelo desta skill)

```
Create a complete, cohesive 2D side scrolling game environment asset pack
in a whimsical hand drawn storybook illustration style matching a stylized
cartoon boy with messy spiky black hair and a small fluffy white creature
companion.
include a full modular set of environment assets: ground tiles (grass,
dirt, stone), seamless tileable textures, grass variations, dirt paths,
rocks, bushes, flowers, trees (small, medium, large), tree stumps, wooden
fences, signposts, logs, mushrooms, small props, decorative elements
design everything in a soft painterly style with visible brush texture,
slightly rough sketchy ink linework, subtle shading, warm friendly color
palette, playful proportions, simple but charming shapes
mood: magical, calm, cozy, childlike adventure world
ensure strict visual consistency across all assets: same lighting
direction, same color harmony, same line thickness, same texture style
layout: assets clearly separated, evenly spaced, no overlap, centered and
organized like a sprite sheet
background: clean flat green background
perspective: side view, 2D platformer style
technical requirements: tileable seamless textures, modular design,
grid-aligned assets, consistent scale between objects, game-ready high
resolution, sharp edges
Make the aspect ratio 16:9.
```

Repare na estrutura: **tipo de entrega/perspectiva → estilo geral (com
ponte de consistência para o personagem, se houver) → lista modular de
assets → técnica/acabamento → mood → regras de consistência visual →
layout tipo sprite sheet → fundo → perspectiva → requisitos técnicos →
aspect ratio**. É essa mesma ordem que a entrevista deve levantar e que o
prompt final deve seguir.

## Como conduzir a entrevista

- Conduza a conversa no idioma do usuário (aqui, português), mas o
  **prompt final deve ser escrito em inglês** — é o idioma que os
  geradores de imagem interpretam melhor. Ofereça uma versão traduzida em
  português apenas se o usuário pedir.
- Prefira o tool `ask_user_input_v0` para perguntas de opções fechadas
  (bioma, mood, perspectiva etc.). Use no máximo 3 perguntas por chamada.
  Para a lista de categorias de assets (etapa 4), use `multi_select` — o
  usuário provavelmente quer várias ao mesmo tempo.
- Reserve perguntas de texto livre para o que exige a criatividade do
  usuário: nome do bioma/mundo, props específicos que ele já tem em mente,
  elementos únicos da história do jogo.
- Não faça tudo de uma vez. Avance por blocos (ver "Etapas da entrevista").
  Se o pedido inicial do usuário já responder algo (ex.: "quero uma
  floresta encantada" já define bioma/mood), não pergunte de novo — infira
  e confirme rapidamente antes de seguir.
- Consulte `references/glossario-ambiente.md` para listas de opções mais
  ricas por categoria (biomas, iluminação, props, requisitos técnicos etc.).
- Consulte `references/exemplo-manifest.json` como modelo de referência do
  formato e nível de detalhe esperado — é o schema que vai dentro do
  próprio prompt, na "Solicitação do manifest.json" (ver abaixo).
- No final, monte o prompt seguindo o "Modelo de compilação do prompt
  final", que já inclui embutida a solicitação do `manifest.json`.
  Apresente o prompt inteiro (descrição visual + pedido do manifest) em um
  único bloco de código, pronto para copiar e colar na ferramenta de
  geração de imagem. Não crie nenhum arquivo `.json` você mesmo — quem gera
  o manifest é a ferramenta de imagem, ao executar o prompt. Pergunte se o
  usuário quer ajustar algo antes de considerar finalizado.

### Ponte de consistência com o personagem principal

Esta skill é irmã da `game-character-prompt-interview`. Sempre que fizer
sentido (ou seja, sempre que o ambiente vai aparecer no mesmo jogo que um
personagem), **pergunte logo na Etapa 1** se o usuário já tem um prompt de
personagem pronto (gerado por aquela skill ou não) e peça para colá-lo. Se
ele colar:

- Reaproveite do prompt do personagem: estilo artístico geral, técnica de
  ilustração/textura, paleta de cores, espessura de linha e direção de luz
  — para que o ambiente combine visualmente com o personagem.
- Inclua uma referência resumida ao personagem na frase de abertura do
  prompt final (como no exemplo: "...matching a stylized cartoon boy with
  messy spiky black hair and a small fluffy white creature companion"),
  sem repetir a descrição inteira.

Se o usuário não tiver personagem ainda (ou o ambiente for para algo sem
protagonista, como um menu ou uma cutscene), pule essa ponte e siga
normalmente a partir do estilo definido na Etapa 2.

## Etapas da entrevista

### 1. Tipo de entrega e consistência com personagem
- O usuário já tem um prompt de personagem para reaproveitar estilo? (sim,
  peço para colar / não, é um ambiente independente)
- Tipo de entrega: pacote modular de assets (sprite sheet), cenário único
  completo (background pronto), os dois
- Perspectiva/gênero do jogo: 2D side-scroller/plataforma, top-down,
  isométrico, 2.5D

### 2. Bioma e ambientação
- Bioma/tema: floresta encantada, deserto, caverna, praia, pântano,
  montanha nevada, cidade/vila, castelo, outro
- Hora do dia: manhã, meio-dia, entardecer, noite
- Estação do ano (se relevante): primavera, verão, outono, inverno

### 3. Estilo artístico geral (se não veio da ponte com o personagem)
- Estilo visual: mesmas famílias de estilo do character design (cartoon
  estilizado tipo livro infantil, anime, pixel art, 3D estilo Pixar,
  aquarela, low-poly)
- Técnica/acabamento: pintura com textura de pincel visível, linework
  sketchy à tinta, cel-shading, vetorial flat
- Paleta de cores: quente e aconchegante, fria e misteriosa, pastel suave,
  vibrante e saturada

### 4. Elementos modulares do pacote de assets (multi-select)
- Terreno: tiles de grama, terra, pedra, areia, neve, água
- Vegetação: variações de grama, arbustos, flores, árvores (pequenas,
  médias, grandes), tocos, trepadeiras
- Estruturas de madeira/props: cercas, placas de sinalização, troncos,
  pontes pequenas, barris
- Decoração/detalhes: cogumelos, pedras soltas, pequenos props (baús,
  lanternas), elementos decorativos extras (borboletas, teias de aranha,
  pegadas)
- Pergunte se quer adicionar alguma categoria específica além dessas

### 5. Mood/atmosfera
- Humor geral: mágico e calmo, aventura leve e infantil, sombrio e
  perigoso, épico e grandioso, sereno e contemplativo

### 6. Layout, fundo e requisitos técnicos
- Layout: pacote tipo sprite sheet (assets separados, espaçados, sem
  sobreposição, organizados em grid) ou cena única contínua
- Fundo: cor sólida específica (verde/branco, útil para recorte), fundo
  neutro, cena de fundo completa
- Requisitos técnicos: texturas tileable/seamless, grid-aligned, escala
  consistente entre objetos, alta resolução, bordas nítidas, pronto para
  jogo
- Aspect ratio: 16:9, 1:1, 4:3, ultrawide, personalizado

### 7. Parâmetros técnicos do manifest.json (obrigatória, sempre pergunte)

Esta etapa nunca é pulada — é ela que alimenta a solicitação de
`manifest.json` embutida no prompt final (a ferramenta de geração de
imagem é quem efetivamente vai gerar o arquivo). Use `ask_user_input_v0`
com sugestões recomendadas; se o usuário não souber responder, siga com o
valor recomendado sem travar a entrevista.

- Nome do asset pack: texto livre, sugira algo com base no bioma + tema
  definidos nas etapas 2 e 5 (ex.: "Dark Pirate Cave - Environment
  Tileset")
- Resolução base do canvas (`grid_base_size`): 1024×1024 ⭐ (pacotes
  pequenos/médios, poucas dezenas de itens) | 2048×2048 (pacotes grandes,
  muitas categorias/itens) | personalizado (pergunte largura x altura) —
  deve ser a mesma resolução pedida no aspect ratio/requisitos técnicos da
  Etapa 6, para que a imagem gerada e o manifest batam.
- Formato de fatia (`slice_format`): PNG ⭐ (padrão para sprites de jogo) |
  outro formato se o usuário pedir
- Fundo transparente nos sprites já individualizados
  (`transparent_background`): sim ⭐ (recomendado — é o padrão esperado para
  assets prontos para uso em engine) | não (mantém o fundo definido na
  Etapa 6 em cada sprite recortado)

## Modelo de compilação do prompt final

Monte o prompt final em inglês seguindo esta ordem (mesma lógica do
prompt de referência), e **sempre** anexe ao final o bloco de solicitação
do manifest (seção seguinte) — os dois fazem parte do mesmo prompt, em um
único bloco de código:

```
Create a complete, cohesive [perspectiva/gênero] game environment asset
pack in a [estilo artístico geral][, matching (referência resumida ao
personagem, se houver)].
include a full modular set of environment assets: [lista das categorias
escolhidas na Etapa 4, agrupadas como no exemplo].
design everything in [técnica/acabamento], [paleta de cores], [proporções
e formas do estilo].
mood: [mood da Etapa 5].
ensure strict visual consistency across all assets: same lighting
direction, same color harmony, same line thickness, same texture style.
layout: [layout da Etapa 6].
background: [fundo da Etapa 6].
perspective: [perspectiva da Etapa 1].
technical requirements: [requisitos técnicos da Etapa 6].
Make the aspect ratio [aspect ratio da Etapa 6], canvas size
[largura]x[altura] px (Etapa 7).

Additionally, generate a manifest.json file alongside the image, mapping
every asset you actually drew to its exact pixel position and size within
the canvas. Follow this exact schema:
{
  "asset_pack_name": "[nome do asset pack, Etapa 7]",
  "author": "AI Generated",
  "version": "1.0.0",
  "grid_base_size": { "width": [largura], "height": [altura] },
  "slice_format": "[formato, Etapa 7]",
  "transparent_background": [true/false, Etapa 7],
  "categories": [
    {
      "category_name": "string",
      "type": "string",
      "items": [
        { "id": "snake_case_id", "bounds": { "x": 0, "y": 0, "w": 0, "h": 0 } }
      ]
    }
  ]
}
Group items by category exactly as listed above (one categories entry per
asset category in this prompt). Give every individual asset a unique,
descriptive snake_case id (number variations as _01, _02, etc.). Bounds
must reflect the actual position and size of each asset as drawn, in
pixels, with no overlap between items. Return the manifest as a single
valid JSON object.
```

Ajuste os textos entre colchetes com as respostas coletadas; o restante do
bloco (schema do manifest, regras de agrupamento e ids) é fixo e não deve
ser resumido ou removido — é ele que garante que o resultado da ferramenta
de imagem venha no formato certo para o fatiamento posterior.

## Depois de montar o prompt

- Apresente o prompt final completo (descrição visual + solicitação do
  manifest) em um único bloco de código, em inglês, pronto para copiar e
  colar na ferramenta de geração de imagem escolhida.
- Explique em 1–2 frases o que esperar como resultado: ao rodar esse
  prompt na ferramenta de imagem, o usuário deve receber dois arquivos —
  o sprite sheet (imagem) **e** o `manifest.json` já no formato pedido —
  que juntos permitem fatiar e individualizar cada sprite depois (com um
  script de corte, TexturePacker ou equivalente).
- Não crie você mesmo nenhum arquivo `.json` ou de imagem — essa skill
  entrega apenas o texto do prompt. Quem gera o sprite sheet e o
  `manifest.json` é a ferramenta de geração de imagem, ao executar o
  prompt.
- Pergunte, em uma única mensagem, se o usuário quer: (a) uma versão do
  prompt em português, (b) ajustar algum trecho específico, ou (c) já
  considerar finalizado.
