#language: pt
Funcionalidade: CRUD de Categorias
  Como usuário do sistema de finanças
  Quero gerenciar minhas categorias de despesas
  Para classificar e organizar meus gastos

  Contexto:
    Dado que o usuário está na tela de categorias

  @smoke
  Cenário: Cadastrar categoria com dados válidos
    Quando ele clica em "Nova Categoria"
    E preenche o nome "Alimentação"
    E seleciona a cor "#FF5733"
    E clica em "Salvar"
    Então a categoria "Alimentação" aparece na lista
    E a mensagem "Categoria criada com sucesso" é exibida

  Cenário: Tentar cadastrar categoria sem nome
    Quando ele clica em "Nova Categoria"
    E deixa o campo nome vazio
    E clica em "Salvar"
    Então uma mensagem de erro "Nome é obrigatório" é exibida
    E a categoria não é criada

  Cenário: Tentar cadastrar categoria com nome duplicado
    Dado que existe a categoria "Alimentação"
    Quando ele clica em "Nova Categoria"
    E preenche o nome "Alimentação"
    E clica em "Salvar"
    Então uma mensagem de erro "Já existe uma categoria com este nome" é exibida

  Cenário: Editar nome de categoria existente
    Dado que existe a categoria "Alimentação"
    Quando ele clica em editar a categoria "Alimentação"
    E altera o nome para "Alimentação e Bebidas"
    E clica em "Salvar"
    Então o nome da categoria é atualizado para "Alimentação e Bebidas"
    E a mensagem "Categoria atualizada com sucesso" é exibida

  Cenário: Excluir categoria sem dependências
    Dado que existe a categoria "Lazer"
    E que não existem despesas vinculadas a "Lazer"
    Quando ele clica em excluir a categoria "Lazer"
    E confirma a exclusão
    Então a categoria "Lazer" é removida da lista
    E a mensagem "Categoria excluída com sucesso" é exibida

  Cenário: Tentar excluir categoria com despesas vinculadas
    Dado que existe a categoria "Alimentação"
    E que existem despesas vinculadas a "Alimentação"
    Quando ele clica em excluir a categoria "Alimentação"
    Então uma mensagem de erro "Não é possível excluir categoria com despesas vinculadas" é exibida
    E a categoria permanece na lista

  @wip
  Cenário: Excluir categoria sem confirmação
    Dado que existe a categoria "Lazer"
    Quando ele clica em excluir a categoria "Lazer"
    E não confirma a exclusão
    Então a categoria "Lazer" permanece na lista
