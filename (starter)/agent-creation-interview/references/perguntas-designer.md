# Roteiro de Entrevista — Agente de Design

Use este roteiro depois do bloco fundamental (Etapa 1 do SKILL.md). A
primeira pergunta define qual dos dois ramos seguir — os dois ramos avançam
na mesma profundidade usada no roteiro de Desenvolvimento (especialidade →
ferramentas/stack → estilo/padrões → processo → entrega/colaboração).

## 0. Bifurcação inicial (obrigatória)

```
Pergunta: "Esse agente de design é voltado para..."
Opções: Design de Games | Design de Frontend/Produto (UI/UX)
```

Se a resposta já veio implícita no pedido original (ex.: "quero um agente
para desenhar personagens do meu jogo"), infira e confirme antes de seguir.

---

## RAMO A — Design de Frontend / Produto (UI/UX)

### A1. Especialidade dentro de produto/frontend
- UI Design ⭐ | UX Design/Pesquisa | Design System | Product Design
  (end-to-end) | Design de Interação/Motion

### A2. Ferramentas de trabalho
- Ferramenta principal: Figma ⭐ | Sketch | Adobe XD | Framer
- Usa/mantém bibliotecas de componentes dentro da ferramenta (ex.: Figma
  Variants, Auto Layout)?

### A3. Sistema de design e padrões visuais
- Já existe um Design System a seguir? Se sim, peça nome/link ou descrição
  (tokens de cor, tipografia, espaçamento, biblioteca de componentes).
- Se não existe, o agente deve ajudar a criar um do zero?
- Estilo visual predominante: Minimalista/clean ⭐ | Corporativo/sério |
  Lúdico/colorido | Denso/data-heavy (dashboards) | Editorial

### A4. Acessibilidade e qualidade
- Nível de conformidade exigido: WCAG 2.1 AA ⭐ | AAA | Não é prioridade
  ainda
- O agente deve validar contraste, tamanhos de toque, leitura por
  screen reader como parte do processo padrão?

### A5. Pesquisa e validação
- O agente participa de pesquisa com usuário (entrevistas, testes de
  usabilidade) ou foca só na execução visual/interativa?
- Se participa, que método prioriza: testes moderados, unmoderated,
  A/B testing, entrevistas qualitativas?

### A6. Handoff para desenvolvimento
- Como entrega specs para o time de dev: Figma Dev Mode ⭐ | Redlines
  manuais | Zeplin | Storybook
- Conhece bibliotecas de UI usadas pelo dev para alinhar viabilidade (ex.:
  Tailwind, Material UI, shadcn/ui, Chakra)? Quais?

### A7. Colaboração e nível de autonomia
- O agente pode propor mudanças de fluxo/produto sozinho, ou só de
  interface visual dentro de um fluxo já definido pelo PM?
- Deve validar decisões com o Tech Lead/Dev antes de finalizar specs
  complexas?

---

## RAMO B — Design de Games

### B1. Especialidade dentro de games
- Concept Art ⭐ | Character Design | Environment/Level Art | UI de jogo
  (HUD, menus) | Animação/Sprites | Pixel Art

### B2. Ferramentas de trabalho
- Ferramenta principal: Photoshop ⭐ | Procreate | Aseprite (pixel art) |
  Blender (3D) | Clip Studio Paint
- Trabalha com rigging/animação (Spine, Blender, Live2D)?

### B3. Estilo artístico e referência estética
- Estilo visual: Pixel art ⭐ | Cartoon estilizado | Realista/semi-realista |
  Low-poly 3D | Anime/chibi
- Referência estética-alvo (ex.: livro infantil, RPG de fantasia sombria,
  retro anos 80/90, indie fofo) — texto livre, com exemplos como botões se
  fizer sentido.

### B4. Engine e pipeline técnico
- Engine com a qual colabora: Unity ⭐ | Unreal | Godot | Engine própria
- Requisitos técnicos de sprite sheet/asset (resolução, grade de pixels,
  formato de exportação, número de frames por animação) — se o usuário já
  tiver um pipeline definido, registre as especificações exatas.

### B5. Processo de criação de assets
- Segue um pipeline formal (anchor pose → variações → sprite sheet →
  animação) ou é mais livre/exploratório?
- Produz apenas concept art estático, ou também sprites/assets finais
  prontos para implementação no jogo?

### B6. Colaboração e nível de autonomia
- Trabalha a partir de um Game Design Document (GDD) existente, ou ajuda a
  definir a direção de arte também?
- Precisa alinhar com programadores de gameplay antes de finalizar um
  asset (ex.: hitbox, tamanho de tile)?

---

Depois de percorrer o ramo correspondente, volte para a Etapa 3 do
SKILL.md (resumo e aprovação do escopo).
