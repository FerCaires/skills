# Syntax Gherkin — Referência Completa

## Estrutura Básica

```gherkin
Funcionalidade: Nome da Feature
  Como [perfil do usuário]
  Quero [ação/objetivo]
  Para [benefício/valor]

  Contexto:
    Dado que [pré-condição global]

  Cenário: Nome do cenário
    Dado que [estado inicial]
    Quando [ação do usuário]
    Então [resultado esperado]
    E [resultado adicional]
```

## Palavras-Chave

| Palavra | Uso | Exemplo |
|---------|-----|---------|
| `Funcionalidade` | Título da feature | `Funcionalidade: Cadastro de Categorias` |
| `Cenário` | Caso de teste individual | `Cenário: Cadastrar categoria válida` |
| `Esquema do Cenário` | Cenário com variações | `Esquema do Cenário: Validar <campo>` |
| `Dado` / `Dado que` | Estado inicial | `Dado que o usuário está na tela de categorias` |
| `Quando` | Ação executada | `Quando ele preenche o nome "Alimentação"` |
| `Então` | Resultado esperado | `Então a categoria é criada com sucesso` |
| `E` / `Mas` | Passos adicionais | `E a mensagem "Categoria criada" é exibida` |
| `Antes de cada` | Setup executado antes de cada cenário (substitui Background) | `Antes de cada` |
| `Contexto` | Pré-condições compartilhadas | `Contexto: Dado que existem categorias cadastradas` |
| `Exemplos` / `Esquema` | Tabela de dados para Scenario Outline | `Exemplos:` |

## Scenario Outline (com variações)

```gherkin
Esquema do Cenário: Validar campos obrigatórios
  Dado que o usuário está no formulário de categorias
  Quando ele preenche o nome "<nome>"
  E a cor "<cor>"
  E clica em salvar
  Então <resultado>

  Exemplos:
    | nome          | cor    | resultado                                    |
    | Alimentação   | #FF00  | a categoria é criada com sucesso             |
    |               | #FF00  | uma mensagem de erro é exibida               |
    | Alimentação   |        | uma mensagem de erro é exibida               |
    | A             | #FF00  | uma mensagem de erro de tamanho é exibida    |
```

## Background

Usado para pré-condições que se aplicam a **todos** os cenários da feature. Limitar a máx. 3 passos.

```gherkin
Funcionalidade: Gestão de Despesas

  Contexto:
    Dado que o usuário está autenticado
    E que existem categorias cadastradas
```

## Tags

Tags são aplicadas antes da Funcionalidade ou do Cenário:

```gherkin
@wip
Funcionalidade: Cadastro de Categorias

  @smoke
  Cenário: Criar categoria válida
    ...

  @regressao @p2
  Cenário: Tentar criar categoria duplicada
    ...
```

### Tags comuns do projeto

| Tag | Uso |
|-----|-----|
| `@wip` | Cenário em desenvolvimento |
| `@smoke` | Testes críticos de sanity check |
| `@regressao` | Testes de regressão |
| `@p1` / `@p2` / `@p3` | Prioridade |

## Dados de Exemplo

### Tabela simples

```gherkin
Dado que existem as categorias:
  | nome        | cor    |
  | Alimentação | #FF00  |
  | Transporte  | #00FF  |
```

### Outras palavras-chave úteis

| Palavra | Uso |
|---------|-----|
| `Dado que` | Estado inicial complexo |
| `Dado` | Estado inicial simples |
| `E` | Passo adicional (mesmo tipo do anterior) |
| `Mas` | Passo adicional com contraste |
| `Então` | Assertion final |
| `E` (após Então) | Assertion adicional |

## Regras de Escrita

1. **PT-BR**: todos os passos em português brasileiro
2. **Clareza**: cada passo deve ser compreensível isoladamente
3. **Atomicidade**: um cenário = um comportamento específico
4. **Dados explícitos**: não usar "algo" ou "valor" — usar dados concretos
5. **Resultados observáveis**: Then deve descrever algo verificável (mensagem, estado, URL)
6. **Evitar detalhes de implementação**: não mencionar botões CSS, IDs, etc.
