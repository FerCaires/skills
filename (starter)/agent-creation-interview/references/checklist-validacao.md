# Checklist de Validação Final

Percorra este checklist silenciosamente antes de apresentar o documento
final do agente (Etapa 5 do SKILL.md). Se qualquer item obrigatório estiver
sem resposta, volte e pergunte antes de finalizar — não gere o agente com
lacunas.

## Bloco fundamental (todos os papéis)

- [ ] Finalidade do agente está clara e específica (não genérica)
- [ ] Contexto do projeto/time foi levantado
- [ ] Nome e persona (se relevante) foram definidos
- [ ] Tom de comunicação foi definido
- [ ] Nível de autonomia foi definido
- [ ] Restrições ("nunca fazer") foram levantadas — pelo menos 1 item
- [ ] Ferramentas/acessos do agente foram definidos (ou explicitamente
      marcados como "não aplicável")
- [ ] Formato de saída esperado foi definido
- [ ] Idioma de resposta do agente foi definido

## Desenvolvedor(a) / Tech Lead

- [ ] Especialidade técnica definida (backend/frontend/mobile/etc.)
- [ ] Linguagem(ns) principal(is) definida(s)
- [ ] Framework(s) principal(is) definido(s)
- [ ] Estilo arquitetural definido
- [ ] Estratégia de testes (tipos + frameworks) definida
- [ ] Convenções de código/estilo levantadas (ou assumidas como padrão da
      linguagem, se o usuário não tiver preferência)
- [ ] Estratégia de Git/CI-CD definida
- [ ] (Tech Lead) Escopo de liderança e decisões de arquitetura definidos
- [ ] (Tech Lead) Abordagem de gestão de dívida técnica definida

## Designer

- [ ] Ramo definido: Games ou Frontend/Produto
- [ ] Especialidade dentro do ramo definida
- [ ] Ferramenta(s) principal(is) definida(s)
- [ ] Estilo visual/artístico definido
- [ ] (Frontend/Produto) Sistema de design e acessibilidade abordados
- [ ] (Frontend/Produto) Processo de handoff para dev definido
- [ ] (Games) Engine e requisitos técnicos de asset definidos
- [ ] (Games) Pipeline de criação de asset definido

## Product Manager

- [ ] Contexto de produto/domínio de negócio levantado
- [ ] Metodologia de trabalho definida
- [ ] Cerimônias que o agente participa definidas
- [ ] Modelo de quebra de trabalho (épico → feature → história) definido
- [ ] Formato de critério de aceite / Definition of Done definido
- [ ] Framework de priorização definido
- [ ] Ferramenta de gestão definida
- [ ] Métricas acompanhadas definidas

## QA

- [ ] Tipos de teste que o agente cobre definidos
- [ ] Ferramentas/frameworks de automação definidos
- [ ] Linguagem de automação definida
- [ ] Estratégia de testes (pirâmide/trophy/quadrantes) definida
- [ ] Critérios de entrada/saída ("pronto para produção") definidos
- [ ] Processo de gestão de bugs definido
- [ ] Integração com CI/CD definida

## Antes de entregar

- [ ] O resumo consolidado do escopo foi apresentado ao usuário
- [ ] O usuário aprovou explicitamente o escopo (ou pediu ajustes já
      incorporados e reaprovados)
- [ ] O documento final segue a estrutura do template
      (`references/modelo-e-exemplos-agentes.md`)
- [ ] O documento foi salvo como arquivo real (`.md`) em
      `/mnt/user-data/outputs/` e apresentado com `present_files`
