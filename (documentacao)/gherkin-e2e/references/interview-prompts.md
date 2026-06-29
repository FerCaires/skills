# Perguntas da Entrevista — Roteiro Adaptativo

## Como Usar

Esta é uma referência. Não faça todas as perguntas de uma vez. Leia a spec (se existir) e faça apenas as perguntas relevantes que não estejam respondidas. O objetivo é preencher lacunas, não interrogar o usuário.

## Perguntas por Domínio

### 1. Escopo e Ações

> **Objetivo:** entender o que o usuário pode fazer na feature.

- Quais ações o usuário pode realizar? (criar, editar, listar, excluir, filtrar, etc.)
- Existe alguma ação que depende de permissão especial?
- O usuário pode desfazer alguma ação? (ex: cancelar, voltar)

**Follow-up:** Se o usuário diz "CRUD completo" → perguntar: *"A exclusão é física ou lógica? Há confirmação antes de excluir?"*

### 2. Regras de Negócio

> **Objetivo:** mapear todas as validações e restrições.

- Quais campos são obrigatórios?
- Quais validações de formato existem? (email, CPF, valor monetário, etc.)
- Quais regras de unicidade existem? (ex: nome de categoria duplicado)
- Quais regras de integridade existem? (ex: não pode excluir categoria com despesas)
- Quais limites numéricos existem? (mínimo, máximo, casas decimais)

**Follow-up:** Se o usuário diz "validação de valor" → perguntar: *"Qual é o mínimo aceitável? E se for zero? Negativo? Acima do limite?"*

### 3. Estado Inicial e Dados

> **Objetivo:** definir o Given de cada cenário.

- Quais dados precisam existir antes do cenário?
- Quais dados o usuário precisa ter para acessar a feature? (autenticação, perfil, etc.)
- A feature tem estados? (ex: pendente → aprovado → concluído)
- Quais são as condições iniciais para cada cenário de erro?

**Follow-up:** Se o usuário diz "precisa de categorias" → perguntar: *"Quantas categorias? Com quais dados? É necessário ter uma específica?"*

### 4. Fluxo Principal (Happy Path)

> **Objetivo:** descrever o caminho de sucesso mais comum.

- Qual é a sequência de passos para realizar a ação principal?
- O que o usuário vê após cada passo?
- Qual é o resultado final esperado?
- Há alguma mensagem de sucesso?

**Follow-up:** Se o usuário descreve apenas a ação → perguntar: *"O que acontece na tela após isso? Qual mensagem aparece? O usuário é redirecionado?"*

### 5. Variações e Edge Cases

> **Objetivo:** cobrir cenários além do happy path.

- O que acontece se o campo estiver vazio?
- O que acontece se o valor estiver no limite (mínimo/máximo)?
- O que acontece se houver duplicação de dados?
- O que acontece se a conexão cair durante a ação?
- Há algum cenário de concorrência? (dois usuários editando ao mesmo tempo)

**Follow-up:** Se o usuário diz "não sei" → registrar como `@pending` e seguir para o próximo domínio.

### 6. Integração com Outras Features

> **Objetivo:** mapear dependências.

- Esta feature depende de outra feature existente?
- A feature é afetada por mudanças em outras features?
- Há dados que vêm de outras features? (ex: despesa puxa lista de categorias)
- A feature alimenta alguma outra feature? (ex: despesas alimentam o dashboard)

### 7. Feedback e UX

> **Objetivo:** definir as assertions de UI.

- Quais mensagens de sucesso aparecem?
- Quais mensagens de erro aparecem? (texto exato)
- Há confirmação antes de ações destrutivas?
- O formulário é resetado após sucesso?
- O usuário é redirecionado após a ação?
- Há loading/spinner durante processamento?

## Ordem Recomendada

1. Escopo → 2. Regras → 3. Estado → 4. Happy Path → 5. Variações → 6. Integração → 7. UX

Pule domínios que já estiverem cobertos pela spec. Volte atrás se uma resposta revelar uma lacuna.

## Regra de Ouro

**Não invente cenários.** Se o usuário não mencionou algo:
- Pergunte diretamente
- Se não souber, marque como `@pending`
- Nunca assuma comportamento não especificado
