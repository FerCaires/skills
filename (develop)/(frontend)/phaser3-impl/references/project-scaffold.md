# Project Scaffold — Vite + TypeScript + Phaser 3

Bootstrap do projeto quando ainda não existe `package.json` + `src/states/`. Use ao
implementar a **primeira** feature. Entregue o scaffold como a primeira etapa testável
("rode `npm run dev`, veja a tela Boot com barra de progresso e depois o MainMenu").

## Sumário
1. [Comandos de bootstrap](#1-comandos-de-bootstrap)
2. [Estrutura de pastas](#2-estrutura-de-pastas)
3. [Arquivos-base](#3-arquivos-base)
   - [package.json (scripts)](#packagejson-scripts)
   - [vite.config.ts](#viteconfigts)
   - [tsconfig.json](#tsconfigjson)
   - [index.html](#indexhtml)
   - [src/main.ts](#srcmaints)
   - [src/states/Boot.ts](#srcstatesbootts)
   - [src/states/Preloader.ts](#srcstatespreloaderts)
   - [src/states/MainMenu.ts](#srcstatesmainmenuts)
   - [src/states/Play.ts](#srcstatesplayts)
   - [src/states/GameOver.ts](#srcstatesgameoverts)
4. [Convenções](#4-convenções)

---

## 1. Comandos de bootstrap

Na **raiz do repo** (assumindo vazio ou só com `.devin/` e `docs/`):

```bash
# Cria projeto Vite vanilla-ts na pasta atual
npm create vite@latest . -- --template vanilla-ts

# Instala Phaser 3 (última estável) + tipos
npm install phaser
# @types/phaser vem no próprio pacote Phaser 3 (tipos bundled). Sem @types/phaser separado.

# Dependências de tipo/dev já trazidas pelo template (typescript, vite)
```

> Se `npm create vite` reclamar de pasta não-vazia, confirme a sobrescrita dos arquivos
> de template (NÃO sobrescreva `.devin/`, `docs/` nem `.git/`).

Após o bootstrap, **substitua** o `index.html` e `src/` do template pelo conteúdo desta
referência. Rode `npm run dev` e valide a cena Boot → Preloader → MainMenu.

---

## 2. Estrutura de pastas

```
/
├── index.html
├── package.json
├── vite.config.ts
├── tsconfig.json
├── src/
│   ├── main.ts
│   ├── config/
│   │   └── game.ts            # config central (dimensões, física, balanceamento)
│   ├── states/
│   │   ├── Boot.ts
│   │   ├── Preloader.ts
│   │   ├── MainMenu.ts
│   │   ├── Play.ts
│   │   └── GameOver.ts
│   ├── entities/              # criadas conforme features
│   ├── systems/               # criados conforme features
│   ├── pools/                 # criados conforme features
│   └── assets/                # colocar sprites/áudio aqui (ou em public/)
└── public/                    # assets estáticos servidos diretos (opcional)
```

---

## 3. Arquivos-base

### package.json (scripts)

Garanta estes scripts (o template Vite já traz `dev`/`build`/`preview`):

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc --noEmit && vite build",
    "preview": "vite preview",
    "typecheck": "tsc --noEmit"
  }
}
```

> `build` roda `tsc --noEmit` (typecheck) **antes** do `vite build` — falha de tipo quebra o build. Alinhado à regra "Status: implementado só com build passando".

### vite.config.ts

```ts
import { defineConfig } from 'vite';

export default defineConfig({
  base: './',            // caminhos relativos — essencial para S3/CloudFront
  build: {
    target: 'es2020',
    outDir: 'dist',
    assetsInlineLimit: 0, // não inlina assets; melhor cache no CloudFront
  },
  server: {
    host: true,
    port: 5173,
  },
});
```

### tsconfig.json

Use o gerado pelo template Vite vanilla-ts e **garanta**:

```jsonc
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "noImplicitAny": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true
  },
  "include": ["src"]
}
```

### index.html

```html
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <title>Título do Jogo</title>
    <style>
      html, body { margin: 0; padding: 0; background: #111; height: 100%; }
      #game { display: flex; align-items: center; justify-content: center; height: 100vh; }
      canvas { image-rendering: pixelated; } /* ajuste conforme estilo de arte */
    </style>
  </head>
  <body>
    <div id="game"></div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>
```

### src/main.ts

```ts
import Phaser from 'phaser';
import { GAME_WIDTH, GAME_HEIGHT, BG_COLOR } from './config/game';
import { Boot } from './states/Boot';
import { Preloader } from './states/Preloader';
import { MainMenu } from './states/MainMenu';
import { Play } from './states/Play';
import { GameOver } from './states/GameOver';

new Phaser.Game({
  type: Phaser.AUTO,
  width: GAME_WIDTH,
  height: GAME_HEIGHT,
  backgroundColor: BG_COLOR,
  parent: 'game',
  physics: {
    default: 'arcade',
    arcade: { gravity: { x: 0, y: 0 }, debug: false },
  },
  scale: {
    mode: Phaser.Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH,
  },
  scene: [Boot, Preloader, MainMenu, Play, GameOver],
});
```

### src/config/game.ts

Config central — **números aqui espelham o GDD**. Facilita tuning sem caçar pelo código.

```ts
export const GAME_WIDTH = 800;
export const GAME_HEIGHT = 600;
export const BG_COLOR = '#111111';
```

### src/states/Boot.ts

Configura o jogo e vai para o Preloader.

```ts
import Phaser from 'phaser';

export class Boot extends Phaser.Scene {
  constructor() {
    super('Boot');
  }

  preload(): void {
    // Aqui só o mínimo para a barra de progresso (se houver). Resto no Preloader.
  }

  create(): void {
    this.scene.start('Preloader');
  }
}
```

### src/states/Preloader.ts

Carrega **todos** os assets da feature atual e mostra barra de progresso.

```ts
import Phaser from 'phaser';

export class Preloader extends Phaser.Scene {
  private bar!: Phaser.GameObjects.Rectangle;
  private barBg!: Phaser.GameObjects.Rectangle;

  constructor() {
    super('Preloader');
  }

  preload(): void {
    const { width, height } = this.scale;
    this.barBg = this.add.rectangle(width / 2, height / 2, width * 0.6, 24, 0x333333);
    this.bar = this.add.rectangle(width / 2 - width * 0.3, height / 2, 0, 20, 0xffffff).setOrigin(0, 0.5);

    this.load.on('progress', (p: number) => { this.bar.width = width * 0.6 * p; });

    // === CARREGAMENTO DE ASSETS DA FEATURE ===
    // Spritesheets: veja references/architecture.md (seção Spritesheet) para
    // os comentários obrigatórios de frameWidth/frameHeight/margin/spacing.
    // this.load.spritesheet('player', 'assets/player.png', { ... });
    // this.load.image('tile', 'assets/tile.png');
    // this.load.audio('shoot', 'assets/shoot.wav');
  }

  create(): void {
    this.scene.start('MainMenu');
  }
}
```

### src/states/MainMenu.ts

```ts
import Phaser from 'phaser';

export class MainMenu extends Phaser.Scene {
  constructor() {
    super('MainMenu');
  }

  create(): void {
    const { width, height } = this.scale;
    this.add.text(width / 2, height / 2 - 40, 'TÍTULO DO JOGO', { fontSize: '32px', color: '#fff' }).setOrigin(0.5);

    const btn = this.add.text(width / 2, height / 2 + 40, 'Jogar', { fontSize: '24px', color: '#fff' })
      .setOrigin(0.5)
      .setInteractive({ useHandCursor: true });

    btn.on('pointerup', () => this.scene.start('Play'));
  }
}
```

### src/states/Play.ts

A cena do gameplay. Cresce conforme features são implementadas.

```ts
import Phaser from 'phaser';

export class Play extends Phaser.Scene {
  constructor() {
    super('Play');
  }

  create(): void {
    // Implementado por feature (Player, inimigos, pools, systems...).
  }

  update(_time: number, _delta: number): void {
    // Loop principal — chama update de entidades/systems.
  }
}
```

### src/states/GameOver.ts

```ts
import Phaser from 'phaser';

export class GameOver extends Phaser.Scene {
  constructor() {
    super('GameOver');
  }

  create(): void {
    const { width, height } = this.scale;
    this.add.text(width / 2, height / 2 - 20, 'Game Over', { fontSize: '32px', color: '#fff' }).setOrigin(0.5);
    const btn = this.add.text(width / 2, height / 2 + 40, 'Tentar de novo', { fontSize: '20px', color: '#fff' })
      .setOrigin(0.5)
      .setInteractive({ useHandCursor: true });
    btn.on('pointerup', () => this.scene.start('Play'));
  }
}
```

---

## 4. Convenções

- **Números tunáveis vão em `src/config/`**, nunca hardcoded no meio de systems. Espelha o GDD e permite ajuste rápido de balanceamento.
- **Keys de assets** em string constants (ex: `ASSET_PLAYER = 'player'`) para evitar typos. Crie `src/config/assets.ts` quando a feature exigir.
- **Cena = Scene Phaser.** Estado de jogo = estado da cena. Transições via `this.scene.start('Key')`.
- **Física**: Arcade por padrão (top-down sem gravidade — `gravity: {x:0, y:0}`). Só troque para Matter se o GDD exigir física complexa.
- **`base: './'` no Vite** é obrigatório para o build funcionar em S3/CloudFront sem path absoluto quebrado.
