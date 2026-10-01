# CozyUni — Economy Ledger Schema v1.0

Status: IMPLEMENTATION SPEC

## Objective

Prepare commerce backend so Apple purchases are secure and auditable.

## Wallet model

A player wallet is not a mutable number. It is calculated from ledger events.

```text
Wallet Balance = grants + purchases - spends - refunds
```

## Ledger event types

### Purchase

```json
{
 "type":"iap_purchase",
 "product_id":"com.cozyuni.credits.550",
 "store_transaction_id":"apple_tx_id",
 "credits":550
}
```

### Spend

```json
{
 "type":"cosmetic_spend",
 "catalog_id":"outfit.rabbit.autumn",
 "credits":250
}
```

### Refund

```json
{
 "type":"iap_refund",
 "original_transaction_id":"apple_tx_id",
 "credits_reverted":550
}
```

## Required protections

- transaction id idempotency
- server timestamp
- immutable history
- no client-authoritative balance
- refund reconciliation
- entitlement validation

## Analytics events

Required:
- store_open
- product_view
- purchase_started
- purchase_success
- purchase_failed
- cosmetic_view
- cosmetic_purchase_success
- insufficient_balance

## Future account migration

Anonymous player identity must be designed before online accounts are added.
Purchases must be recoverable according to Apple rules.
