# CozyUni — Godot Project Architecture v1.0

Status: **IMPLEMENTATION AUTHORITY**

## 1. Project layout

Canonical client layout:

```text
/
├─ project.godot
├─ src/
│  ├─ app/
│  ├─ core/
│  ├─ data/
│  ├─ modes/
│  │  ├─ cozy_ludo/
│  │  ├─ cozy_caro/
│  │  ├─ cozy_journey/
│  │  ├─ cozy_chess/
│  │  └─ cozy_tycoon/
│  ├─ shared_board/
│  ├─ world/
│  ├─ ui/
│  └─ commerce/
├─ scenes/
│  ├─ app/
│  ├─ modes/
│  ├─ shared/
│  └─ world/
├─ data/
├─ assets/
├─ tests/
└─ docs/
```

Do not create five isolated mini-projects.

## 2. Main scene

`res://scenes/app/AppRoot.tscn` is the main scene.

Responsibilities:
- own top-level screen routing;
- host persistent app-level services/UI layers;
- never implement game rules;
- never directly mutate a paid wallet.

Initial flow follows `docs/games/00_APP_SHELL_FLOW_LOCK.md`.

## 3. Autoload policy

Keep autoloads minimal.

Approved baseline concepts:
- `AppRouter` — top-level app navigation only;
- `GameData` — read/validate immutable runtime game data;
- `SettingsStore` — local settings/accessibility/tutorial flags;
- `MatchSeedService` — deterministic seed creation/recording;
- `AudioService` — common buses/cue routing.

Do not create an autoload for every manager. Mode-specific state belongs to the active mode scene/rules object.

## 4. Mode interface

Every game mode must expose a common conceptual contract:

```text
mode_id
supported_player_counts
create_match(config, seed)
get_public_state()
get_legal_actions(player_slot)
submit_action(action, expected_revision)
is_finished()
get_result_payload()
get_rematch_config()
serialize_debug_state()
```

Exact GDScript class/interface style may be implemented with base classes/resources/composition, but semantics above are mandatory.

The shell must not branch on hidden mode internals.

## 5. Canonical match-state pattern

One authoritative state owner per match.

Flow:

```text
UI intent
 -> Mode Controller
 -> Rules engine validates action against revision/state
 -> accepted state transition
 -> revision increments once
 -> presentation receives new public state/events
```

Rules:
- stale `expected_revision` => reject;
- duplicate input must not apply twice;
- animation completion never decides whether a move was legal;
- rules state must remain testable without rendered scenes.

## 6. Headless rules boundary

Game rules should be written so they can run without the visual board scene.

Preferred pattern:
- immutable/read-only config loaded from data;
- state object/resource/dictionary with explicit schema;
- pure or mostly-pure transition functions;
- deterministic RNG injected/owned by match;
- emitted transition/event records for presentation.

Do not read UI nodes from the rule engine.
Do not rely on frame timing for turn resolution.

## 7. Shared board packages

### Path Board
Used by Ludo/Journey.

Owns only:
- node/path coordinates;
- path rendering/picking helpers;
- generic token interpolation hooks;
- generic D6 presentation hooks.

It must not own Ludo capture/safe/home rules or Journey special-space behavior.

### Grid Strategy
Used by Caro/Chess.

Owns only:
- coordinates;
- board renderer;
- cell picking;
- generic highlight/history presentation.

It must not own chess legal movement or Caro win rules.

### Economy Board
Used by Tycoon.

Owns only:
- loop-node presentation;
- ownership/status display primitives;
- event-card presentation primitives.

It must not become the global Cozy Credits economy.

## 8. Scene ownership

A mode scene may contain:
- board/world presentation;
- local HUD;
- animation coordinator;
- camera;
- input adapter;
- mode controller.

It must not contain canonical game configuration values copied from GDD JSON.

## 9. Screen routing

App-level screens use explicit route IDs, not arbitrary scene-path strings scattered through UI code.

Minimum route vocabulary:
- `game_library`
- `game_start`
- `local_player_setup`
- `match_summary`
- `tutorial`
- `match`
- `final_results`
- `settings`

Navigation payloads must be explicit and testable.

## 10. Runtime data loading

`GameData` loads runtime JSON from `res://data/` and rejects malformed/missing required fields.

Source-of-truth remains `docs/data/`.

A sync/validation step must guarantee runtime copies match canonical data before release.

No silent defaults for required rule values.
Missing required field => fail loudly during development/test.

## 11. World architecture

World Visual MVP is independent from board rule scenes.

Recommended structure:
- one region scene per W01–W08;
- `WorldRoot` controls region transition/loading;
- player/camera scene reusable across regions;
- modular environment pieces instantiated according to `02_ASSET_IMPORT_AND_WORLD_ASSEMBLY.md`;
- world interactions remain minimal until separately designed.

Do not embed the five game rule implementations inside region scenes. A world venue launches the normal app/mode flow.

## 12. Commerce client boundary

`src/commerce/` may expose:
- product catalog view models;
- wallet read model;
- purchase coordinator;
- StoreKit/native bridge adapter;
- backend API client;
- entitlement cache.

Game modes may query cosmetic ownership through a narrow presentation interface, but may not grant/spend CC directly.

## 13. Error behavior

Development builds must prefer explicit failures over invented fallbacks for canonical contracts.

Examples:
- unknown mode ID => error;
- malformed game data => error;
- missing required reference in generation tool => stop;
- invalid player count => block before match creation;
- stale action revision => structured rejection.

## 14. Naming

- GDScript files: `snake_case.gd`
- scenes/resources: descriptive `PascalCase.tscn` / `PascalCase.tres`
- classes: `PascalCase`
- functions/variables/signals: `snake_case`
- constants: `UPPER_SNAKE_CASE`
- asset IDs remain stable lowercase path-like IDs where already defined.
