#language: pt
Funcionalidade: Dashboard de Resumo Mensal
  Como usuário do sistema de finanças
  Quero visualizar um resumo das minhas finanças no mês
  Para entender para onde meu dinheiro está indo

  Contexto:
    Dado que o usuário está autenticado
    E que está no dia "15/06/2026"

  @smoke
  Cenário: Visualizar resumo com dados no mês corrente
    Dado que existem despesas categorizadas no mês de junho
    Quando o usuário acessa o dashboard
    Então o total de despesas do mês é exibido
    E o gráfico de despesas por categoria é exibido
    E as 3 categorias com maior gasto são listadas

  Cenário: Visualizar resumo sem dados no mês corrente
    Dado que não existem despesas no mês de junho
    Quando o usuário acessa o dashboard
    Então uma mensagem "Nenhum dado encontrado para este período" é exibida
    E o gráfico não é exibido

  Cenário: Filtrar dashboard por período diferente
    Dado que existem despesas nos meses de maio e junho
    Quando o usuário seleciona o período "Maio/2026"
    Então o resumo mostra apenas despesas de maio
    E o total é recalculado para maio

  Cenário: Comparar gastos entre meses
    Dado que existem despesas nos meses de maio e junho
    Quando o usuário acessa a aba "Comparativo"
    Então os totais de maio e junho são exibidos lado a lado
    E a variação percentual entre os meses é exibida

  Cenário: Dashboard considera apenas despesas confirmadas
    Dado que existem despesas pendentes no mês de junho
    E que existem despesas confirmadas no mês de junho
    Quando o usuário acessa o dashboard
    Então apenas despesas confirmadas são consideradas no total

  @regressao
  Cenário: Dashboard atualiza automaticamente após cadastrar despesa
    Dado que o usuário está no dashboard
    Quando ele cadastra uma nova despesa
    Então o total de despesas é atualizado
    E o gráfico é atualizado
