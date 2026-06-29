---
name: tdd-ptbr
description: 'Obriga o ciclo TDD (Red-Green-Refactor) em toda task de desenvolvimento. Teste primeiro, implementação depois. Use quando iniciar qualquer implementação de feature, correção de bug, refatoração ou escrita de código novo. Também dispare quando o usuário disser "implementar", "criar", "corrigir", "escrever código", "desenvolver", "codar", ou iniciar qualquer task de desenvolvimento. Toda task que produz código DEVE passar por este ciclo. Nenhum código é escrito sem teste que falhe antes.'
---

# TDD — Desenvolvimento Guiado por Testes

## Regra de Ouro

**Nenhuma linha de código de produção é escrita antes do teste que a valida.**

O ciclo é imutável:

```
[ RED ] → [ GREEN ] → [ REFACTOR ] → (repete)
  │           │            │
  │           │            └── melhora código mantendo testes verdes
  │           └── implementa o mínimo para passar
  └── escreve teste que FALHA
```

## Quick Start

Para qualquer task de desenvolvimento:

```bash
# 1. Leia spec.md → extraia critérios de aceite
# 2. Escreva o teste (deve FALHAR)
python3 -m pytest tests/path/test_nova_funcionalidade.py -v
# Resultado esperado: 1 FAILED

# 3. Implemente o código mínimo para passar
# 4. Execute o teste (deve PASSAR)
python3 -m pytest tests/path/test_nova_funcionalidade.py -v
# Resultado esperado: {N} PASSED

# 5. Refatore se necessário (mantendo testes verdes)
# 6. Atualize docs/tasks.md
```

---

## Fluxo Obrigatório — Ciclo RED-GREEN-REFACTOR

### Etapa 1 — RED (Escrever teste que falha)

**Antes de escrever qualquer código de produção:**

1. Leia os critérios de aceite no `spec.md` da feature
2. Identifique qual camada está implementando (repositório, serviço, handler, componente)
3. Crie o arquivo de teste no diretório correto:
   - Backend: `services/{service}/tests/unit/test_{modulo}.py`
   - Frontend: `src/app/{layer}/*.spec.ts`
   - BDD: `tests/features/{feature}/*.feature` + `test_*.py`

4. Escreva ao menos:
   - **1 teste de Happy Path** (caminho feliz)
   - **1 teste de Unhappy Path** (erro esperado)
   - **1 teste de edge case** (limite, vazio, nulo)

5. Execute o teste e **confirme que ele FALHA**:
   ```bash
   # Backend
   cd services/{service} && python3 -m pytest tests/unit/test_{modulo}.py -v
   
   # Frontend
   cd frontend && npx ng test --watch=false --browsers=ChromeHeadless
   ```

   ⚠️ Se o teste passar sem implementação, ele não está testando nada. Reescreva.

### Etapa 2 — GREEN (Implementar o mínimo)

1. Escreva **apenas o código necessário** para fazer o teste passar
2. Não adicione funcionalidades não testadas
3. Não refatore ainda — faça o teste passar primeiro
4. Execute o teste e **confirme que ele PASSA**:
   ```bash
   python3 -m pytest tests/unit/test_{modulo}.py -v
   # Resultado esperado: {N} PASSED
   ```

### Etapa 3 — REFACTOR (Melhorar sem quebrar)

1. Remova duplicação
2. Melhore nomes de variáveis e funções
3. Extraia constantes e funções auxiliares
4. Execute **todos os testes** para garantir que nada quebrou:
   ```bash
   cd services/{service} && python3 -m pytest tests/ -v
   ```
5. Se algo quebrar, desfaça a refatoração e faça em passos menores

---

## Convenções por Linguagem

### Python (Backend — FastAPI + DynamoDB)

**Estrutura de teste:**
```python
# services/api/tests/unit/test_modulo.py
import pytest
from decimal import Decimal

class TestNomeDaFuncionalidade:
    def test_happy_path(self):
        """Cenário: fluxo principal de sucesso."""
        # Arrange (dados de entrada)
        # Act (executa a função/método)
        # Assert (verifica resultado)
        assert resultado == esperado

    def test_unhappy_path(self):
        """Cenário: erro esperado."""
        with pytest.raises(MinhaExcecao):
            funcao_que_deve_falhar(dado_invalido)

    def test_edge_case(self):
        """Cenário: limite ou condição especial."""
        resultado = funcao(Decimal("0"))
        assert resultado is not None
```

**Fixtures e mocks:**
```python
from unittest.mock import patch, MagicMock

def test_com_mock(mocker):
    mock_repo = mocker.patch("modulo.MeuRepository")
    mock_repo.return_value.listar.return_value = [...]

def test_com_fixture(tables):
    repo = MeuRepository()
    repo.criar(dado)
    assert repo.obter(id) is not None
```

### TypeScript (Frontend — Angular 18+)

**Estrutura de teste:**
```typescript
describe('MeuComponent', () => {
  let component: MeuComponent;
  let fixture: ComponentFixture<MeuComponent>;
  let serviceSpy: jasmine.SpyObj<MeuService>;

  beforeEach(async () => {
    serviceSpy = jasmine.createSpyObj('MeuService', ['metodo1', 'metodo2']);
    serviceSpy.metodo1.and.returnValue(of(mockData));

    await TestBed.configureTestingModule({
      imports: [MeuComponent, NoopAnimationsModule],
      providers: [{ provide: MeuService, useValue: serviceSpy }],
    }).compileComponents();

    fixture = TestBed.createComponent(MeuComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('deve carregar dados ao iniciar (Happy Path)', () => {
    expect(serviceSpy.metodo1).toHaveBeenCalled();
    expect(component.dados()).toEqual(mockData);
  });

  it('deve exibir mensagem de erro quando API falhar (Unhappy Path)', () => {
    serviceSpy.metodo1.and.returnValue(throwError(() => new Error('Falha')));
    // re-renderiza para capturar estado de erro
  });

  it('deve desabilitar botão com formulário inválido (Edge Case)', () => {
    component.form.setValue({ campo: '' });
    const button = fixture.debugElement.query(By.css('button[type=submit]'));
    expect(button.nativeElement.disabled).toBeTrue();
  });
});
```

---

## Checklist por Task de Desenvolvimento

Antes de marcar qualquer task como concluída em `docs/tasks.md`, verifique:

- [ ] **RED** — Testes escritos e confirmados como FALHOS antes da implementação
- [ ] **GREEN** — Testes passando após implementação mínima
- [ ] **REFACTOR** — Código limpo, sem duplicação, nomes claros
- [ ] **3 cenários mínimos** — Happy Path + Unhappy Path + Edge Case
- [ ] **Sem regressão** — Todos os testes existentes continuam passando (`pytest tests/ -v`)
- [ ] **Cobertura** — Novas linhas de código estão cobertas por pelo menos 1 teste
- [ ] **Build** — Frontend compila sem erros (`ng build --configuration production`)

---

## Integração com Outras Skills

Esta skill **sempre precede** qualquer skill de implementação:

| Ordem | Skill | Quando |
|-------|-------|--------|
| 1 | `intake-ptbr` | Captura da demanda |
| 2 | `pm-ptbr` | Spec e critérios de aceite |
| 3 | **`tdd-ptbr`** ← esta skill | **Antes de escrever código** |
| 4 | `fastapi` / `angular-material` / etc. | Implementação seguindo TDD |

O agente de desenvolvimento (`fastapi`, `angular-material`, `telegram-bot`, etc.) deve:
1. Carregar `tdd-ptbr` ao iniciar a implementação
2. Escrever o teste primeiro (RED)
3. Implementar o código (GREEN)
4. Validar antes de marcar a task concluída

---

## Anti-Padrões (NUNCA faça)

| Anti-Padrão | Por que é errado |
|-------------|-----------------|
| Escrever código e depois o teste | Inverte o ciclo. O teste pode ser escrito para passar com o código, não para validar o requisito |
| Teste que sempre passa (assert True) | Não valida nada. O teste DEVE falhar antes da implementação |
| Pular edge cases "porque é óbvio" | Bugs vivem nos edge cases. Sempre teste limites |
| Mockar a própria função que está testando | Testa o mock, não o código real |
| Commitar com teste quebrado | Pipeline vai falhar. Só commite com todos os testes verdes |
| Marcar task concluída sem rodar `pytest tests/` | Pode ter quebrado outro módulo. Sempre rode a suite completa |
