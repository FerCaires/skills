# Roteiro de Entrevista — Agente de QA

Use este roteiro depois do bloco fundamental (Etapa 1 do SKILL.md).

## 1. Tipos de teste que o agente domina

- Selecione todos que se aplicam (multi-select): Funcional/manual |
  Regressão | Exploratório | Automatizado (UI/E2E) ⭐ | API/Contrato ⭐ |
  Performance/carga | Segurança (básico) | Acessibilidade | Mobile
- Qual o foco principal do agente (o que ele deve priorizar quando houver
  conflito de tempo): automação de regressão, testes exploratórios antes de
  release, ou cobertura ampla de API?

## 2. Ferramentas e frameworks de automação

- Ferramentas de automação de UI/E2E: Playwright ⭐ | Cypress | Selenium |
  Appium (mobile)
- Ferramentas de API: Postman/Newman ⭐ | Insomnia | REST Assured
- Ferramentas de performance/carga: k6 ⭐ | JMeter | Gatling
- BDD/Gherkin: usa Cucumber/SpecFlow/Behave para descrever cenários em
  linguagem natural, ou escreve os testes direto em código?
- Ferramenta de gestão de casos de teste: TestRail | Zephyr | Xray | Planilha
  simples | Nenhuma formal ainda

## 3. Linguagem de automação

- Linguagem principal para escrever os testes automatizados: JavaScript/
  TypeScript ⭐ | Java | Python | C#
- Isso deve seguir a mesma linguagem do time de dev, ou é independente?

## 4. Estratégia de testes

- Modelo mental que o agente deve seguir: Pirâmide de testes clássica
  (muitos unitários, menos E2E) ⭐ | Testing Trophy (foco em integração) |
  Quadrantes de Agile Testing
- Nível de automação-alvo: parcial/foco nos fluxos críticos ⭐ | cobertura
  ampla e contínua | ainda majoritariamente manual, migrando aos poucos

## 5. Critérios de entrada/saída e "pronto para produção"

- Existe uma Definition of Done de QA? O que ela cobre hoje (ex.: todos os
  cenários críticos passando, sem bug crítico aberto, cobertura mínima)?
- Critério de entrada em teste (Definition of Ready para QA): a
  funcionalidade precisa vir com critérios de aceite claros antes de o
  agente testar?

## 6. Gestão de bugs

- Ferramenta de reporte: Jira ⭐ | Bugzilla | Linear | GitHub Issues
- Nível de detalhe esperado no reporte: passos para reproduzir + evidência
  (print/vídeo/log) ⭐ como padrão mínimo, ou algo mais simples/mais robusto?
- Classificação de severidade/prioridade que o time usa (ex.:
  Blocker/Critical/Major/Minor).

## 7. Integração com CI/CD

- Os testes automatizados rodam como gate obrigatório no pipeline (bloqueia
  merge/deploy se falhar) ⭐, ou rodam à parte só como sinal informativo?
- O agente deve manter/expandir essa suíte de CI como parte da rotina?

## 8. Métricas de qualidade

- Métricas acompanhadas: cobertura de testes, taxa de bugs escapados para
  produção ⭐, tempo médio de execução da suíte, taxa de flakiness
- O agente deve reportar essas métricas periodicamente, ou só quando
  perguntado?

---

Depois de percorrer os 8 blocos, volte para a Etapa 3 do SKILL.md (resumo e
aprovação do escopo).
