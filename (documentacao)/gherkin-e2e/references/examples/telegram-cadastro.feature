#language: pt
Funcionalidade: Cadastro de Despesas via Telegram
  Como usuário do bot de finanças no Telegram
  Quero cadastrar despesas enviando mensagens
  Para registrar gastos de forma rápida e prática

  Contexto:
    Dado que o bot está configurado com o token válido
    E que o usuário está autenticado via CHAT_ID

  @smoke
  Cenário: Cadastrar despesa com formato válido
    Quando o usuário envia "/despesa 25,50 Alimentação Supermercado"
    Então o bot cadastra a despesa de R$ 25,50
    E categoria "Alimentação" é vinculada
    E a descrição é "Supermercado"
    E o bot responde com "Despesa de R$ 25,50 cadastrada com sucesso"

  Cenário: Cadastrar despesa sem descrição
    Quando o usuário envia "/despesa 50,00 Transporte"
    Então o bot cadastra a despesa de R$ 50,00
    E categoria "Transporte" é vinculada
    E a descrição fica vazia
    E o bot responde com "Despesa de R$ 50,00 cadastrada com sucesso"

  Cenário: Tentar cadastrar despesa com valor inválido
    Quando o usuário envia "/despesa abc Alimentação"
    Então o bot responde com "Formato inválido. Use: /despesa <valor> <categoria> [descrição]"

  Cenário: Tentar cadastrar despesa com categoria inexistente
    Quando o usuário envia "/despesa 30,00 CategoriaInexistente"
    Então o bot responde com "Categoria 'CategoriaInexistente' não encontrada"
    E o bot mostra a lista de categorias disponíveis

  Cenário: Tentar cadastrar despesa com valor zero
    Quando o usuário envia "/despesa 0,00 Alimentação"
    Então o bot responde com "O valor deve ser maior que zero"

  Cenário: Tentar cadastrar despesa com valor negativo
    Quando o usuário envia "/despesa -10,00 Alimentação"
    Então o bot responde com "O valor deve ser maior que zero"

  @regressao
  Cenário: Ignorar mensagem de chat não autorizado
    Dado que a mensagem vem de um CHAT_ID diferente do configurado
    Quando o usuário envia "/despesa 25,50 Alimentação Supermercado"
    Então o bot não responde
    E nenhuma despesa é cadastrada

  @wip
  Cenário: Cadastrar despesa com valor em formato americano
    Quando o usuário envia "/despesa 25.50 Alimentação Supermercado"
    Então o bot cadastra a despesa de R$ 25,50
    E a descrição é "Supermercado"
