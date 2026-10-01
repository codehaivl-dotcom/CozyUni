# CozyUni — Canon & Content Governance v0.4

Status: **CURRENT**

## 1. Purpose

Prevent implementation drift while CozyUni is developed as a game-first product with a future larger world.

## 2. Authority hierarchy

For current board-game implementation:
1. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
2. selected full game GDD in `docs/games/`
3. matching machine-readable file in `docs/data/games/`
4. `docs/GAME_MODE_ROADMAP.md`
5. product/architecture/world documents
6. old code/comments/prototypes

For global economy / commerce behavior:
1. `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
2. `docs/backend/01_COMMERCE_BACKEND_DESIGN.md`
3. `docs/backend/03_COMMERCE_API_CONTRACT.md`
4. `docs/backend/02_COMMERCE_DATABASE_SCHEMA.md`
5. `docs/data/economy_v1.json`
6. `docs/data/commerce_backend_v1.json`
7. `docs/MONETIZATION_AND_APPSTORE.md`
8. architecture/product docs

Implementation technology for commerce is locked separately by `docs/backend/00_BACKEND_TECH_STACK_LOCK.md`.

Higher source wins on behavioral meaning.

For exact numeric/config values already represented in machine-readable data, Markdown and JSON are required to agree. If they disagree, stop and fix the documentation/data defect; do not silently choose one.

If locked docs are silent, implementation agents must raise a design question rather than inventing production behavior.

## 3. Canon levels

### LOCKED GAME DESIGN
Cannot change without explicit GDD + matching data update when relevant:
- game rules/constants
- supported player counts/modes
- Start Game flow
- tutorials
- HUD action hierarchy
- match end/ranking/tiebreakers
- disconnect/forfeit behavior
- explicit out-of-scope features

### LOCKED GLOBAL ECONOMY
Cannot change without economy lock/data/backend update:
- premium currency identity and count
- IAP product IDs / CC grants
- paid-vs-match currency separation
- allowed/forbidden purchase effects
- catalog CC price bands
- wallet/ledger behavior
- refund/idempotency behavior
- Commerce Account purchase requirement
- backend session/rate-limit/admin constants

### LOCKED SHARED IDENTITY
- resident names/species/core visual identity
- stable global asset IDs
- current approved art direction

### SHARED DEFAULT
Reusable presentation conventions that a game may override only when its GDD says so:
- avatar presentation
- common UI/audio language
- generic result/rematch components

### GAME-LOCAL
Defined only by selected game GDD + matching data:
- board state
- score/economy
- movement
- game-specific temporary data

### FUTURE WORLD CANON
The persistent world is deferred. No implementation agent should promote a board-game assumption into future world canon without a separate world GDD decision.

## 4. Machine-readable data rule

`docs/data/README.md` defines the data split.

Current validated game data:
- `docs/data/games/ludo_v1.json`
- `docs/data/games/caro_v1.json`
- `docs/data/games/journey_v1.json`
- `docs/data/games/chess_v1.json`
- `docs/data/games/tycoon_v1.json`

Current economy/backend data:
- `docs/data/economy_v1.json`
- `docs/data/commerce_backend_v1.json`
- `docs/data/game_simulation_config_v1.json`

Before merge:

```bash
python tools/validate_game_data.py
python tools/validate_commerce_data.py
```

Validators do not replace gameplay tests; they prevent structural/config drift.

## 5. World status

Existing shops, buildings, transport, nature, food, infrastructure and leisure assets remain valuable, but they do not require a full life-sim implementation now.

Current visual/world MVP documents may define scene composition and asset generation, but they do not silently define persistent world economy/progression.

When full world development resumes, its target is a real living Animal-Crossing-like life-sim layer. A decorative launcher/hub is not considered completion of that vision.

## 6. Character rule

Approved CozyUni residents should remain recognizable across games.

Avatar choice is identity/presentation unless the game GDD explicitly uses the character as a physical piece.

## 7. Economy rule

Cozy Credits (`CC`) are the one locked global spendable premium currency.

Match-local values never become CC and never become another global spendable currency.

Examples:
- Tycoon Coins exist only inside a Tycoon match.
- Tycoon Community Stars exist only inside a Tycoon match.
- Ludo progress is not persistent XP or money.
- game wins/stats do not mint CC.
- match results cannot be converted to CC unless the economy lock is explicitly revised.

Agents must not add Gems, Energy, Tickets, Hearts, or another spendable global currency.

## 8. Commerce/account boundary

Core board games do not require login.

Real-money commerce uses a separate Commerce Account:
- Sign in with Apple on iOS/iPadOS v1;
- server-authoritative wallet/entitlements;
- StoreKit purchase uses stable `app_account_token`;
- local gameplay profiles are not purchase owners.

Do not silently turn Commerce Account into a social/friends/public-profile system.

## 9. Content addition rule

Before adding a permanent feature not in a locked GDD/economy/backend doc, document:
1. why it is needed;
2. whether it is shared or game-local;
3. exact player-visible behavior;
4. save/network/commerce impact;
5. AI→3D or UI asset cost;
6. acceptance tests.

## 10. Documentation rule

Docs + matching machine-readable data are the source of truth for player-visible rules and economy behavior.

Code may implement a rule but does not silently redefine it.

Any approved design change must update the relevant doc/data before or in the same change as implementation.
