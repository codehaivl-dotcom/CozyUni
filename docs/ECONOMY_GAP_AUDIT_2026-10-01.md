# CozyUni — Economy / Data / Monetization Gap Audit — 2026-10-01

Status: **AUDIT CLOSED BY NEW LOCKS WHERE NOTED**

## Executive conclusion

Gameplay GDDs are much more complete than the product economy layer. Before this audit, CozyUni had a monetization direction document but no implementable wallet, product IDs, credit grant rules, refund behavior, ledger schema, machine-readable economy data, or simulation tool.

The new source documents close those gaps without changing the five board-game rules.

## Gap register

| Gap | Prior state | Resolution |
|---|---|---|
| Global premium currency | undefined | `Cozy Credits (CC)` locked |
| Number of global currencies | undefined | exactly one spendable global currency in v1 |
| Relationship to Tycoon Coins | implicit only | hard separation locked |
| Apple IAP products | absent | four consumable product IDs locked |
| Runtime price handling | absent | StoreKit localized price required |
| Currency expiration | absent | purchased CC never expires |
| Competitive pay-to-win boundary | general prose | explicit forbidden effects list |
| Wallet ownership on shared device | undefined | one commerce profile / guest local slots |
| Reinstall/device-loss handling | absent | server-backed commerce identity required before paid CC ships |
| Transaction idempotency | absent | Apple transaction ID unique grant lock |
| Refund behavior | absent | explicit adjustment rules |
| Store price bands | absent | 80/150/250/400/650/900 CC |
| Machine-readable economy constants | absent | `docs/data/economy_v1.json` |
| Revenue scenario model | absent | `tools/sim_economy.py` |
| Telemetry funnel | absent | locked event/metric list |
| Gameplay simulation gates | partial prose only | Ludo/Journey/Tycoon simulation requirements defined |
| Kids Category purchase gate | absent | parental gate requirement noted |

## Important remaining engineering gaps

These are intentionally not invented in this audit and still require implementation design:
- commerce backend technology/provider/runtime hosting
- authentication/keychain token format
- database choice and migrations
- exact App Store Server API implementation
- StoreKit client language/package integration
- analytics provider, if any
- tax/accounting/bookkeeping outside App Store Connect reports
- privacy policy final legal text

## Build order recommendation

1. Keep all purchase feature flags OFF.
2. Implement the five-game product core.
3. Implement machine-readable economy config and commerce interfaces.
4. Build StoreKit test configuration + fake/local wallet adapter.
5. Build server-backed wallet ledger.
6. Run StoreKit Test automated cases.
7. Run Sandbox/TestFlight end-to-end purchase tests.
8. Enable Store catalog only after retention/repeat-play data supports it.

## Do not confuse design readiness with monetization pressure

The system is being specified now so agents do not improvise later. This does not require putting purchase prompts in front of players before the product is fun.
