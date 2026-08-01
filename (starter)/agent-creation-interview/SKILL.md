---
name: agent-creation-interview
description: >
  Conduz uma entrevista estruturada e exaustiva, por categorias, antes de
  criar qualquer agente de IA (subagente, persona, system prompt de agente
  especializado): Desenvolvimento, Design (games ou frontend/produto),
  Product Manager, Tech Lead ou QA. Levanta finalidade, contexto,
  especialidade técnica, stack, metodologia, ferramentas, tom e restrições,
  sugere respostas recomendadas, exige aprovação explícita do escopo antes
  de gerar o agente final, e valida tudo com checklist antes de entregar.
  Use sempre que o usuário pedir para "criar um agente", "criar um agente de
  IA", "montar um subagente", "definir a persona de um agente", "criar um
  agente de dev/designer/PM/tech lead/QA", ou pedir um novo assistente
  especializado para o time — mesmo sem usar as palavras "entrevista" ou
  "skill". Acione também para "preciso de um agente para revisar código",
  "quero um agente de QA para automação", "cria um agente de produto",
  "monta um tech lead virtual", "agente especialista em Kotlin/React/Unity".
---

# Entrevista para Criação de Agentes de IA

## Objetivo

Antes de criar qualquer agente de IA, conduzir uma entrevista estruturada e
exaustiva — por blocos, não tudo de uma vez — para levantar tudo que é
necessário para definir o escopo, o conhecimento e o comportamento do agente.
No final, **nenhum agente é gerado sem que o usuário aprove explicitamente o
escopo definido**. O entregável final é um documento de definição de agente
completo (persona + system prompt), validado por um checklist antes da
entrega.

## Quando disparar

Sempre que o usuário pedir a criação de um agente de IA, independente do
papel. Se o papel ainda não estiver claro, ele é a primeira coisa a
descobrir (Etapa 0). Se o pedido já vier com o papel definido (ex.: "cria um
agente de QA para automação de testes"), pule direto para o bloco
fundamental (Etapa 1) e depois para a entrevista específica daquele papel.

## Princípios de condução da entrevista

- **Idioma**: conduza a entrevista no idioma do usuário. O documento final do
  agente também deve ser escrito no mesmo idioma da conversa, a menos que o
  usuário peça outro (é comum pedir que o system prompt fique em inglês —
  pergunte isso no bloco fundamental).
- **Ferramenta de perguntas**: prefira `ask_user_input_v0` para perguntas de
  opções fechadas (especialidade, metodologia, ferramentas mais comuns,
  etc.) — é mais rápido para o usuário responder, principalmente no celular.
  No máximo 3 perguntas por chamada. Sempre que houver uma opção claramente
  mais comum/segura, **marque-a como recomendada** no texto da pergunta ou
  no rótulo (ex.: "Clean Architecture (recomendado para APIs médias/grandes)").
  Reserve perguntas de texto livre para o que exige contexto específico do
  usuário: nome do agente, particularidades do projeto, regras de negócio,
  restrições específicas, exemplos que ele já tenha em mente.
- **Avance por blocos**: nunca faça a entrevista inteira de uma vez. Siga as
  etapas abaixo, uma de cada vez, resumindo o que já foi definido antes de
  passar para a próxima.
- **Infira o que já foi dito**: se o pedido inicial do usuário já responde
  algo (ex.: "quero um agente Kotlin/Spring Boot para backend" já define
  papel, especialidade, linguagem e framework), não pergunte de novo — apenas
  confirme rapidamente e siga para o que falta.
- **Seja exaustivo, mas não redundante**: cada bloco de perguntas nos
  arquivos de referência é propositalmente extenso. Pergunte tudo que for
  relevante para o papel, mas agrupe perguntas correlatas em uma única
  chamada de `ask_user_input_v0` (até 3 por vez) para não cansar o usuário.
- **Gate de aprovação é obrigatório**: depois de reunir todas as respostas
  (Etapa 3), sempre apresente o resumo consolidado do escopo e peça
  aprovação explícita antes de gerar o agente. Se o usuário pedir ajustes,
  volte ao bloco correspondente e repita a consolidação até haver aprovação
  clara ("sim", "aprovado", "pode gerar", etc.).

## Fluxo completo da entrevista

### Etapa 0 — Papel do agente

Se ainda não estiver claro, pergunte qual o papel do agente a ser criado:

```
Pergunta: "Que tipo de agente você quer criar?"
Opções: Desenvolvedor(a) | Designer | Product Manager (PM) | Tech Lead | QA
```

Se o usuário responder algo fora dessas opções (ex.: DevOps/SRE, Dados/ML,
Segurança), trate como "Outro": use o bloco fundamental normalmente e monte
uma mini-entrevista técnica ad hoc inspirada em
`references/perguntas-desenvolvedor.md` (especialidade, stack, ferramentas,
processos, testes), adaptando os termos para a área citada.

### Etapa 1 — Bloco fundamental (comum a todos os papéis)

Independente do papel, sempre levante isto antes de entrar nas perguntas
específicas:

1. **Finalidade** — Para que esse agente vai ser usado no dia a dia? Que
   tipo de tarefa ele deve resolver primeiro quando alguém chamar por ele?
2. **Contexto do projeto/time** — Em que tipo de projeto ele vai atuar
   (produto novo, legado, tamanho do time, maturidade)? Há algum domínio de
   negócio importante para ele conhecer?
3. **Nome e persona** — Como o agente deve se chamar/se apresentar? Tem um
   tom de personalidade desejado (ex.: mentor didático, direto e objetivo,
   sênior cético, animado)?
4. **Tom de comunicação** — Formal, direto, didático/explicativo, conciso,
   informal? Deve explicar o raciocínio ou só entregar o resultado?
5. **Nível de autonomia** — Ele só sugere/opina, pode propor mudanças para
   revisão, ou pode executar e decidir sozinho dentro de regras definidas?
6. **Restrições (o que ele nunca deve fazer)** — Existe algo que o agente
   deve evitar categoricamente (ex.: nunca alterar arquivos de infra, nunca
   aprovar PR sozinho, nunca falar com o cliente final, nunca tomar decisão
   de preço)?
7. **Ferramentas/acessos disponíveis** — Ele terá acesso a quê (terminal,
   repositório de código, banco de dados, APIs externas, ambiente de
   produção, ferramentas de gestão como Jira/Figma)? (Só pergunte se fizer
   sentido para a plataforma onde o agente vai rodar.)
8. **Formato de saída esperado** — Código pronto para PR, texto explicativo,
   documentos formais, diagramas, listas de tarefas, etc.
9. **Idioma do agente** — O agente deve responder no mesmo idioma desta
   conversa, ou em outro (ex.: inglês, para times internacionais)?

Depois desse bloco, siga para a entrevista específica do papel (Etapa 2).

### Etapa 2 — Aprofundamento específico por papel

Cada papel tem um arquivo de referência com o roteiro completo de perguntas,
organizado em blocos temáticos, já com sugestões de opções recomendadas.
Consulte o arquivo correspondente e conduza os blocos na ordem sugerida:

| Papel | Arquivo de referência | Observação |
|---|---|---|
| Desenvolvedor(a) | `references/perguntas-desenvolvedor.md` | Especialidade, linguagens, frameworks, arquitetura, testes, dados, convenções, Git/CI-CD, documentação. |
| Designer | `references/perguntas-designer.md` | Primeiro pergunta se é Games ou Frontend/Produto, depois segue na mesma profundidade do dev (ferramentas, estilo, pipeline, entrega). |
| Product Manager (PM) | `references/perguntas-pm.md` | Contexto do produto, metodologia, cerimônias, quebra de trabalho, critérios de aceite, priorização, ferramentas, métricas. |
| Tech Lead | `references/perguntas-tech-lead.md` | Mesma lógica do dev + escopo de liderança, decisões de arquitetura, padrões do time, mentoria. |
| QA | `references/perguntas-qa.md` | Tipos de teste, ferramentas/frameworks de automação, estratégia de testes, critérios de entrada/saída, gestão de bugs. |

Ao final dessa etapa, você deve ter respostas suficientes para preencher
todas as seções do template em `references/modelo-e-exemplos-agentes.md`.

### Etapa 3 — Resumo do escopo e aprovação (obrigatório)

Antes de gerar qualquer agente, monte um resumo consolidado, organizado nas
mesmas seções do template final (ver Etapa 4), e apresente ao usuário algo
como:

> "Aqui está o escopo consolidado do agente [Nome]. Confere tudo antes de eu
> gerar a versão final?"
>
> [resumo em tópicos, por seção]
>
> "Posso gerar o agente com esse escopo, ou você quer ajustar algo antes?"

**Não gere o arquivo final do agente sem uma confirmação explícita.** Se o
usuário pedir ajustes, volte ao bloco relevante (Etapa 1 ou 2), colete a
mudança e apresente o resumo atualizado de novo até haver aprovação.

### Etapa 4 — Geração do agente final

Com o escopo aprovado, monte o documento final do agente seguindo a
estrutura e os exemplos completos em
`references/modelo-e-exemplos-agentes.md`. Em resumo, o documento tem:

1. Frontmatter (nome, descrição curta, ferramentas/acesso, idioma) —
   compatível com o formato de subagentes de Claude Code, mas utilizável em
   qualquer outra plataforma de agentes (basta adaptar o cabeçalho).
2. Identidade e missão do agente.
3. Contexto de atuação.
4. Áreas de conhecimento / stack / especialidade (a parte que mais varia por
   papel).
5. Responsabilidades e fluxo de trabalho padrão.
6. Padrões, convenções e boas práticas que o agente segue.
7. Regras e restrições (o que ele nunca deve fazer).
8. Formato de saída e estilo de comunicação.
9. 2–3 exemplos curtos de interação (pergunta do usuário → como o agente
   responderia), para calibrar o tom.

Gere o documento como um arquivo `.md` de verdade (use `create_file`, nunca
apenas mostre o texto em bloco de código), salvando em
`/mnt/user-data/outputs/agente-{papel}-{nome-ou-especialidade}.md`, e
apresente com `present_files`. Isso porque este é um entregável reutilizável
— o usuário vai salvar, versionar ou importar esse arquivo em outra
ferramenta (Claude Code, outra plataforma de agentes, etc.).

### Etapa 5 — Checklist de validação final (antes de entregar)

Antes de apresentar o arquivo final, percorra silenciosamente
`references/checklist-validacao.md` e confirme que todos os pontos da
entrevista foram cobertos (bloco fundamental + bloco específico do papel).
Se faltar algo, volte e pergunte antes de finalizar — não gere o agente com
lacunas. Depois de validar, você pode mencionar rapidamente ao usuário que o
escopo foi conferido item a item (não precisa colar o checklist inteiro, a
menos que ele peça para ver).

## Arquivos de referência

- `references/perguntas-desenvolvedor.md` — roteiro completo para agentes de
  desenvolvimento (qualquer especialidade: backend, frontend, mobile,
  fullstack, dados, infra).
- `references/perguntas-designer.md` — roteiro para designers, com
  bifurcação Games vs. Frontend/Produto.
- `references/perguntas-pm.md` — roteiro para Product Managers.
- `references/perguntas-tech-lead.md` — roteiro para Tech Leads (aproveita o
  roteiro de dev + camada de liderança técnica).
- `references/perguntas-qa.md` — roteiro para agentes de QA.
- `references/modelo-e-exemplos-agentes.md` — template de compilação do
  documento final + 3 exemplos completos de agentes bem estruturados
  (Desenvolvedor Backend, QA de Automação, PM Scrum) para usar como
  referência de qualidade e nível de detalhe.
- `references/checklist-validacao.md` — checklist de validação final, com
  itens comuns a todos os papéis e itens específicos por papel.
