#language: pt
Funcionalidade: Alerta de Orçamento
  Como usuário do sistema de finanças
  Quero ser alertado quando meus gastos se aproximarem do limite do orçamento
  Para controlar melhor meus gastos mensais

  Contexto:
    Dado que o usuário está autenticado
    E que existe o orçamento "Alimentação" com limite de R$ 1.000,00 para o mês atual

  @smoke
  Cenário: Disparar alerta ao ultrapassar 90% do orçamento
    Dado que o total gasto em "Alimentação" é de R$ 850,00
    Quando o usuário cadastra uma despesa de R$ 60,00 em "Alimentação"
    Então o total gasto em "Alimentação" é de R$ 910,00
    E uma notificação é enviada via Telegram
    E a mensagem contém "Orçamento de Alimentação em 91%"

  Cenário: Não disparar alerta quando gasto está abaixo de 90%
    Dado que o total gasto em "Alimentação" é de R$ 800,00
    Quando o usuário cadastra uma despesa de R$ 50,00 em "Alimentação"
    Então o total gasto em "Alimentação" é de R$ 850,00
    E nenhuma notificação é enviada

  Cenário: Disparar alerta apenas uma vez por mês/categoria
    Dado que o alerta de 90% para "Alimentação" já foi disparado neste mês
    E que o total gasto em "Alimentação" é de R$ 910,00
    Quando o usuário cadastra uma despesa de R$ 50,00 em "Alimentação"
    Então o total gasto em "Alimentação" é de R$ 960,00
    E nenhuma notificação adicional é enviada

  Cenário: Alerta dispara novamente se percentual cair e subir
    Dado que o alerta de 90% para "Alimentação" já foi disparado neste mês
    E que uma despesa de R$ 100,00 em "Alimentação" foi excluída
    E que o total gasto em "Alimentação" caiu para R$ 860,00
    Quando o usuário cadastra uma despesa de R$ 60,00 em "Alimentação"
    Então o total gasto em "Alimentação" é de R$ 920,00
    E uma nova notificação é enviada via Telegram

  Cenário: Alerta considera apenas despesas do mês corrente
    Dado que existem despesas de R$ 500,00 em "Alimentação" no mês anterior
    E que o total gasto em "Alimentação" no mês atual é de R$ 800,00
    Quando o usuário cadastra uma despesa de R$ 60,00 em "Alimentação"
    Então o total gasto em "Alimentação" é de R$ 860,00
    E nenhuma notificação é enviada

  @regressao
  Cenário: Disparar alerta ao exatamente 90%
    Dado que o total gasto em "Alimentação" é de R$ 899,00
    Quando o usuário cadastra uma despesa de R$ 1,00 em "Alimentação"
    Então o total gasto em "Alimentação" é de R$ 900,00
    E uma notificação é enviada via Telegram
    E a mensagem contém "Orçamento de Alimentação em 90%"
