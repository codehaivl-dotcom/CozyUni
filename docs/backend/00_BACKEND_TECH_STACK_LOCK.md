# CozyUni — Commerce Backend Tech Stack Lock v1.0

Status: **LOCKED FOR COMMERCE V1**

Purpose: remove backend implementation ambiguity for the first real-money commerce milestone. This lock applies only to commerce/wallet/IAP services. It does not choose the future multiplayer/game server stack.

## 1. Runtime

Use exactly:

- Node.js **22 LTS**
- TypeScript with `strict: true`
- Fastify **5.x** for HTTP API
- PostgreSQL **16+** as the only persistent database
- `pg` for PostgreSQL access
- Apple official package `@apple/app-store-server-library` for App Store Server API / JWS verification / Server Notifications

Do not replace the Apple library with an unofficial .NET/Unity package or hand-written JWS verifier unless this lock is explicitly revised.

## 2. Architecture shape

Commerce v1 is deliberately small:

```text
iOS/iPadOS app
    |
    | HTTPS JSON
    v
Commerce API (Node/TypeScript/Fastify)
    |
    +--> PostgreSQL
    |
    +--> Apple App Store Server API
    |
    <--- App Store Server Notifications V2
```

No Redis, Kafka, RabbitMQ, Elasticsearch, microservice mesh, Kubernetes requirement, or distributed cache in v1.

Background/retry work uses PostgreSQL-backed jobs/outbox rows processed by the same codebase in a worker process role.

## 3. Database rule

- SQL schema/migrations are authoritative under `backend/migrations/`.
- No ORM owns the schema.
- Do not auto-create/auto-mutate production tables from runtime models.
- All ledger/wallet mutations use explicit SQL transactions.
- `READ COMMITTED` is acceptable for ordinary reads.
- Wallet spending/refund mutation must row-lock the wallet projection/account as specified in the database design.

## 4. Authentication model

Core local games remain playable without login.

Real-money commerce requires a **Commerce Account**.

For iOS/iPadOS v1, Commerce Account authentication uses **Sign in with Apple** only.

Rules:
- browsing the store is allowed without sign-in;
- starting a real-money purchase requires a Commerce Account;
- if no Commerce Account exists, show the purchase-protection/sign-in step before StoreKit purchase begins;
- cancelling sign-in cancels the purchase flow cleanly;
- do not require email, profile photo, real name, phone number, or precise location;
- store only the stable provider subject as a one-way hash plus the internal account IDs;
- one active Commerce Account per app install in v1;
- account switching UI is out of scope for v1.

## 5. Session tokens

Do not use self-contained client-authoritative wallet tokens.

Use opaque random bearer tokens:

- access token: 256-bit random; TTL **15 minutes**;
- refresh token: 256-bit random; TTL **30 days**;
- store only SHA-256 token hashes in PostgreSQL;
- rotate refresh token on every successful refresh;
- revoke the old refresh token in the same transaction;
- Keychain stores the refresh token on Apple platforms;
- logout revokes current session tokens.

## 6. Apple transaction association

Each Commerce Account owns one random UUID `app_account_token`.

Every StoreKit purchase MUST pass that UUID using StoreKit purchase option `appAccountToken`.

The same UUID must later appear in verified App Store transaction data. Backend rejects a client claim when the verified transaction's app account token does not match the authenticated Commerce Account.

## 7. Secrets

Secrets never enter Git:

- App Store Connect In-App Purchase private key `.p8`
- issuer ID
- key ID
- Sign in with Apple private key if used by the deployment
- database password
- admin secrets

Runtime reads secrets from the deployment secret manager/environment.

Repository may contain only environment-variable names and local development examples with dummy values.

## 8. Environments

Exactly three logical environments:

- `local`
- `sandbox`
- `production`

Apple sandbox transactions must never grant production wallet credits.
Production transactions must never be accepted by sandbox data stores.

Recommended deployment separation: distinct database per environment.

## 9. API conventions

- prefix: `/v1/commerce`
- JSON request/response bodies
- UTF-8
- `application/json`
- every mutating client request supports a UUID idempotency key where the API contract specifies one;
- timestamps are UTC ISO-8601 externally, `timestamptz` internally;
- money from Apple is never represented as binary floating point in authoritative records;
- Cozy Credits are integer `BIGINT` values.

## 10. Logging

Structured JSON logs only in hosted environments.

Required fields where available:
- timestamp
- level
- request_id
- route
- account_id
- transaction_id
- notification_uuid
- error_code
- latency_ms

Never log:
- raw access/refresh tokens
- Apple identity tokens
- App Store private keys
- database passwords

Raw signed Apple JWS may be stored in the dedicated audit table, but should not be copied into ordinary application logs.

## 11. Dependency policy

- package-lock must be committed once backend code exists;
- automatic major dependency upgrades are forbidden;
- Apple App Store Server Library major upgrades require commerce regression tests;
- production uses the exact dependency versions in lockfile.

## 12. Explicit non-goals

Do not add during commerce v1:
- multi-device gameplay networking
- chat
- friends
- public profiles
- social graph
- subscriptions
- web checkout
- Android billing
- ad SDK
- blockchain/crypto
- cash-out/trading of Cozy Credits

## 13. Source documents

Behavior authority:
1. `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
2. `docs/backend/01_COMMERCE_BACKEND_DESIGN.md`
3. `docs/backend/03_COMMERCE_API_CONTRACT.md`
4. `docs/backend/02_COMMERCE_DATABASE_SCHEMA.md`
5. `backend/migrations/001_commerce_v1.sql`
6. this tech-stack lock for implementation technology

If implementation behavior is not defined, stop and raise a design question. Do not invent it.
