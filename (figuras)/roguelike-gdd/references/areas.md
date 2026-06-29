# Bancas de Perguntas por Área do GDD

Bancas detalhadas para conduzir a entrevista em profundidade. **Leia apenas a seção da área que vai iniciar** — não carregue tudo de uma vez.

## Sumário

1. [Core Gameplay Loop / Verbo central](#1-core-gameplay-loop--verbo-central)
2. [Combate do protagonista](#2-combate-do-protagonista)
3. [IA dos inimigos](#3-ia-dos-inimigos)
4. [Progressão intra-run](#4-progressão-intra-run-upgradesbuilds)
5. [Meta-progression (entre runs)](#5-meta-progression-entre-runs)
6. [Economia](#6-economia-ouroitensolojassinks)
7. [Geração procedural](#7-geração-procedural-salasandareslayout)
8. [Condições de vitória e derrota](#8-condições-de-vitória-e-derrota)
9. [Balanceamento e curva de dificuldade](#9-balanceamento-e-curva-de-dificuldade)
10. [Ritmo de jogo (pacing)](#10-ritmo-de-jogo-pacing)
11. [Escopo e MVP](#11-escopo-e-mvp)

---

## 1. Core Gameplay Loop / Verbo central

O coração do jogo. Defina antes de qualquer outra coisa.

- Qual é a **única ação** que o jogador repete na maior parte do tempo? (atirar, mover-e-atacar, jogar carta, coletar-craft)
- Qual é o **ciclo de 30 segundos**? (ex: entra sala → mata inimigos → coleta recompensa → escolhe upgrade → próxima sala)
- Qual é o **ciclo de 5 minutos**? (ex: clear de um andar + boss + decisão de path)
- Onde mora a **tensão**? Recurso escasso (mana/HP/tempo), ameaça (inimigos), ou incerteza (RNG de loot)?
- Qual é o **risco/recompensa** central? O que o jogador arrisca vs ganha em cada decisão.
- Se cortássemos tudo menos esse verbo, o jogo ainda seria divertido? Se não, o verbo está errado.

**Cravar antes de fechar:** verbo em uma frase, ciclo de 30s descrito, ciclo de 5min descrito, fonte de tensão nomeada.

---

## 2. Combate do protagonista

- **Ataque básico:** dano, cadência (ataques/seg), alcance (tiles), custo (mana/stamina/cooldown em s), é projétil ou melee?
- **Ataques especiais:** quantos? dano, cooldown, custo. Por que o jogador usaria o básico se o especial é melhor?
- **Defesa:** tem dodge/roll/block? i-frames? cooldown? qual a punição por errar?
- **Mobilidade:** velocidade de movimento (tiles/s), diferença de velocidade entre jogador e inimigo mais rápido? (se inimigo é mais rápido, o kiting morre)
- **TTK médio** contra inimigo padrão? E contra o inimigo "tanque"?
- **Feel:** qual a telegrafia que o inimigo dá para o jogador reagir? (sem telegrafia = absorção passiva de dano = chato)
- **Mana/stamina:** quanto regenera por segundo? quanto custa o ataque básico vs especial? o que acontece ao zerar (só básico? totalmente inerte?)
- **Dano recebido:** quanto HP o jogador tem? quanto dano tira um hit padrão? quantos erros o jogador pode cometer por sala?
- **Escalada de poder:** o ataque básico do minuto 1 é o mesmo do minuto 30, ou escala? se escala, por quê (números maiores vs novas mecânicas)?

**Cravar antes de fechar:** todos os números acima, regra de mana zero, regra de telegrafia, TTK padrão e tanque.

---

## 3. IA dos inimigos

- Quantos **tipos distintos** de inimigo no MVP? (regra prática: 3–5 comportamentos base é suficiente; mais vira conteúdo, não design)
- Para cada tipo, defina: **movimento** (chaser/ranged/tank/swarm/sniper), **ataque** (dano, telegrafia em segundos, alcance), **HP**, **speed vs jogador**.
- Qual é o **papel tático** de cada um? (ex: o swarm obriga a se mover, o sniper obriga a usar cobertura, o tank obriga a focar DPS). Sem papel distinto = inimigo redundante.
- **Telegrafia:** todo ataque inimigo dá quanto tempo de aviso antes de atingir? (regra: 0.3–0.8s é reativo; <0.2s é unfair)
- **Spawing:** quantos inimigos simultâneos na tela no pico? (limite de tela evita caos visual e frame drops)
- **Scaling:** HP/dano dos inimigos escala com andar? com tempo? fórmula aproximada.
- **Bosses:** quantos no MVP? cada um tem fase? mecânica única obrigatória (não só "bate mais forte")?
- Comportamento de **fuga/agro/leashing**: inimigo persegue infinito ou desiste? limite de sala?

**Cravar antes de fechar:** lista de tipos com papel tático, telegrafia de cada um, limite de tela, fórmula de scaling, número e gimmick de cada boss.

---

## 4. Progressão intra-run (upgrades/builds)

- O jogador fica mais forte durante a run por: **números** (stats), **novas opções** (armas/spells), ou **sinergias** (builds)? Qual predomina?
- Onde o jogador escolhe upgrades? (loja, altar, level-up, fim de sala)
- **Frequência:** quantos upgrades por run? (ex: 1 a cada 2–3 salas)
- **Magnitude:** cada upgrade muda o dano em quanto? (+10%? +2 flat? dobra algo?)
- Há **princípio de escolha**? (a cada upgrade, 3 opções e pega 1? ou árvore fixa?)
- **Sinergia vs power creep:** upgrades empilham sinergicamente (build) ou são buffs isolados? builds são a alma do roguelike — sem sinergia, é só um action game.
- **Quebra de regras:** algum upgrade altera o verbo central (ex: ataque básico vira área)? esses são os mais memoráveis.
- **Maldição/trade-off:** algum upgrade tem custo? (roguelike bom oferece poder com preço)
- **Cap de poder:** existe teto? o que impede o jogador de ficar infinitamente forte e quebrar o balanceamento?

**Cravar antes de fechar:** fonte de poder (números/opções/sinergia), frequência, magnitude, mecanismo de escolha, ao menos 1 exemplo de sinergia e 1 de trade-off, teto de poder.

---

## 5. Meta-progression (entre runs)

- O jogador leva **algo** de uma run morta para a próxima? (nada / unlocks / moeda persistente / níveis permanentes)
- Se sim, **o que** e **quanto**? (moeda X por run, desbloqueia Y itens no pool)
- **Permadeath** real ou soft? (roda do zero em HP/upgrades, ou mantém parte?)
- Risco de **prender** o jogador em farm: a meta-progression é obrigatória para vencer, ou é QoL/conteúdo opcional? (meta-progression obrigatória vira moída — perigo)
- **Pacing do unlock:** quantas runs até desbloquear tudo? (muitas = grind; poucas = sem sentido de progressão meta)
- A morte tem **causa legível**? o jogador entende por que perdeu (telemetria interna clara) para a próxima run melhorar?
- Existe **atalho** para jogadores avançados pularem a meta-progression? (ex: modo "boss rush" depois de X clears)

**Cravar antes de fechar:** o que persiste, quanto persiste por run, se meta é obrigatória ou opcional, nº de runs para full unlock, política de permadeath.

---

## 6. Economia (ouro/itens/lojas/sinks)

- **Moeda principal:** qual? (ouro, gemas, almas). Quanto o jogador ganha por sala em média?
- **Fontes:** de onde vem a moeda? (drops de inimigo, baú, sala de recompensa)
- **Sinks:** onde gasta? (loja, altar de sacrifício, reroll, reparo)
- **Preços:** item de consumível vs item permanente — faixa de preço em relação ao ganho médio por run.
- **Loja:** aparece quantas vezes por run? é garantida ou RNG? tem reroll e qual o custo?
- **Inflação/run:** preços sobem ao longo da run? (previne acumulação ociosa)
- **Itens consumíveis vs equipáveis:** proporção no pool. Consumíveis criam decisão imediata; equipáveis criam build.
- **Decisão de não-comprar:** quando o jogador decide NÃO gastar? (sempre comprar = economia sem decisão = fraca)
- **Sinks de final de run:** o que faz o jogador não acumular riqueza infinita? (moeda expira? converte em meta-currency?)

**Cravar antes de fechar:** moeda + ganho médio/sala, faixas de preço, frequência de loja, política de reroll, ao menos 1 sink obrigatório, 1 cenário de não-comprar.

---

## 7. Geração procedural (salas/andares/layout)

- **Unidade gerada:** sala individual, andar inteiro, ou mapa contínuo?
- **Algoritmo:** BSP, celular automata, placement por regras, graph de salas+corredores? (defender a escolha em relação ao gameplay)
- **Tamanho:** salas em tiles (mín/máx)? andar tem quantas salas em média?
- **Variedade:** quantos **tipos** de sala? (combate, loja, altar, tesouro, elite, descanso, event). Quantas no MVP?
- **Garantias:** toda run tem loja? toda run tem descanso? (regras de floor minimum evitam runs injustas)
- **Pathing:** há caminho obrigatório (linear) ou branches? branches criam **escolha significativa** (arriscar elite por loot vs rota segura)?
- **Dificuldade por andar:** scaling de inimigos/loot por profundidade. Andar 1 vs andar final — diferença numérica.
- **Seed e reproducibilidade:** run pode ser reproduzida por seed? (importante para debugging e desafios compartilhados)
- **Anti-frustração:** o que impede uma run de nascer morta (loot ruim + inimigos duros sem loja)? floor minimums? pity timer?
- **Especial rooms:** boss room obrigatória por andar? safe room? como o gerador as posiciona.

**Cravar antes de fechar:** unidade + algoritmo, dimensões, tipos de sala no MVP, garantias mínimas por andar, regra de pathing/branch, fórmula de scaling por andar, política anti-run-morta.

---

## 8. Condições de vitória e derrota

- **Vitória:** o que define "ganhei"? (matar boss final, sobreviver N andares, score?)
- **Comprimento da run vencedora:** em minutos, do início ao boss final. (15–45min é a faixa saudável; <10 não há progressão, >60 vira exaustão)
- **Derrota:** só por HP=0? tem outras (tempo, queda, condição especial)?
- **Quantos erros** o jogador médio comete antes de morrer numa run bem-jogada? (muito poucos = punitivo demais; muitos = sem tensão)
- **Game over:** volta do absoluto zero (permadeath), checkpoint de andar, ou continue limitado?
- **Difícil vs injusto:** a morte é sempre atribuível a decisão do jogador? (se morre por RNG sem contramedida, é unfair)
- **Vitória "fácil":** existe condição de vitória cedo/alternativa (ex: escape em X min)? cria replayabilidade.
- **Endgame:** após vencer, tem NG+, endless, ou acaba? o que sustenta quem terminou.

**Cravar antes de fechar:** condição de vitória mensurável, duração-alvo da run, política de morte/continue, nº de erros tolerados, política de endgame.

---

## 9. Balanceamento e curva de dificuldade

- **Curva:** HP do jogador e dano dos inimigos sobem em que proporção ao longo da run? (se inimigo sobe mais rápido que jogador se fortalece, vira muro)
- **Skill vs RNG:** quanto do resultado é decisão do jogador vs sorte do loot/geração? (alvo: 70/30 skill/RNG para não virar cassino)
- **Power spike:** onde o jogador "quebra" o jogo com build boa? é desejável (recompensa mastery) ou bug de balanceamento?
- **Piso de poder:** mesmo com loot ruim, o jogador mínimo tem chance? (sem piso = run morta por RNG)
- **Teto de poder:** com loot perfeito, quanto o jogador excede o desafio? (pouco = sem recompensa pra mastery; muito = sem desafio)
- **TTK simétrico:** quanto tempo o jogador mata o inimigo vs quanto tempo o inimigo mata o jogador? (relação define o feel do combate)
- **Spike de dificuldade:** há picos intencionais (elite, boss) e vales (descanso, loja)? o ritmo é ondulado, não linear.
- **Telemetria:** quais métricas internas você usaria para ajustar balanceamento? (TTK médio, % de mortes por andar, builds vencedoras) — define agora o que medir.

**Cravar antes de fechar:** curva de HP/dano por andar, proporção skill/RNG declarada, piso e teto de poder, picos/vales de dificuldade, lista de métricas de telemetria.

---

## 10. Ritmo de jogo (pacing)

- **Duração da sessão típica** (uma run): minutos-alvo.
- **Densidade:** numa sala de combate, quantos segundos de ação ativa? e segundos de "respiro" entre salas?
- **Climax:** onde estão os picos de intensidade (boss, elite, wave)? e os vales (loja, descanso, exploração)?
- **Flow state:** a curva de dificuldade mantém o jogador na zona de flow (desafiando sem frustrar) ou oscila demais?
- **Tédio vs caos:** no andar 1 o jogador acha lento? no final acha caótico demais? onde está o sweet spot.
- **Decisão vs execução:** quanto tempo o jogador gasta decidindo (upgrade, path, compra) vs executando (combat)? proporção-alvo.
- **Repetição:** qual é a rotação de salas antes de algo novo aparecer? (muitas salas idênticas = fadiga)

**Cravar antes de fechar:** duração-alvo da run, proporção ação/respiro, posição dos climax/vales, proporção decisão/execução, regra anti-repetição.

---

## 11. Escopo e MVP

- **Corte do MVP:** o que entra na versão 1 jogável de ponta a ponta? Liste **features in** e **features out**.
- **Custo de conteúdo:** quantos inimigos, salas, upgrades, bosses no MVP? (cada um é arte + balanceamento + teste)
- **Caminho crítico:** qual é o menor caminho de "abrir o jogo" a "vencer"? ele é jogável hoje?
- **Risco técnico:** qual feature tem maior incerteza técnica? (geração procedural, IA, syncing online) — qual é o plano B se estourar.
- **Vertical slice:** qual é o slice que prova o fun (1 andar, 3 inimigos, 1 boss, 5 upgrades)? se esse slice não for divertido, o jogo não é.
- **Definição de "pronto"** para o MVP: critérios mensuráveis (ex: run completa de 5 andares, vitória alcançável, sem crash).
- **O que NÃO entra:** listar explicitamente (online, crafting, 10 classes, etc.) é decisão de escopo tão importante quanto o que entra.

**Cravar antes de fechar:** lista de features in/out, contagem de conteúdo do MVP, caminho crítico, maior risco + plano B, definição do vertical slice, critérios mensuráveis de "pronto".
