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
8. `HEADLESS_SIMULATION_HARNESS.md` — gameplay simulation contract once production rules engines exist.

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

Bootstrap exists:
- `/project.godot`
- `/scenes/app/AppRoot.tscn`
- `/src/app/app_root.gd`
- `/src/data/game_data.gd`
- `/src/core/settings_store.gd`
- `/src/core/match_seed_service.gd`
- `/src/core/audio_service.gd`
- `/.github/workflows/ci.yml`

The bootstrap is **not** the finished Shared Shell or any finished game. It exists so agents have an executable architecture target and automated gate instead of inventing a project structure.

## Next admitted implementation milestone

Follow `docs/PRODUCTION_MASTER_PLAN.md`:

`A0 bootstrap acceptance -> A1 Shared Shell -> A2 Ludo headless rules -> A3 playable Ludo`.

Do not jump directly to all five games, W02–W08, online networking, or deep life-sim systems.
