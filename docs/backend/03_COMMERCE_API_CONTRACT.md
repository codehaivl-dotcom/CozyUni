# CozyUni — Commerce API Contract v1.0

Status: **LOCKED API BEHAVIOR**

Base path: `/v1/commerce`

All examples omit transport headers for brevity.

---

## 1. Shared response envelope

Success:

```json
{
  "ok": true,
  "request_id": "uuid",
  "data": {}
}
```

Error:

```json
{
  "ok": false,
  "request_id": "uuid",
  "error": {
    "code": "INSUFFICIENT_CC",
    "message": "Not enough Cozy Credits."
  }
}
```

Player-facing clients branch on `error.code`, not free-text message.

---

## 2. Authentication headers

Authenticated endpoints:

```text
Authorization: Bearer <opaque access token>
```

Mutating idempotent client endpoints additionally use:

```text
Idempotency-Key: <UUID>
```

If the same account + key is reused with a different request body, return HTTP `409` + `IDEMPOTENCY_CONFLICT`.

---

## 3. POST `/auth/apple`

Purpose: create/resolve Commerce Account using Sign in with Apple and issue server session.

Request:

```json
{
  "identity_token": "apple_identity_jwt"
}
```

Server validates signature, issuer, audience, expiry, and nonce if the client flow uses one.

Response:

```json
{
  "ok": true,
  "request_id": "...",
  "data": {
    "account_id": "uuid",
    "app_account_token": "uuid",
    "access_token": "opaque",
    "access_expires_in_seconds": 900,
    "refresh_token": "opaque",
    "refresh_expires_in_seconds": 2592000
  }
}
```

Do not return provider subject/email/name.

---

## 4. POST `/auth/refresh`

Request:

```json
{
  "refresh_token": "opaque"
}
```

Behavior:
- validate hashed token;
- reject expired/revoked;
- rotate refresh token;
- revoke old token atomically;
- issue new access + refresh token pair.

Response same token fields as `/auth/apple`, excluding account creation semantics.

---

## 5. POST `/auth/logout`

Authenticated.

Revokes current session/refresh chain.

Response: `204 No Content` or standard empty success envelope. Implementation must choose one once and test it; v1 recommended response is HTTP `204`.

---

## 6. GET `/wallet`

Authenticated.

Response:

```json
{
  "ok": true,
  "request_id": "...",
  "data": {
    "currency": "CC",
    "spendable_cc": 470,
    "purchased_cc": 400,
    "bonus_cc": 70,
    "refund_debt_cc": 0,
    "revision": 18
  }
}
```

If debt exists:
- `spendable_cc` MUST be `0` until debt cleared;
- purchased/bonus may also be `0` because incoming grants first repay debt.

---

## 7. GET `/catalog`

Authentication optional.

Query params:
- `game_id` optional
- `type` optional

Response item:

```json
{
  "id": "dice.autumn_01",
  "type": "dice_skin",
  "price_cc": 150,
  "active": true,
  "display_key": "catalog.dice.autumn_01.name",
  "preview_asset_id": "...",
  "game_ids": ["cozy_ludo", "cozy_journey", "cozy_tycoon"]
}
```

Catalog response uses server price only.

Signed-out response does not include ownership.
Authenticated response may include `owned: true/false`.

---

## 8. GET `/entitlements`

Authenticated.

Response:

```json
{
  "ok": true,
  "request_id": "...",
  "data": {
    "items": [
      {
        "catalog_id": "dice.autumn_01",
        "acquired_at": "2026-10-01T20:00:00Z"
      }
    ]
  }
}
```

Revoked entitlements are excluded from ordinary client list.

---

## 9. POST `/apple/transactions/claim`

Authenticated.
Idempotency is primarily Apple `transaction_id`; optional `Idempotency-Key` still accepted for request tracing.

Request:

```json
{
  "signed_transaction_jws": "eyJ..."
}
```

Success new delivery:

```json
{
  "ok": true,
  "request_id": "...",
  "data": {
    "status": "delivered",
    "transaction_id": "2000000123456789",
    "product_id": "com.cozyuni.credits.550",
    "granted_cc": 550,
    "debt_repaid_cc": 0,
    "new_spendable_cc": 550,
    "wallet_revision": 9
  }
}
```

Duplicate previously delivered transaction:

```json
{
  "status": "already_delivered",
  "transaction_id": "...",
  "granted_cc": 0,
  "new_spendable_cc": 550,
  "wallet_revision": 9
}
```

Do not issue an error for an exact valid duplicate. It is a successful idempotent retry.

Reject account mismatch with HTTP `409` + `APPLE_TRANSACTION_ACCOUNT_MISMATCH`.

---

## 10. POST `/catalog/purchases`

Authenticated.
Requires `Idempotency-Key` UUID.

Request:

```json
{
  "catalog_id": "dice.autumn_01"
}
```

Success:

```json
{
  "ok": true,
  "request_id": "...",
  "data": {
    "status": "purchased",
    "purchase_id": "uuid",
    "catalog_id": "dice.autumn_01",
    "charged_cc": 150,
    "new_spendable_cc": 400,
    "wallet_revision": 10
  }
}
```

Already owned non-stackable item:
- HTTP `200`
- status `already_owned`
- `charged_cc = 0`

Insufficient balance:
- HTTP `409`
- `INSUFFICIENT_CC`

Refund debt:
- HTTP `409`
- `REFUND_DEBT_ACTIVE`

---

## 11. POST `/apple/notifications`

No client authentication.
Apple server-to-server only.

Request body shape follows App Store Server Notifications V2:

```json
{
  "signedPayload": "eyJ..."
}
```

Rules:
- verify signed payload before trusting fields;
- persist notification UUID;
- return HTTP `200` only after durable acceptance/processing decision;
- duplicate notification UUID returns `200`;
- invalid signature returns `400`;
- temporary database/dependency failure returns `5xx` so Apple may retry.

No JSON business payload required on success.

---

## 12. GET `/health/live`

No auth.

Checks process only.
Returns `200` if process event loop/API is alive.
Does not query PostgreSQL or Apple.

---

## 13. GET `/health/ready`

No auth, but deployment/network may restrict exposure.

Checks:
- PostgreSQL connection;
- migrations at expected schema version;
- economy config loaded;
- critical secret presence (without exposing values).

Apple API reachability is not required for every ready probe; transient Apple outage must not cause deployment restart loops.

---

## 14. Admin API namespace

Admin HTTP endpoints, if implemented, live under:

`/v1/admin/commerce/...`

They are not exposed through the normal player auth middleware.

Exact admin actions are defined in `04_ADMIN_COMMERCE_TOOL_SPEC.md`.

---

## 15. Rate limits

Minimum production policy per account/IP combination:

- `/auth/apple`: 10/minute
- `/auth/refresh`: 30/minute
- transaction claim: 20/minute/account
- catalog purchase: 30/minute/account
- catalog/wallet reads: 120/minute/account

Admin endpoints use stricter identity-based controls and audit logging.

Rate-limit failures return HTTP `429`.

---

## 16. Request IDs

Every request gets a server-generated UUID request ID.

If client sends `X-Request-ID` as a valid UUID, server may preserve it; otherwise generate one.

Return request ID in:
- response body where body exists;
- response header `X-Request-ID`.

---

## 17. Versioning rule

Breaking request/response changes require `/v2/commerce` or an explicitly versioned media contract.

Adding an optional response field is non-breaking.
Removing/renaming stable error codes is breaking.

---

## 18. Client retry matrix

| Operation | Safe automatic retry? | Key |
|---|---|---|
| auth refresh | yes, once | refresh token rotation-aware |
| wallet/catalog GET | yes | none |
| Apple transaction claim | yes | Apple transaction ID |
| catalog purchase | yes | Idempotency-Key |
| logout | yes | session |

Client must never retry a failed StoreKit purchase by initiating a second StoreKit purchase automatically. It retries server delivery of the already-created transaction instead.
