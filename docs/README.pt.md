# Orbit Rebalancer

<p align="center">
  <img src="https://img.shields.io/badge/Stellar-Reflector%20Protocol-blue" alt="Stellar" />
  <img src="https://img.shields.io/badge/Soroban-Smart%20Contracts-orange" alt="Soroban" />
  <img src="https://img.shields.io/badge/Backend-Node.js%20%2F%20Express%20%2F%20TypeScript-green" alt="Backend" />
  <img src="https://img.shields.io/badge/license-MIT-brightgreen" alt="License" />
</p>

[![GitHub Repo](https://img.shields.io/badge/repo-Orbit%20Rebalancer-blue?style=flat-square)](https://github.com/Ayinkx/orbit-rebalancer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Documentação:** [English](../README.md) · [Español](README.es.md) · **Português**

**Idiomas da interface:** English · Español · Português · Français · Deutsch

---

## Visão Geral

Orbit Rebalancer é uma **plataforma inteligente de gestão de portfólios DeFi** construída na Stellar que rebalanceia automaticamente portfólios de criptomoedas usando dados de preço em tempo real dos oráculos Reflector.

Ela ajuda os usuários a manter uma alocação ideal de ativos por meio de rebalanceamento automatizado acionado por limites de deriva configuráveis, aproveitando a infraestrutura rápida e de baixo custo da Stellar.

---

## Funcionalidades

* **Rebalanceamento inteligente** – Manutenção automática das alocações alvo com base em gatilhos de limite.
* **Invariantes e limites de pesos alvo** – As alocações do portfólio são estritamente limitadas (1..=10.000 bps por ativo) e é verificado que somam exatamente 100% (10.000 bps) em unidades inteiras; envios com alocação insuficiente, excessiva ou não autorizados são rejeitados atomicamente, preservando sem alterações os pesos armazenados, os saldos atuais e os fundos do contrato, e emitindo eventos apenas para transições de estado confirmadas, o que permite reconstruir o estado fora da cadeia sem ambiguidade.
* **Limites de deriva delimitados** – Os limites do portfólio são restritos a 1%–50%; um limite fora do intervalo é rejeitado atomicamente, de modo que nenhum portfólio, saldo ou configuração é alterado.
* **Fonte de preço restrita ao administrador** – Apenas o administrador do contrato pode alterar a fonte de preço do oráculo ou seu limite de desvio; um chamador rejeitado deixa inalterados o oráculo autorizado, os saldos e o último preço aceito.
* **Validade delimitada das cotações** – Cotações do oráculo são aceitas com até 1 hora de idade; uma cotação mais antiga é considerada obsoleta, seu ativo é ignorado e o rebalanceamento é bloqueado com `StaleOraclePrice`.
* **Suporte a múltiplas carteiras** – Compatível com Freighter, Rabet, xBull e outras carteiras Stellar.
* **Preços em tempo real** – Alimentados por oráculos Reflector com fallbacks de API.
* **Gestão de risco** – Circuit breakers, limites de concentração e detecção de volatilidade.
* **Interface profissional** – Interface responsiva com visualização do portfólio em tempo real.
* **Contrato de UX do gráfico de deriva do portfólio** – A deriva com sinal zero ou negativa, a escala do gráfico e um carimbo de data e hora de referência permanecem visíveis em todos os intervalos de tempo.
  Uma atualização tardia de preço após a troca de intervalo deve oferecer nova tentativa ou correção sem ações duplicadas e sem perder edições não relacionadas.
  Usuários de teclado e de leitores de tela devem ter controles nomeados, foco mantido e anúncios de estado.
  Os controles e os detalhes do gráfico devem permanecer operáveis em 320 px e com texto a 200% sem corte horizontal.
* **Modo demo** – Portfólio simulado de $10.000 para testes.
* **Confiança e transparência** – A landing page resume a arquitetura, os controles de risco e a observabilidade; os documentos legais mostram uma versão fixa e uma data de vigência.

---

## Roteiro do Projeto

Veja para onde o Orbit Rebalancer está caminhando!

| **Agora** (Sprint Atual) | **A seguir** (1-2 meses) | **Mais adiante** (3-6+ meses) |
| :--- | :--- | :--- |
| Algoritmo de rebalanceamento principal | Painel de portfólio | Aplicativo móvel |
| Integração com o oráculo Reflector | Relatórios históricos | Estratégias personalizadas |
| Estabilidade da conexão de carteira | Sistema de notificações | Integração DeFi |
| Correção de bugs | Suporte a múltiplos ativos | Otimização fiscal |

**[Ver roteiro detalhado →](ROADMAP.md)**

---

## Arquitetura

```text
orbit-rebalancer/
├── contracts/     # Soroban smart contracts
├── frontend/      # React + TypeScript frontend
├── backend/       # Node.js + Express API
├── deployment/    # Docker deployment files
├── scripts/       # Test, validation, and observability tooling
├── security/      # SBOM and npm audit baseline
├── terraform/     # AWS infrastructure (RDS, SNS, budgets)
└── docs/          # Documentation (including ADRs)
```

### Termos Fundamentais

Novos contribuidores devem ler o glossário antes de se aprofundar na configuração ou no trabalho com o contrato.

* **Portfolio (Portfólio):** O objeto de alocação gerenciado pelo usuário, rastreado por `portfolio_id`.
* **Target Allocation, Rebalance Threshold e Slippage Tolerance:** Os principais parâmetros do contrato para o rebalanceamento automatizado.
* **Reflector Oracle:** A fonte de preços usada pelo contrato para decisões de deriva e rebalanceamento.
* **Cooldown Period e Emergency Stop:** Controles de segurança integrados para os rebalanceamentos.

📘 **Acesso ao glossário:** Veja [docs/GLOSSARY.md](GLOSSARY.md) para o glossário central e links cruzados para a documentação de contrato, API e implantação.

### Stack Tecnológica

| Camada | Tecnologia |
| :--- | :--- |
| Contratos inteligentes | Rust + Soroban |
| Frontend | React + TypeScript + Tailwind CSS |
| Backend | Node.js + Express + TypeScript |
| Dados de preço | Reflector + CoinGecko API. Veja [cotações do oráculo do backend](../backend/docs/oracle-quotes.md) para diagnósticos de precisão e fallback. |

* Rust + Cargo
* Soroban CLI
* Carteira Stellar (Freighter ou Rabet recomendada)

---

## Instalação

```bash
# Clone the repository
git clone https://github.com/Ayinkx/orbit-rebalancer.git
cd orbit-rebalancer

# Frontend Setup
cd frontend
npm install

# Backend Setup
cd ../backend
npm install

# Smart Contracts Setup
cd ../contracts
cargo build
```

---

## Configuração de Ambiente

```bash
# Backend
cp backend/.env.example backend/.env

# Frontend
cp frontend/.env.example frontend/.env
```

Edite os arquivos `.env` com sua própria configuração (endereços de contratos, chaves de API, etc.).

**Referência de ambiente:** A referência completa de ambiente do backend pode ser encontrada em [docs/ENVIRONMENT.md](ENVIRONMENT.md).

**Versionamento da API:** O cliente HTTP do frontend aponta para `/api/v1/*` nas rotas de recursos por padrão (`VITE_API_VERSION=v1` em `frontend/.env.example`). A autenticação JWT ainda usa `/api/auth/*`. Veja [API.md](API.md) para detalhes completos de versionamento.

**Exemplos de cliente da API:** Confira o Exemplo de Cliente da API em Python (ou o arquivo de exemplos correspondente).

---

## Configuração do Banco de Dados

Migrações do PostgreSQL estão disponíveis para ambientes configurados com `DATABASE_URL` ou as variáveis `PGHOST` / `PGDATABASE` / `PGUSER`.

```bash
cd backend
npm run db:migrate                 # Apply migrations
npm run db:migrate -- --dry-run   # Preview migrations
```

**Desenvolvimento local:** Para desenvolvimento local com SQLite, deixe as variáveis do PostgreSQL sem definir e use `DB_PATH` em vez disso. O caminho padrão é `backend/data/portfolio.db`. O backend cria o arquivo do banco de dados e seu diretório pai automaticamente na inicialização. Clones novos não devem incluir arquivos `.db`, `.db-wal` ou `.db-shm` pré-construídos.

**Seed de demo:** Os dados de demonstração do SQLite aparecem apenas quando o seed de demo está habilitado via `ENABLE_DEMO_DB_SEED` ou pelo Modo Demo. Caso contrário, o banco de dados local inicia vazio e é inicializado a partir do esquema e das fontes de seed versionadas no repositório.

---

## Notificações por E-mail (Opcional)

Exemplo de configuração com Gmail:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
SMTP_FROM=your-email@gmail.com
```

Outros provedores suportados incluem SendGrid, Mailgun e AWS SES.

Testar notificações:

```bash
curl -X POST http://localhost:3001/api/v1/notifications/subscribe \
  -H "Content-Type: application/json" \
  -d '{"userId": "YOUR_STELLAR_ADDRESS", "eventType": "rebalance"}'
```

---

## Desenvolvimento

Inicie seus servidores de desenvolvimento local:

**Terminal 1 - Backend:**

```bash
cd backend
npm run dev
```

**Terminal 2 - Frontend:**

```bash
cd frontend
npm run dev
```

**URL local do frontend:** http://localhost:3000

---

## Implantação do Contrato Inteligente

```bash
cd contracts

# Build contract
soroban contract build

# Deploy to testnet
soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/portfolio_rebalancer.wasm \
  --source deployer \
  --network testnet

# Initialize contract
soroban contract invoke \
  --id YOUR_CONTRACT_ID \
  --source deployer \
  --network testnet \
  -- initialize \
  --admin YOUR_ADMIN_ADDRESS \
  --reflector_address CDSWUUXGPWDZG76ISK6SUCVPZJMD5YUV66J2FXFXFGDX25XKZJIEITAO
```

**Exemplo de endereço de contrato:** `CCQ4LISQJFTZJKQDRJHRLXQ2UML45GVXUECN5NGSQKAT55JKAK2JAX7I`

---

## Verificação do Hash WASM

Antes de implantar, você pode calcular e auditar o hash SHA-256 canônico do contrato WASM compilado para garantir reprodutibilidade e segurança:

```bash
cd contracts
make hash
```

Esse target gera o hash tanto do WASM de release quanto do WASM otimizado (se disponível). O mesmo cálculo de hash roda automaticamente nas builds de release e de PR para simplificar as auditorias de implantação.

---

## Recursos para Desenvolvedores

* Referência da interface do contrato (funções, erros, notas de tipos): [contracts/CONTRACT_ABI.md](../contracts/CONTRACT_ABI.md)
* Comandos e exemplos comuns de invocação do Soroban: [docs/soroban-cookbook.md](soroban-cookbook.md)
* Matriz de compatibilidade e capacidade do frontend (mapeamento de degradação): [docs/CONTRACT_CAPABILITY_MATRIX.md](CONTRACT_CAPABILITY_MATRIX.md)

---

## Uso

📸 Novo na plataforma? Confira nosso [Tour Visual da Demo](DEMO_WALKTHROUGH.md) com capturas de tela passo a passo e explicações detalhadas.

### Fluxo de Início Rápido

1. Conecte sua carteira Stellar.
2. Crie um portfólio e defina as alocações alvo (a soma deve ser igual a 100%, com no máximo 10 ativos por portfólio).
3. Configure os limites de rebalanceamento (1–50%).

**Detecção de volatilidade:** Pausa o rebalanceamento durante condições extremas de mercado.

**Limites de concentração:** Evita a superalocação em ativos individuais.

**Circuit breakers:** Múltiplas verificações de segurança antes de executar operações.

---

## Notificações

Notificações por e-mail e webhook para eventos de rebalanceamento.

Tipos de evento: rebalanceamento, circuit breaker, movimento de preço, mudanças de risco.

Configurável por usuário.

---

## Referência da API

**Canônico:** `/api/v1/*`

**Legado (obsoleto):** `/api/*`

```bash
# Create portfolio
POST /api/v1/portfolio
Content-Type: application/json
{
  "userAddress": "STELLAR_ADDRESS",
  "allocations": {"XLM": 40, "USDC": 35, "BTC": 25},
  "threshold": 5
}

# Get portfolio
GET /api/v1/portfolio/:id

# Execute rebalance
POST /api/v1/portfolio/:id/rebalance

# Dry-run rebalance (read-only plan, no DB writes or contract call)
POST /api/v1/portfolio/:id/rebalance/dry-run

# Rebalance status
GET /api/v1/portfolio/:id/rebalance-status

# Subscribe to notifications
POST /api/v1/notifications/subscribe

# Get preferences
GET /api/v1/notifications/preferences?userId=STELLAR_ADDRESS

# Unsubscribe from notifications
DELETE /api/v1/notifications/unsubscribe?userId=STELLAR_ADDRESS

# Price Data Feeds
GET /api/v1/prices
GET /api/v1/portfolio/:id/rebalance-plan
```

---

## Integração com a Stellar DEX

Operações reais executadas na testnet da Stellar usando `@stellar/stellar-sdk`.

Execução com consciência de slippage, preenchimentos parciais e tratamento automatizado de rollback.

O histórico de rebalanceamento rastreia resultados e métricas explícitas de slippage.

---

## Testes

```bash
# Full suite (backend + frontend + contracts)
npm test

# Frontend tests
cd frontend && npm test

# Backend tests
cd backend && npm test

# Smart contract tests (unit + property suites, incl. threshold-bounds, oracle-authorization, stale-quote, and target-weight event/regression suites)
cd contracts && cargo test --features testutils

# Smart contract gas benchmarks
cd contracts && make bench
```

---

## Implantação com Docker

```bash
docker compose -f deployment/docker-compose.yml config
docker compose -f deployment/docker-compose.yml build frontend backend
docker compose -f deployment/docker-compose.yml up --build -d
```

---

## Contribuindo

Veja [CONTRIBUTING.md](../CONTRIBUTING.md) para o guia canônico do contribuidor. Ele inclui a configuração local mínima, os serviços opcionais (Redis, PostgreSQL, SMTP), os comandos de teste, a geração da documentação da API, as expectativas dos queue workers e a configuração de testes E2E do frontend.

**Requisito de PR:** Pull Requests devem ser vinculados explicitamente a uma issue aberta, ou fornecer uma justificativa detalhada quando nenhuma issue existir. Uma verificação de CI em nível de bloco aplica essa regra estritamente.

**Passos rápidos para contribuir:**

1. Faça um fork do repositório.
2. Crie uma branch de funcionalidade: `git checkout -b feature/awesome-feature`.
3. Siga as instruções de configuração em [docs/CONTRIBUTING.md](CONTRIBUTING.md).
4. Garanta que todos os testes locais passem: `cd backend && npm test && cd ../frontend && npm test`.
5. Abra um Pull Request bem documentado.

---

## Solução de Problemas

### Problemas com a Carteira

Está tendo problemas para conectar sua carteira Stellar? Veja o [FAQ de Solução de Problemas de Carteira](WALLET_TROUBLESHOOTING.md) para correções passo a passo de:

* Erros de "Wallet is not installed"
* Timeouts de conexão e recusas
* Falhas na assinatura de transações
* Incompatibilidade de rede entre a carteira e o aplicativo
* Peculiaridades específicas de carteiras (Freighter, Rabet, xBull)

### Comportamento com a Carteira Desconectada

Está se perguntando o que acontece se você configurar um portfólio e nunca reconectar? Veja [Comportamento com a Carteira Desconectada](DISCONNECTED_WALLET_BEHAVIOR.md) para uma explicação completa de como funciona a autorização do rebalanceamento e como delegar a autoridade de assinatura a outro endereço.

### Problemas Comuns de Configuração

Veja [CONTRIBUTING.md](../CONTRIBUTING.md) §10 "Common setup failures" para problemas de backend, banco de dados e ambiente.

---

## Licença

Este projeto está licenciado sob a Licença MIT.

## Agradecimentos

* Stellar Development Foundation
* Reflector Protocol
* Soroban
* Integrações de carteiras da comunidade

Built with ❤️ for the Stellar ecosystem
