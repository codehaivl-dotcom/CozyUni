# CozyUni Engineering — Current Authority

Read this folder after root `AGENTS.md` and `docs/PRODUCTION_MASTER_PLAN.md`.

## Client implementation order

1. `00_ENGINE_TECH_STACK_LOCK.md` — Godot version, renderer, language, target-platform lock.
2. `01_GODOT_PROJECT_ARCHITECTURE.md` — project folders, scene/state/rules boundaries, mode contract.
3. `02_ASSET_IMPORT_AND_WORLD_ASSEMBLY.md` — GLB import, scale/pivot/collision, GridMap/MultiMesh/world assembly.
4. `03_INPUT_CAMERA_UI_TECH_SPEC.md` — tablet touch, semantic input, board/world cameras, UI behavior.
5. `04_PERFORMANCE_BUDGETS.md` — preliminary measurable runtime/device budgets.
6. `05_SAVE_LOCALIZATION_ACCESSIBILITY.md` — local persistence, en/fr/vi architecture, accessibility baseline.
7. `06_QA_BUILD_RELEASE_GATES.md` — data/build/rules/playable/visual/performance/export acceptance gates.
8. `07_A3_LUDO_VERTICAL_SLICE_GATE.md` — exact automated + native-device gate before Ludo polish.
9. `HEADLESS_SIMULATION_HARNESS.md` — gameplay simulation contract using production rules engines.

## Current locked client baseline

```text
Godot 4.7.2 stable
Mobile renderer
typed GDScript
landscape tablet first
iPad/iOS release-critical
zero third-party Godot addons required at baseline
```

## Current repository implementation state

### A0 — PASS
Executable Godot foundation exists:
- `/project.godot`
- `/scenes/app/AppRoot.tscn`
- `/src/app/`
- `/src/data/game_data.gd`
- `/src/core/settings_store.gd`
- `/src/core/match_seed_service.gd`
- `/src/core/audio_service.gd`
- `/.github/workflows/ci.yml`

### A1 — PASS
Shared shell implementation exists for:
- Game Library;
- Game Start;
- Local Player Setup;
- Match Summary;
- Tutorial;
- Countdown;
- Match host;
- Pause/settings;
- Final Results;
- Rematch / Change Players / Library.

Shell route smoke tests are part of CI.

### A2 — PASS
Cozy Ludo has one authoritative production rules engine plus deterministic acceptance tests.

Rule/UI code separation is enforced: UI submits actions, production rules/state decides legality.

### A3 — IMPLEMENTED / DEVICE GATE PENDING
Playable Cozy Ludo is connected to the shared shell with a procedural board and production rules state.

Automated gates now include:
- deterministic rule acceptance;
- 2P/3P/4P match-completion batches;
- touch-selection/UI smoke checks;
- project import/main-scene smoke.

A3 must **not** be marked fully complete until `07_A3_LUDO_VERTICAL_SLICE_GATE.md` passes on representative native tablet hardware, including tutorial comprehension and performance evidence.

## Next admitted implementation action

Do not jump to Caro or world expansion while A3 device acceptance is unknown.

Current action order:

`A3 automated gate green -> native tablet playtest/performance evidence -> A3 PASS -> A4 Ludo production polish`.

World W01 remains a separate bounded visual-R&D track and must not block the Ludo shipping critical path.
