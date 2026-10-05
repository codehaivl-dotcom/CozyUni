# CozyUni

**A premium cozy family game table first; a larger living world later.**

CozyUni is one consumer app with a shared visual identity, reusable characters/assets, common settings/accessibility, and multiple polished game modes.

## Agent entry point

Before any implementation work, read:

1. `AGENTS.md`
2. `docs/PRODUCTION_MASTER_PLAN.md`
3. `docs/MVP_EXECUTION_PLAYBOOK.md`
4. `docs/data/mvp_execution_v1.json`
5. the authority documents for the selected milestone
6. `docs/engineering/` for the Godot/runtime/QA contract

For the current Quick Win, the agent must run only the machine-readable `current_step` and stop after that step's acceptance gate. It may not create its own roadmap, start future locked steps, or render assets outside the active allowlist/budget.

Validate the task graph before mutation:

```bash
python tools/validate_mvp_execution.py
```

Agents must not invent missing game rules, generation prompts, dependencies, deferred systems, or extra MVP work.

## Current Quick Win

`MVP-01 = Moonberry Village + Cozy Ludo`

Target loop:

```text
Boot
 -> Game Library
 -> Moonberry Preview
 -> Cozy Ludo venue
 -> Game Start / Local Setup / Tutorial
 -> Full Ludo Match
 -> Final Results
 -> Return to Moonberry / Rematch
```

Only W01 Moonberry Village and Cozy Ludo are admitted during MVP-01. W02-W08 and Caro/Journey/Chess/Tycoon remain locked until the execution authority advances them.

## Current production direction

Current v1 priority is **single-device local multiplayer** on one tablet/screen.

Shipping game order:
1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

Production is sequential, not five games in parallel.

Current shipping player flow:

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

## Engine

Client implementation is locked to:
- **Godot 4.7.2 stable**
- **Mobile renderer** for the tablet production baseline
- **typed GDScript**
- GLB/glTF-first 3D import
- built-in Godot physics/navigation by default

The root now contains a real Godot bootstrap:
- `project.godot`
- `scenes/app/AppRoot.tscn`
- `src/app/`
- `src/core/`
- `src/data/`

Engineering authority:
- `docs/engineering/00_ENGINE_TECH_STACK_LOCK.md`
- `docs/engineering/01_GODOT_PROJECT_ARCHITECTURE.md`
- `docs/engineering/02_ASSET_IMPORT_AND_WORLD_ASSEMBLY.md`
- `docs/engineering/03_INPUT_CAMERA_UI_TECH_SPEC.md`
- `docs/engineering/04_PERFORMANCE_BUDGETS.md`
- `docs/engineering/05_SAVE_LOCALIZATION_ACCESSIBILITY.md`
- `docs/engineering/06_QA_BUILD_RELEASE_GATES.md`

## Two production tracks

### Track A — SHIPPING GAME
Critical path:

`Godot bootstrap -> Shared Shell -> Ludo headless rules -> playable Ludo -> Ludo polish/QA -> Caro -> Journey -> Chess -> Tycoon`

### Track B — WORLD VISUAL R&D
Bounded parallel track:

`asset/reference authority -> W01 blockout -> one concept->3D->Godot proof -> W01 visual pass -> HOLD`

Track B must not delay Track A. W02–W08 require a later explicit production gate.

The current MVP playbook overlays these tracks with one controlled task at a time rather than allowing broad parallel implementation.

## World direction

A bounded, walkable World Visual MVP is allowed under `docs/world/00_WORLD_VISUAL_MVP_LOCK.md` to prove art direction, modular assembly, navigation, camera and performance.

The world must **not** silently grow into deep life-sim gameplay. Still deferred:
- NPC friendship/schedules
- farming/crafting economy
- housing/interior systems
- deep quests/progression
- persistent shared world

## Economy

Cozy Credits (`CC`) are the one planned global premium currency.

Rules:
- CC is separate from every match-local score/currency;
- Tycoon Coins and Community Stars never become global money;
- paid currency cannot buy competitive power;
- real-money commerce is server-authoritative and feature-flagged;
- core local board games remain playable without commerce login.

Backend design is documented, but paid commerce is not required for the first local-game vertical slice.

## Data / AI-agent discipline

Docs + matching machine-readable data are source of truth.

Key data:
- `docs/data/mvp_execution_v1.json`
- `docs/data/games/`
- `docs/data/economy_v1.json`
- `docs/data/commerce_backend_v1.json`
- `docs/data/game_simulation_config_v1.json`

Validation tools:

```bash
python tools/validate_game_data.py
python tools/validate_commerce_data.py
python tools/validate_catalog_data.py
python tools/validate_mvp_execution.py
```

CI additionally runs a Godot 4.7.2 headless import/start smoke test plus Ludo rules/completion/UI smoke gates.

## Documentation entry points

- `AGENTS.md`
- `docs/PRODUCTION_MASTER_PLAN.md`
- `docs/MVP_EXECUTION_PLAYBOOK.md`
- `docs/PRODUCT_STRATEGY.md`
- `docs/APP_ARCHITECTURE.md`
- `docs/CANON_AND_CONTENT_GOVERNANCE.md`
- `docs/games/README.md`
- `docs/world/README.md`
- `docs/engineering/README.md`
- `docs/assets/GENERATION_SOURCE_OF_TRUTH.md`
- `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
- `docs/backend/00_BACKEND_TECH_STACK_LOCK.md`
- `docs/DATA_TELEMETRY_AND_SIMULATION.md`

## Art pipeline

CozyUni uses an AI-first image -> 3D asset pipeline.

Authority:
- `docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md` — base asset library
- `docs/assets/05_MODULAR_WORLD_KIT_MASTER.md` — reusable world modules
- `docs/assets/06_MODULAR_WORLD_KIT_BATCH_SHEETS.md` — safe multi-item sheet optimization
- `docs/assets/GENERATION_SOURCE_OF_TRUTH.md` — routing/authority

The asset masters are **libraries, not automatic render queues**. MVP rendering is additionally constrained by `docs/data/mvp_execution_v1.json`.

Boards/grids/path logic/text/numbers remain engine/UI-built wherever the GDD requires it.
