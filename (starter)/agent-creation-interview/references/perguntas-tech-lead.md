# Roteiro de Entrevista — Agente de Tech Lead

O Tech Lead compartilha toda a base técnica do Desenvolvedor, mas com uma
camada adicional de liderança, arquitetura e padronização de time. Conduza
assim:

1. Rode os blocos 1 a 9 de `references/perguntas-desenvolvedor.md`
   normalmente (especialidade, linguagens, frameworks, arquitetura, testes,
   dados, convenções, Git/CI-CD, documentação) — a profundidade técnica
   exigida de um Tech Lead é igual ou maior que a de um Dev sênior.
2. Complemente com o bloco de liderança técnica abaixo.

## Bloco adicional — Liderança técnica

### 1. Escopo de liderança
- Lidera quantas pessoas/squads (aproximadamente)? Isso muda o quanto o
  agente deve pensar em escala de processo vs. execução individual.
- É responsável por mentoria formal (1:1s técnicos, plano de
  desenvolvimento de devs) ou só suporte técnico pontual?

### 2. Decisões de arquitetura
- O agente deve documentar decisões via ADR (Architecture Decision Record)
  ⭐, RFC interno, ou decisão informal registrada em ata?
- Nível de autonomia para decidir arquitetura sozinho vs. precisa de
  aprovação de um comitê/outro Tech Lead/CTO?

### 3. Padrões técnicos do time
- O agente define e faz cumprir padrões técnicos (linters, gates de CI,
  convenções de arquitetura) para todo o time, ou só para o próprio
  código?
- Nível de rigor em code review: bloqueante para violação de padrão ⭐ |
  apenas sugestivo | depende da gravidade

### 4. Gestão de dívida técnica
- Como prioriza dívida técnica frente a features novas: reserva um
  percentual fixo de capacidade por sprint (ex.: 20%) ⭐ | decide caso a
  caso | só ataca quando vira bloqueio
- Deve manter um backlog de dívida técnica visível para o PM/negócio?

### 5. Estratégia de testes do time
- Preconiza a pirâmide de testes clássica (muitos unitários, poucos E2E)
  ⭐, ou outra abordagem (ex.: testing trophy, mais foco em integração)?
- Define cobertura mínima obrigatória para novo código entrar em produção?

### 6. Ponte entre negócio e engenharia
- Participa de refinamento com o PM traduzindo requisitos de negócio em
  decisões técnicas? Com que nível de profundidade técnica ele deve
  comunicar para stakeholders não-técnicos?

### 7. Onboarding e mentoria
- Deve gerar/manter documentação de onboarding técnico para novos devs no
  time?
- Nível de proatividade em apontar oportunidades de aprendizado para
  devs juniores durante revisões.

---

Depois de completar os blocos técnicos + o bloco de liderança, volte para a
Etapa 3 do SKILL.md (resumo e aprovação do escopo).
