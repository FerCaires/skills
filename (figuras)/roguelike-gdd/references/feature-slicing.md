# Fatiamento do GDD em Features

Método para decompor o `docs/GDD.md` (documento master/visão) em **contratos de feature**
`docs/{NNN}-{name}/gdd.md` que alimentam a implementação pela skill `phaser3-impl`.

## Sumário
1. [Princípios](#1-princípios)
2. [Como derivar features do GDD](#2-como-derivar-features-do-gdd)
3. [Ordem por dependência (numeração NNN)](#3-ordem-por-dependência-numeração-nnn)
4. [Template do gdd.md por feature](#4-template-do-gddmd-por-feature)
5. [Exemplo de plano de features](#5-exemplo-de-plano-de-features)

---

## 1. Princípios

- Cada feature = **uma entrega testável no navegador**. Se não cabe numa sessão de implementação com poucas etapas, está grande demais — divida.
- O `gdd.md` da feature é um **contrato de execução**: mecânicas, números, assets esperados, critérios de aceite. **Não repete** toda a visão do jogo — referencia o GDD master para contexto.
- **Números obrigatórios**: copie do GDD master os valores fechados (HP, dano, cooldowns, tiles, quantidades). Se o fatiamento revelar um número faltante, **volte à entrevista** para fechá-lo — não invente.
- **Não crie `IMPL.md`** nesta fase — esse arquivo é criado e mantido pela skill `phaser3-impl`.
- **Não apague o GDD master** (`docs/GDD.md`) — ele preserva a coerência entre features e é a fonte da verdade do design.

---

## 2. Como derivar features do GDD

Percorra as 11 áreas fechadas e agrupe mecânicas em features de tamanho de implementação:

| Área do GDD | Tipicamente vira |
|-------------|------------------|
| 1. Core loop | Embutido no vertical slice (001) |
| 2. Combate | 1 feature (movimento + ataque + mana) ou 2 (movimento; ataque/mana) |
| 3. IA | "inimigos básicos" (1 feature) + "boss" (1 feature), por família |
| 4. Progressão intra-run | 1 feature (upgrades/builds) |
| 5. Meta-progression | 1 feature |
| 6. Economia | 1 feature (moeda + loja + sinks) |
| 7. Geração procedural | 1 feature (salas/andares) |
| 8. Vitória/derrota | Embutido em boss/gameover; 1 feature se houver endgame |
| 9–10. Balanceamento/ritmo | 1 feature de tuning ao final |
| 11. Escopo/MVP | Define o corte — não vira feature, orienta o plano |

**Critério de tamanho:** se uma feature cobre >5 mecânicas distintas, divida. Cada etapa de implementação (pela skill `phaser3-impl`) deve ser testável isoladamente no navegador.

---

## 3. Ordem por dependência (numeração NNN)

Numere com `NNN` (zero-pad, 3 dígitos) pela ordem ideal de implementação. Princípio:
**cada feature builda sobre as anteriores, sem depender de uma posterior.**

1. **000-scaffold** — bootstrap do projeto (Vite + TS + Phaser, cenas Boot/Preloader/MainMenu/Play/GameOver). Pré-requisito de tudo.
2. **001-...** — vertical slice / core loop mínimo (movimento + 1 inimigo + 1 sala) que **prova o fun**. Se este slice não divertir, o jogo não segue.
3. Depois, por dependência: combate completo → inimigos → progressão → procedural → economia → meta → boss/vitória.
4. Por último: balanceamento fino + polish + deploy (AWS).

Ajuste ao GDD real. A numeração fixa a ordem de execução e é o que o script
`next-feature.sh` (da skill `phaser3-impl`) usa para apontar "a próxima feature".

---

## 4. Template do gdd.md por feature

Use este formato ao criar cada `docs/{NNN}-{name}/gdd.md`:

```md
# Feature {NNN} — {Name}

**Áreas do GDD master consumidas:** [ex: 2 (Combate), 3 (IA)]
**Depende das features:** [ex: 000-scaffold, 001-core-loop]
**Status do design:** fechado

## Objetivo
[1–2 frases: o que esta feature adiciona de jogável]

## Mecânicas (com números — copiados do GDD master)

### Mecânica A — [nome]
- **Regra:** [HP, dano, cooldown em s, alcance em tiles, velocidade, %, quantidades]
- **Edge cases:** [e se o jogador fizer X? e se o inimigo fizer Y?]

### Mecânica B — [nome]
- **Regra:** ...
- **Edge cases:** ...

## Assets esperados
- Spritesheet: `assets/{nome}.png` — frameWidth=__, frameHeight=__, margin=__, spacing=__ (valores a confirmar na implementação, conforme a arte gerada)
- Áudio: `assets/{nome}.[mp3|ogg]`
- [Marcar com `TODO-art` onde o usuário deve prover a arte/áudio]

## Critérios de aceite (testável no navegador)
- [ ] Mecânica A funciona com os números fechados no GDD
- [ ] Mecânica B funciona com os números fechados no GDD
- [ ] Edge cases tratados
- [ ] `npm run build` passa (tsc --noEmit + vite build) sem erros
- [ ] Roda em `npm run dev` sem erros no console

## Não-escopo desta feature
- [O que explicitamente NÃO entra aqui — previne scope creep na implementação]

## Referência ao GDD master
- Ver `docs/GDD.md`, seções [X, Y], para contexto completo e decisões adjacentes.
```

---

## 5. Exemplo de plano de features

Ilustrativo — **adapte ao GDD real fechado na entrevista.** Apresente como tabela ao
confirmar o plano com o usuário.

| NNN | Nome | Áreas consumidas | Depende de |
|-----|------|------------------|------------|
| 000 | scaffold | — | — |
| 001 | core-loop | 1, 2 (básico), 3 (1 inimigo) | 000 |
| 002 | combate-mago | 2 | 001 |
| 003 | inimigos-basicos | 3 | 001 |
| 004 | progressao-intra-run | 4 | 002, 003 |
| 005 | geracao-procedural | 7 | 001 |
| 006 | economia | 6 | 004 |
| 007 | meta-progression | 5 | 006 |
| 008 | boss-vitoria | 3 (boss), 8 | 005, 007 |
| 009 | balanceamento | 9, 10 | 002–008 |
| 010 | deploy-aws | — | 009 |

Após confirmar a tabela, gere os `docs/{NNN}-{name}/gdd.md` e entregue o handoff à skill
`phaser3-impl`.
