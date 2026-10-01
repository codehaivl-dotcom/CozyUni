# CozyUni

**A premium cozy family game table first; a larger living world later.**

CozyUni is one consumer app with a shared visual identity, reusable characters/assets, common settings/accessibility, and multiple polished game modes.

## Current production direction

Current v1 priority is **single-device local multiplayer** on one tablet/screen.

Active game roadmap:
1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

Production order is sequential, not five games in parallel.

Current player flow:

```text
Boot
 -> Game Library
 -> Game Start Screen
 -> Local Player Setup
 -> Match Summary
 -> Tutorial when needed
 -> Match
 -> Final Results
 -> Rematch / Change Players / Game Library
```

Multi-device rooms/matchmaking are later milestones.

## World direction

The large CozyUni library of buildings, transport, nature, food, leisure, infrastructure, and resident characters is retained for a future genuine life-sim/world layer.

The world must eventually justify itself through real interaction, NPC/world behavior, exploration, activities, progression, collection, and social presence. A shallow decorative game-launcher hub is not the target.

Current world work may establish visual MVP scenes and asset references, but it does not silently define future life-sim gameplay/economy.

## Economy

Cozy Credits (`CC`) are the one planned global premium currency.

Rules:
- CC is separate from every match-local score/currency;
- Tycoon Coins and Community Stars never become global money;
- paid currency cannot buy competitive power;
- real-money commerce is server-authoritative and feature-flagged;
- core local board games remain playable without commerce login.

## Data / AI-agent discipline

Docs + matching machine-readable data are source of truth.

Key data lives under:
- `docs/data/games/`
- `docs/data/economy_v1.json`
- `docs/data/commerce_backend_v1.json`
- `docs/data/game_simulation_config_v1.json`

Validation tools:

```bash
python tools/validate_game_data.py
python tools/validate_commerce_data.py
```

Implementation agents must not invent missing gameplay/economy behavior.

## Documentation entry points

- `docs/PRODUCT_STRATEGY.md`
- `docs/APP_ARCHITECTURE.md`
- `docs/CANON_AND_CONTENT_GOVERNANCE.md`
- `docs/games/README.md`
- `docs/world/README.md`
- `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
- `docs/backend/00_BACKEND_TECH_STACK_LOCK.md`
- `docs/DATA_TELEMETRY_AND_SIMULATION.md`

## Art pipeline

CozyUni uses an AI-first image -> 3D asset pipeline.

Current art rules and ready-generation lists live under `docs/assets/`.
