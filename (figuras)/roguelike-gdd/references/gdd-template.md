# Template do docs/GDD.md

Estrutura-base do arquivo `docs/GDD.md` — o **documento master/visão** do jogo.
Use ao criar o arquivo pela primeira vez. Substitua os placeholders `[...]` conforme as
decisões forem fechadas. Mantenha o **checklist de status** no topo atualizado a cada área
fechada.

Ao final da entrevista (todas as 11 áreas fechadas), este GDD master é **fatiado em
contratos de feature** `docs/{NNN}-{name}/gdd.md` (ver `feature-slicing.md`) que alimentam
a implementação pela skill `phaser3-impl`. O master **não é apagado** — preserva a
coerência entre features.

---

```md
# Game Design Document — [NOME DO JOGO]

**Subgênero:** [ex: Roguelike 2D Top-Down de combate mágico]
**Engine/Stack:** [ex: Phaser 3 + TypeScript]
**Plataforma-alvo:** [ex: Web (desktop)]
**Versão do GDD:** 0.1 (em definição)

> Documento vivo. Cada aspecto marcado `[FECHADO]` representa acordo mútuo
> detalhado e mensurável entre designer e dono do produto. Aspectos `[PENDENTE]`
> ainda estão em entrevista. Não reabrir `[FECHADO]` sem autorização explícita.

## Status das Áreas

| # | Área | Status |
|---|------|--------|
| 1 | Core Gameplay Loop / Verbo central | `[PENDENTE]` |
| 2 | Combate do protagonista | `[PENDENTE]` |
| 3 | IA dos inimigos | `[PENDENTE]` |
| 4 | Progressão intra-run | `[PENDENTE]` |
| 5 | Meta-progression | `[PENDENTE]` |
| 6 | Economia | `[PENDENTE]` |
| 7 | Geração procedural | `[PENDENTE]` |
| 8 | Vitória e derrota | `[PENDENTE]` |
| 9 | Balanceamento | `[PENDENTE]` |
| 10 | Ritmo de jogo (pacing) | `[PENDENTE]` |
| 11 | Escopo e MVP | `[PENDENTE]` |

---

## 1. Core Gameplay Loop — [PENDENTE]

### Verbo central — [FECHADO]
- **Regra:** [verbo em uma frase]
- **Ciclo de 30s:** [descrição]
- **Ciclo de 5min:** [descrição]
- **Fonte de tensão:** [recurso/ameaça/incerteza]
- **Risco/recompensa central:** [o que se arrisca vs ganha]
- **Acordado em:** [AAAA-MM-DD]

---

## 2. Combate do Protagonista — [PENDENTE]

### Ataque básico — [FECHADO]
- **Regra:** dano=[X], cadência=[X/s], alcance=[X tiles], custo=[X mana], tipo=[projétil/melee]
- **Edge cases cobertos:** [mana zero, alvo fora de alcance, colisão com parede]
- **Decisões de não-escopo:** [não entra: ataque carregado de nível 2]
- **Acordado em:** [AAAA-MM-DD]

### Ataques especiais — [PENDENTE]
### Defesa (dodge/block) — [PENDENTE]
### Mobilidade — [PENDENTE]
### Mana/stamina — [PENDENTE]
### Dano recebido e HP — [PENDENTE]

---

## 3. IA dos Inimigos — [PENDENTE]

### Tipos de inimigo (MVP) — [FECHADO]
- **Regra:** [N] tipos, cada um com papel tático distinto
- **Tabela:**
  | Tipo | Movimento | HP | Speed | Dano | Telegraphia | Papel tático |
  |------|-----------|----|-------|------|-------------|--------------|
  | ... | ... | ... | ... | ... | ... | ... |
- **Edge cases cobertos:** [limite de tela, leashing, spawn]
- **Decisões de não-escopo:** [não entra: inimigos voadores no MVP]
- **Acordado em:** [AAAA-MM-DD]

### Bosses — [PENDENTE]
### Scaling por andar — [PENDENTE]

---

## 4. Progressão Intra-Run — [PENDENTE]

### Fonte de poder — [PENDENTE]
### Frequência e magnitude de upgrades — [PENDENTE]
### Sinergias e builds — [PENDENTE]
### Trade-offs/maldições — [PENDENTE]
### Teto de poder — [PENDENTE]

---

## 5. Meta-Progression — [PENDENTE]

### O que persiste — [PENDENTE]
### Política de permadeath — [PENDENTE]
### Pacing de unlock — [PENDENTE]

---

## 6. Economia — [PENDENTE]

### Moeda e fontes — [PENDENTE]
### Sinks e preços — [PENDENTE]
### Lojas e reroll — [PENDENTE]
### Sinks de final de run — [PENDENTE]

---

## 7. Geração Procedural — [PENDENTE]

### Unidade e algoritmo — [PENDENTE]
### Tipos de sala (MVP) — [PENDENTE]
### Garantias mínimas por andar — [PENDENTE]
### Pathing e branches — [PENDENTE]
### Política anti-run-morta — [PENDENTE]

---

## 8. Vitória e Derrota — [PENDENTE]

### Condição de vitória — [PENDENTE]
### Política de morte/continue — [PENDENTE]
### Endgame — [PENDENTE]

---

## 9. Balanceamento — [PENDENTE]

### Curva HP/dano por andar — [PENDENTE]
### Skill vs RNG — [PENDENTE]
### Piso e teto de poder — [PENDENTE]
### Métricas de telemetria — [PENDENTE]

---

## 10. Ritmo de Jogo (Pacing) — [PENDENTE]

### Duração-alvo da run — [PENDENTE]
### Climax e vales — [PENDENTE]
### Proporção decisão/execução — [PENDENTE]

---

## 11. Escopo e MVP — [PENDENTE]

### Features IN (MVP) — [PENDENTE]
### Features OUT (não entra) — [PENDENTE]
### Conteúdo do MVP — [PENDENTE]
  - Inimigos: [N]
  - Salas (tipos): [N]
  - Upgrades: [N]
  - Bosses: [N]
### Caminho crítico — [PENDENTE]
### Maior risco técnico + plano B — [PENDENTE]
### Vertical slice — [PENDENTE]
### Critérios mensuráveis de "pronto" — [PENDENTE]

---

## Histórico de Decisões

 Registro cronológico de cada aspecto fechado (espelha as marcações acima).
 Atualize ao fechar cada aspecto.

- [AAAA-MM-DD] — **Verbo central** fechado.
- [AAAA-MM-DD] — **Ataque básico** fechado.
```

## Notas de uso

- O bloco acima (entre ```md e ```) é o **conteúdo** a ser escrito em `docs/GDD.md`.
- Ao fechar um aspecto, troque o `[PENDENTE]` da subseção por `[FECHADO]` e preencha os campos.
- Atualize a **tabela de status** no topo a cada fechamento.
- Acrescente entrada no **Histórico de Decisões** ao final.
- Preserve seções já fechadas — nunca reabra sem autorização.
