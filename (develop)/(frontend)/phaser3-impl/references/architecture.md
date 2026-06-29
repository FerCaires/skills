# Arquitetura Modular, Object Pooling e Spritesheet

Padrões obrigatórios para código Phaser 3 limpo, modular e otimizado para Web.

## Sumário
1. [Arquitetura modular](#1-arquitetura-modular)
2. [Object Pooling (projéteis)](#2-object-pooling-projéteis)
3. [Configuração de Spritesheet (comentários obrigatórios)](#3-configuração-de-spritesheet-comentários-obrigatórios)
4. [Carregamento de assets no Preloader](#4-carregamento-de-assets-no-preloader)

---

## 1. Arquitetura modular

Phaser 3 não tem ECS nativo. Use uma arquitetura **pragmática em camadas** sobre GameObjects:

| Camada | Responsabilidade | Pasta |
|--------|------------------|-------|
| **config** | Números tunáveis (HP, dano, cooldowns, velocidades). Espelha o GDD. | `src/config/` |
| **states** | Scenes Phaser (Boot, Preloader, MainMenu, Play, GameOver). | `src/states/` |
| **entities** | Objetos de jogo (Player, Enemy, Projectile). Classe que envolve um sprite Phaser + a lógica daquela entidade. | `src/entities/` |
| **systems** | Lógica transversal (spawning, roteamento de colisões, progressão, geração de salas). Não renderizam diretamente. | `src/systems/` |
| **pools** | Object Pools (projéteis, partículas, inimigos recorrentes). | `src/pools/` |

### Exemplo de entidade

```ts
// src/entities/Player.ts
import Phaser from 'phaser';
import { PLAYER_SPEED, PLAYER_HP } from '../config/game';

export class Player {
  readonly sprite: Phaser.Physics.Arcade.Sprite;
  private hp = PLAYER_HP;

  constructor(scene: Phaser.Scene, x: number, y: number, texture: string) {
    this.sprite = scene.physics.add.sprite(x, y, texture);
    this.sprite.setCollideWorldBounds(true);
  }

  takeDamage(amount: number): void {
    this.hp = Math.max(0, this.hp - amount);
    if (this.hp === 0) this.die();
  }

  private die(): void {
    this.sprite.scene.scene.start('GameOver');
  }

  update(cursors: Phaser.Types.Input.Keyboard.CursorKeys, _delta: number): void {
    const v = PLAYER_SPEED;
    if (cursors.left?.isDown)  this.sprite.setVelocityX(-v);
    else if (cursors.right?.isDown) this.sprite.setVelocityX(v);
    else this.sprite.setVelocityX(0);
    // ... vertical análogo
  }
}
```

**Princípios:**
- A entidade **não** conhece outras entidades; colisões são roteadas no `Play` ou num `CollisionSystem`.
- Números vem de `config/`, nunca literais no método.
- O `update` da entidade é chamado pelo `update` da cena `Play`.

---

## 2. Object Pooling (projéteis)

**Regra inquebrável:** projéteis, ondas e partículas **nunca** são `create`/`destroy` por frame. Use um pool que pré-aloca N objetos e faz acquire/release.

### Implementação de referência

```ts
// src/pools/ProjectilePool.ts
import Phaser from 'phaser';

type Projectile = Phaser.Physics.Arcade.Image;

export class ProjectilePool {
  private readonly group: Phaser.Physics.Arcade.Group;
  private readonly free: Projectile[] = [];

  constructor(
    private readonly scene: Phaser.Scene,
    private readonly texture: string,
    private readonly max: number,
  ) {
    this.group = scene.physics.add.group();
    for (let i = 0; i < max; i++) {
      const p = this.group.create(0, 0, texture) as Projectile;
      this.deactivate(p);
      this.free.push(p);
    }
  }

  /** Agrupa os projéteis ativos para uso em overlap/collider. */
  get activeGroup(): Phaser.Physics.Arcade.Group {
    return this.group;
  }

  /** Pega um projétil livre e o posiciona/dispara. Retorna null se pool esgotada. */
  acquire(x: number, y: number, vx: number, vy: number): Projectile | null {
    const p = this.free.pop();
    if (!p) return null; // política: descarta o disparo (ou expanda o pool com teto)
    p.setPosition(x, y).setActive(true).setVisible(true);
    const body = p.body as Phaser.Physics.Arcade.Body;
    body.enable = true;
    p.setVelocity(vx, vy);
    return p;
  }

  /** Devolve o projétil ao pool (chamar em out-of-bounds ou colisão). */
  release(p: Projectile): void {
    this.deactivate(p);
    this.free.push(p);
  }

  /** No update da cena: devolve projéteis que saíram da tela. */
  updateBounds(bounds: Phaser.Geom.Rectangle): void {
    this.group.getChildren().forEach((obj) => {
      const p = obj as Projectile;
      if (!p.active) return;
      if (!bounds.contains(p.x, p.y)) this.release(p);
    });
  }

  private deactivate(p: Projectile): void {
    p.setActive(false).setVisible(false).setVelocity(0, 0);
    const body = p.body as Phaser.Physics.Arcade.Body;
    body.enable = false;
  }
}
```

### Uso típico (na cena Play)

```ts
// create():
this.projectiles = new ProjectilePool(this, 'arrow', 64);
// colisão de projétil vs inimigos:
this.physics.add.overlap(this.projectiles.activeGroup, this.enemies, this.onHit, undefined, this);

// update(): retornar projéteis que saíram do mundo
this.projectiles.updateBounds(this.physics.world.bounds);

// ao disparar (ex: clique/tecla):
this.projectiles.acquire(this.player.sprite.x, this.player.sprite.y, vx, vy);
```

**Por que importa:** sem pool, cada flecha/onda vira `create` (alocação) + `destroy` (GC) — causa hitching em ondas longas. Com pool, o número de objetos é fixo; só alterna active/visible/body.enable.

---

## 3. Configuração de Spritesheet (comentários obrigatórios)

**Sempre** que carregar um spritesheet, comente **exatamente** onde o usuário configura os
parâmetros com base na imagem que ele gerou. Esta é uma regra da skill.

### Padrão de comentário (use sempre)

```ts
// this.load.spritesheet('player', 'assets/player.png', {
//   frameWidth:  32,   // <-- LARGURA de UM frame, em px (obrigatório)
//   frameHeight: 32,   // <-- ALTURA de UM frame, em px (obrigatório)
//   margin:      0,    // <-- px de borda ANTES do primeiro frame (0 se não houver margem)
//   spacing:     0,    // <-- px ENTRE frames adjacentes (0 se os frames estiverem colados)
// });
//
// COMO MEDIR a partir da imagem gerada:
//   - Abra a spritesheet em um editor (ex: Aseprite, Sprite Sheet Packer).
//   - frameWidth/frameHeight = tamanho de UM quadro do animação.
//   - Ex: grid 256x256 com 8 colunas x 4 linhas → frameWidth=32, frameHeight=64.
//   - margin/spacing: confira se o exportador adicionou borda/espaçamento; default 0.
//   - O total (frameWidth*N + spacing*(N-1) + 2*margin) deve bater com a largura da imagem.
```

### Criação de animações (no Preloader.create ou Play.create)

```ts
// Animação de andar do player (assume spritesheet 'player' já carregada).
// CONFIGURE os frames conforme a ordem na sua spritesheet:
//   - key: nome único da animação
//   - frames: range [inicio, fim] dos frames de "andar" na spritesheet
//   - frameRate: quadros por segundo (ajuste ao feel desejado)
//   - repeat: -1 = loop infinito
this.anims.create({
  key: 'player-walk',
  frames: this.anims.generateFrameNumbers('player', { start: 0, end: 7 }),
  frameRate: 12,
  repeat: -1,
});
```

---

## 4. Carregamento de assets no Preloader

Centralize **todo** carregamento em `Preloader.preload()`. Mantenha ordem: imagens →
spritesheets → áudio → mapas. Comente cada bloco com a feature a que pertence.

```ts
preload(): void {
  // --- Feature 001: Combate do Mago ---
  // this.load.image('tile', 'assets/tile.png');
  // this.load.spritesheet('player', 'assets/player.png', { /* ver seção Spritesheet */ });
  // this.load.audio('shoot', 'assets/shoot.wav');

  // --- Feature 002: ... ---
}
```

**Notas:**
- Assets em `src/assets/` são importados pelo Vite (hash no build). Assets em `public/`
  são servidos como-is (sem hash). Para cache agressivo no CloudFront, **prefira `src/assets/`**
  (Vite hasha o nome → cache longo seguro). Veja `references/aws-deploy.md`.
- Para áudio, forneça fallback (Phaser suporta múltiplos formatos): `this.load.audio('shoot', ['assets/shoot.mp3','assets/shoot.ogg'])`.
