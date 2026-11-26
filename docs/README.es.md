# Orbit Rebalancer

<p align="center">
  <img src="https://img.shields.io/badge/Stellar-Reflector%20Protocol-blue" alt="Stellar" />
  <img src="https://img.shields.io/badge/Soroban-Smart%20Contracts-orange" alt="Soroban" />
  <img src="https://img.shields.io/badge/Backend-Node.js%20%2F%20Express%20%2F%20TypeScript-green" alt="Backend" />
  <img src="https://img.shields.io/badge/license-MIT-brightgreen" alt="License" />
</p>

[![GitHub Repo](https://img.shields.io/badge/repo-Orbit%20Rebalancer-blue?style=flat-square)](https://github.com/Ayinkx/orbit-rebalancer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Documentación:** [English](../README.md) · **Español** · [Português](README.pt.md)

**Idiomas de la interfaz:** English · Español · Português · Français · Deutsch

---

## Descripción General

Orbit Rebalancer es una **plataforma inteligente de gestión de carteras DeFi** construida sobre Stellar que rebalancea automáticamente carteras de criptomonedas usando datos de precios en tiempo real de los oráculos Reflector.

Ayuda a los usuarios a mantener una asignación óptima de activos mediante un rebalanceo automatizado activado por umbrales de desviación configurables, aprovechando la infraestructura rápida y de bajo costo de Stellar.

---

## Características

* **Rebalanceo inteligente** – Mantenimiento automático de las asignaciones objetivo según disparadores de umbral.
* **Invariantes y límites de pesos objetivo** – Las asignaciones de la cartera están estrictamente acotadas (1..=10.000 bps por activo) y se verifica que sumen exactamente 100 % (10.000 bps) en unidades enteras; las solicitudes con asignación insuficiente, excesiva o no autorizadas se rechazan de forma atómica, conservando sin cambios los pesos almacenados, los saldos actuales y los fondos del contrato, y emitiendo eventos solo para transiciones de estado confirmadas, lo que permite reconstruir el estado fuera de la cadena sin ambigüedad.
* **Umbrales de desviación acotados** – Los umbrales de la cartera están limitados al 1 %–50 %; un umbral fuera de rango se rechaza de forma atómica, por lo que no se modifica ninguna cartera, saldo ni configuración.
* **Fuente de precios restringida al administrador** – Solo el administrador del contrato puede cambiar la fuente de precios del oráculo o su límite de desviación; un llamador rechazado deja sin cambios el oráculo autorizado, los saldos y el último precio aceptado.
* **Vigencia acotada de las cotizaciones** – Se aceptan cotizaciones del oráculo con hasta 1 hora de antigüedad; una cotización más antigua se considera obsoleta, su activo se omite y el rebalanceo se bloquea con `StaleOraclePrice`.
* **Soporte para múltiples billeteras** – Compatible con Freighter, Rabet, xBull y otras billeteras Stellar.
* **Precios en tiempo real** – Impulsados por oráculos Reflector con respaldos de API.
* **Gestión de riesgos** – Circuit breakers, límites de concentración y detección de volatilidad.
* **Interfaz profesional** – Interfaz responsiva con visualización de la cartera en tiempo real.
* **Contrato de UX del gráfico de desviación de la cartera** – La desviación con signo cero o negativo, la escala del gráfico y una marca de tiempo de referencia permanecen visibles en todos los rangos temporales.
  Una actualización tardía de precios después de cambiar de rango debe ofrecer reintentar o corregir sin acciones duplicadas y sin perder ediciones no relacionadas.
  Los usuarios de teclado y de lectores de pantalla deben disponer de controles con nombre, foco conservado y anuncios de estado.
  Los controles y los detalles del gráfico deben seguir siendo utilizables a 320 px y con texto al 200 % sin recorte horizontal.
* **Modo demo** – Cartera simulada de $10,000 para pruebas.
* **Confianza y transparencia** – La página de inicio resume la arquitectura, los controles de riesgo y la observabilidad; los documentos legales muestran una versión fija y una fecha de vigencia.

---

## Hoja de Ruta del Proyecto

¡Vea hacia dónde se dirige Orbit Rebalancer!

| **Ahora** (Sprint Actual) | **Próximamente** (1-2 meses) | **Más Adelante** (3-6+ meses) |
| :--- | :--- | :--- |
| Algoritmo de rebalanceo principal | Panel de control de cartera | Aplicación móvil |
| Integración del oráculo Reflector | Informes históricos | Estrategias personalizadas |
| Estabilidad de la conexión de billetera | Sistema de notificaciones | Integración DeFi |
| Corrección de errores | Soporte para múltiples activos | Optimización fiscal |

**[Ver hoja de ruta detallada →](ROADMAP.md)**

---

## Arquitectura

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

### Términos Clave

Los nuevos contribuidores deben leer el glosario antes de profundizar en la configuración o en el trabajo con el contrato.

* **Portfolio (Cartera):** El objeto de asignación gestionado por el usuario, rastreado por `portfolio_id`.
* **Target Allocation, Rebalance Threshold y Slippage Tolerance:** Los principales parámetros del contrato para el rebalanceo automatizado.
* **Reflector Oracle:** La fuente de precios que usa el contrato para decidir sobre la desviación y el rebalanceo.
* **Cooldown Period y Emergency Stop:** Controles de seguridad integrados para los rebalanceos.

📘 **Acceso al glosario:** Consulte [docs/GLOSSARY.md](GLOSSARY.md) para el glosario central y los enlaces cruzados a la documentación de contrato, API y despliegue.

### Stack Tecnológico

| Capa | Tecnología |
| :--- | :--- |
| Contratos inteligentes | Rust + Soroban |
| Frontend | React + TypeScript + Tailwind CSS |
| Backend | Node.js + Express + TypeScript |
| Datos de precios | Reflector + CoinGecko API. Consulte [cotizaciones del oráculo del backend](../backend/docs/oracle-quotes.md) para diagnósticos de precisión y respaldo. |

* Rust + Cargo
* Soroban CLI
* Billetera Stellar (se recomienda Freighter o Rabet)

---

## Instalación

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

## Configuración del Entorno

```bash
# Backend
cp backend/.env.example backend/.env

# Frontend
cp frontend/.env.example frontend/.env
```

Edite los archivos `.env` con su propia configuración (direcciones de contratos, claves de API, etc.).

**Referencia del entorno:** La referencia completa del entorno del backend está disponible en [docs/ENVIRONMENT.md](ENVIRONMENT.md).

**Versionado de la API:** El cliente HTTP del frontend apunta a `/api/v1/*` para las rutas de recursos de forma predeterminada (`VITE_API_VERSION=v1` en `frontend/.env.example`). La autenticación JWT sigue usando `/api/auth/*`. Consulte [API.md](API.md) para obtener todos los detalles del versionado.

**Ejemplos de cliente de la API:** Consulte el Ejemplo de Cliente de API en Python (o el archivo de ejemplos correspondiente).

---

## Configuración de la Base de Datos

Las migraciones de PostgreSQL están disponibles para entornos configurados con `DATABASE_URL` o las variables `PGHOST` / `PGDATABASE` / `PGUSER`.

```bash
cd backend
npm run db:migrate                 # Apply migrations
npm run db:migrate -- --dry-run   # Preview migrations
```

**Desarrollo local:** Para el desarrollo local con SQLite, deje las variables de PostgreSQL sin definir y use `DB_PATH` en su lugar. La ruta predeterminada es `backend/data/portfolio.db`. El backend crea el archivo de la base de datos y su directorio padre automáticamente al iniciar. Los clones nuevos no deben incluir archivos `.db`, `.db-wal` o `.db-shm` preconstruidos.

**Siembra de demo:** Los datos de demostración de SQLite solo aparecen cuando la siembra de demo está habilitada mediante `ENABLE_DEMO_DB_SEED` o el Modo Demo. De lo contrario, la base de datos local comienza vacía y se inicializa a partir del esquema y las fuentes de semillas versionadas en el repositorio.

---

## Notificaciones por Correo Electrónico (Opcional)

Ejemplo de configuración con Gmail:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
SMTP_FROM=your-email@gmail.com
```

También se admiten otros proveedores, como SendGrid, Mailgun y AWS SES.

Prueba de notificaciones:

```bash
curl -X POST http://localhost:3001/api/v1/notifications/subscribe \
  -H "Content-Type: application/json" \
  -d '{"userId": "YOUR_STELLAR_ADDRESS", "eventType": "rebalance"}'
```

---

## Desarrollo

Inicie los servidores de desarrollo locales:

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

**URL local del frontend:** http://localhost:3000

---

## Despliegue del Contrato Inteligente

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

**Ejemplo de dirección de contrato:** `CCQ4LISQJFTZJKQDRJHRLXQ2UML45GVXUECN5NGSQKAT55JKAK2JAX7I`

---

## Verificación del Hash WASM

Antes de desplegar, puede calcular y auditar el hash SHA-256 canónico del contrato WASM compilado para garantizar la reproducibilidad y la seguridad:

```bash
cd contracts
make hash
```

Este target genera el hash tanto del WASM de release como del WASM optimizado (si está disponible). El mismo cálculo de hash se ejecuta automáticamente en las compilaciones de release y de PR para simplificar las auditorías de despliegue.

---

## Recursos para Desarrolladores

* Referencia de la interfaz del contrato (funciones, errores, notas de tipos): [contracts/CONTRACT_ABI.md](../contracts/CONTRACT_ABI.md)
* Comandos y ejemplos comunes de invocación de Soroban: [docs/soroban-cookbook.md](soroban-cookbook.md)
* Matriz de compatibilidad y capacidades del frontend (mapeo de degradación): [docs/CONTRACT_CAPABILITY_MATRIX.md](CONTRACT_CAPABILITY_MATRIX.md)

---

## Uso

📸 ¿Es nuevo en la plataforma? Consulte nuestro [Recorrido Visual de la Demo](DEMO_WALKTHROUGH.md) con capturas de pantalla paso a paso y explicaciones detalladas.

### Flujo de Inicio Rápido

1. Conecte su billetera Stellar.
2. Cree una cartera y establezca las asignaciones objetivo (la suma debe ser igual al 100 %, con un máximo de 10 activos por cartera).
3. Configure los umbrales de rebalanceo (1–50 %).

**Detección de volatilidad:** Pausa el rebalanceo durante condiciones extremas de mercado.

**Límites de concentración:** Evita la sobreasignación a un único activo.

**Circuit breakers:** Múltiples verificaciones de seguridad antes de ejecutar operaciones.

---

## Notificaciones

Notificaciones por correo electrónico y webhook para los eventos de rebalanceo.

Tipos de evento: rebalanceo, circuit breaker, movimiento de precios, cambios de riesgo.

Configurable por usuario.

---

## Referencia de la API

**Canónico:** `/api/v1/*`

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

## Integración con Stellar DEX

Operaciones reales ejecutadas en la testnet de Stellar usando `@stellar/stellar-sdk`.

Ejecución con conciencia de slippage, ejecuciones parciales y manejo automatizado de rollback.

El historial de rebalanceos registra los resultados y las métricas explícitas de slippage.

---

## Pruebas

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

## Despliegue con Docker

```bash
docker compose -f deployment/docker-compose.yml config
docker compose -f deployment/docker-compose.yml build frontend backend
docker compose -f deployment/docker-compose.yml up --build -d
```

---

## Contribuir

Consulte [CONTRIBUTING.md](../CONTRIBUTING.md) para la guía canónica del contribuidor. Incluye la configuración local mínima, los servicios opcionales (Redis, PostgreSQL, SMTP), los comandos de prueba, la generación de la documentación de la API, las expectativas de los queue workers y la configuración de pruebas E2E del frontend.

**Requisito de PR:** Los Pull Requests deben vincularse explícitamente a una issue abierta, o proporcionar una justificación detallada cuando no exista una issue. Una comprobación de CI a nivel de bloque aplica esta regla estrictamente.

**Pasos rápidos para contribuir:**

1. Haga un fork del repositorio.
2. Cree una rama de funcionalidad: `git checkout -b feature/awesome-feature`.
3. Siga las instrucciones de configuración en [docs/CONTRIBUTING.md](CONTRIBUTING.md).
4. Asegúrese de que todas las pruebas locales pasen: `cd backend && npm test && cd ../frontend && npm test`.
5. Abra un Pull Request bien documentado.

---

## Solución de Problemas

### Problemas con la Billetera

¿Tiene problemas para conectar su billetera Stellar? Consulte las [Preguntas Frecuentes de Solución de Problemas de Billeteras](WALLET_TROUBLESHOOTING.md) para obtener soluciones paso a paso de:

* Errores de "Wallet is not installed"
* Tiempos de espera y rechazos de conexión
* Fallos en la firma de transacciones
* Discrepancia de red entre la billetera y la aplicación
* Peculiaridades específicas de cada billetera (Freighter, Rabet, xBull)

### Comportamiento con la Billetera Desconectada

¿Se pregunta qué ocurre si configura una cartera y nunca vuelve a conectarse? Consulte [Comportamiento con la Billetera Desconectada](DISCONNECTED_WALLET_BEHAVIOR.md) para obtener una explicación completa de cómo funciona la autorización del rebalanceo y cómo delegar la autoridad de firma a otra dirección.

### Problemas Comunes de Configuración

Consulte [CONTRIBUTING.md](../CONTRIBUTING.md) §10 "Common setup failures" para problemas de backend, base de datos y entorno.

---

## Licencia

Este proyecto está licenciado bajo la Licencia MIT.

## Agradecimientos

* Stellar Development Foundation
* Reflector Protocol
* Soroban
* Integraciones de billeteras de la comunidad

Construido con ❤️ para el ecosistema Stellar
