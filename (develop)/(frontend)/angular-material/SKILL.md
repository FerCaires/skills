---
name: angular-material
description: Desenvolvimento frontend com Angular 18+ standalone components e Angular Material. Use quando implementar páginas, componentes, serviços, modelos ou rotas no frontend. Também use ao configurar Nginx, Dockerfile do frontend, ou fazer build de produção. Antes de escrever qualquer código, carregue a skill tdd-ptbr e siga o ciclo Red-Green-Refactor.
---

# Angular 18+ Material — ControleEstoqueLashDesigner

## Quick Start

```bash
ng serve --host 0.0.0.0 --port 4200     # dev server com hot reload
ng build --configuration production       # build para /dist (servido pelo Nginx)
ng generate component pages/nova --standalone
ng generate service services/novo
```

## Stack & Versões

- Angular 18+ com **standalone components** (sem NgModules)
- Angular Material (toolbar, sidenav, table, form-field, input, select, button, dialog, snackbar)
- TypeScript estrito
- ReactiveFormsModule para formulários
- HttpClient para chamadas à API

## Estrutura de diretórios

```
frontend/src/app/
├── services/          # api.service.ts, produto.service.ts, etc.
├── models/            # Interfaces TS (Produto, Usuario, Venda, RelatorioMensal)
├── pages/
│   ├── produtos/
│   ├── usuarios/
│   ├── vendas/
│   └── relatorio/
├── app.component.ts   # Layout: MatToolbar + MatSidenav + <router-outlet>
├── app.routes.ts      # Rotas definidas no SDD.md seção 9
└── app.config.ts      # provideHttpClient, provideRouter, provideAnimations
```

## Padrões de código

### Models (interfaces)

Espelham os schemas Pydantic do backend. Exemplo:

```typescript
export interface Produto {
  nome: string;
  preco: number;
  quantidade: number;
}

export interface VendaCreate {
  nome_produto: string;
  nome_usuario: string;
  data_compra: string;    // 'YYYY-MM-DD'
  quantidade_comprada: number;
  // NUNCA incluir preco_pago — backend calcula
}
```

### Services

```typescript
@Injectable({ providedIn: 'root' })
export class ProdutoService {
  private apiUrl = '/api/produtos';

  constructor(private http: HttpClient) {}

  listar(): Observable<Produto[]> {
    return this.http.get<Produto[]>(this.apiUrl);
  }

  criar(produto: ProdutoCreate): Observable<Produto> {
    return this.http.post<Produto>(this.apiUrl, produto);
  }
}
```

### Pages (standalone components)

```typescript
@Component({
  selector: 'app-produtos',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatTableModule, MatButtonModule, MatFormFieldModule, MatInputModule, MatDialogModule],
  templateUrl: './produtos.component.html',
  styleUrls: ['./produtos.component.css']
})
export class ProdutosPage implements OnInit {
  dataSource = new MatTableDataSource<Produto>([]);
  displayedColumns = ['nome', 'preco', 'quantidade', 'acoes'];

  constructor(private produtoService: ProdutoService) {}

  ngOnInit(): void {
    this.carregarProdutos();
  }
}
```

## Rotas

Definidas em `app.routes.ts`:

```typescript
export const routes: Routes = [
  { path: '', redirectTo: '/produtos', pathMatch: 'full' },
  { path: 'produtos', component: ProdutosPage },
  { path: 'usuarios', component: UsuariosPage },
  { path: 'vendas', component: VendasPage },
  { path: 'relatorio', component: RelatorioPage },
];
```

## Nginx

`/api` é proxy para `backend:8000`. Configuração mínima:

```nginx
location /api/ {
    proxy_pass http://backend:8000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

## Dockerfile multi-stage

1. Stage `build`: node:20-alpine, `npm ci`, `ng build`
2. Stage `runtime`: nginx:alpine, copia `dist/` para `/usr/share/nginx/html/` e `nginx.conf` para `/etc/nginx/conf.d/default.conf`

## Convenções do projeto

- Todo texto visível ao usuário em **português brasileiro**.
- Campos monetários usam o pipe `currency:'BRL'` ou formatação equivalente.
- Formulário de venda **nunca** expõe campo `preco_pago`.
- Usar `MatSnackBar` para feedback de sucesso/erro.
- Usar `MatDialog` para confirmação de exclusão.
- Tabelas usam `MatTableDataSource` com `MatPaginator` e `MatSort` quando necessário.

## Testes e TDD

### Localização

```
frontend/src/app/
├── services/
│   ├── api.service.ts
│   └── api.service.spec.ts        # Teste unitário do service
├── pages/
│   └── produtos/
│       ├── produtos.component.ts
│       ├── produtos.component.spec.ts  # Teste unitário do componente
│       └── produtos.component.html
```

### Ciclo TDD (obrigatório)

1. **Red:** escreva o teste que falha
2. **Green:** escreva o código mínimo que faz o teste passar
3. **Refactor:** melhore o código mantendo os testes verdes

### Padrões de teste

**Teste de componente (unitário):**
```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ProdutosPage } from './produtos.component';
import { ProdutoService } from '../../services/produto.service';
import { of } from 'rxjs';

describe('ProdutosPage', () => {
  let component: ProdutosPage;
  let fixture: ComponentFixture<ProdutosPage>;
  const mockService = { listar: of([]) };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ProdutosPage],
      providers: [{ provide: ProdutoService, useValue: mockService }]
    }).compileComponents();

    fixture = TestBed.createComponent(ProdutosPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('deve criar o componente', () => {
    expect(component).toBeTruthy();
  });
});
```

**Teste de service (unitário):**
```typescript
import { TestBed } from '@angular/core/testing';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { provideHttpClient } from '@angular/common/http';
import { ProdutoService } from './produto.service';

describe('ProdutoService', () => {
  let service: ProdutoService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ProdutoService, provideHttpClient(), provideHttpClientTesting()]
    });
    service = TestBed.inject(ProdutoService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  it('deve listar produtos', () => {
    service.listar().subscribe(produtos => {
      expect(produtos.length).toBe(0);
    });
    const req = httpMock.expectOne('/api/produtos');
    expect(req.request.method).toBe('GET');
    req.flush([]);
  });
});
```

### Comandos

```bash
# Rodar todos os testes
docker compose exec frontend npm test -- --watch=false --browsers=ChromeHeadless

# Rodar com cobertura
docker compose exec frontend npm test -- --watch=false --browsers=ChromeHeadless --code-coverage
```

### Convenções de teste

- Todo `component.ts` deve ter `component.spec.ts` correspondente
- Todo `service.ts` deve ter `service.spec.ts` correspondente
- Mockar services do backend em testes de componente (`HttpClient`)
- Usar `TestBed` para configuração de módulos de teste
- Verificar se componentes são criados (`toBeTruthy()`)
- Verificar chamadas de service (`expect(spy).toHaveBeenCalled()`)
- Dados de teste em português brasileiro
