# CozyUni — Machine-Readable Data Authority

Status: **CURRENT**

Purpose: keep exact numeric/config values out of implementation code and prevent AI agents from copying inconsistent constants between docs, tests, simulation, and runtime.

## Files

### Shared app shell
- `app_shell_v1.json`
  - games admitted to the current build
  - game-library/start-screen metadata
  - exact Ludo summary/tutorial copy already locked by GDD
  - approved CozyUni avatar roster IDs/names

This file contains presentation/routing metadata only. It does not define game legality.

### Global economy
- `economy_v1.json`
  - Cozy Credit packs
  - planning prices
  - catalog price bands
  - allowed catalog types
  - economy scenario defaults
  - review thresholds

### Commerce backend
- `commerce_backend_v1.json`
  - auth/session TTLs
  - Apple notification set
  - wallet spend/refund rules
  - rate limits
  - admin grant caps
  - worker retry defaults
  - production feature-flag defaults

### Gameplay
- `games/ludo_v1.json`
- `games/caro_v1.json`
- `games/journey_v1.json`
- `games/chess_v1.json`
- `games/tycoon_v1.json`

Gameplay JSON contains exact constants already defined by locked GDDs. It does not invent new rules.

## Authority rule

Markdown GDD = behavioral meaning and player-visible rule.
JSON = exact machine-readable values for that locked behavior.

If Markdown and JSON disagree:
1. stop implementation;
2. treat it as a documentation defect;
3. correct both in one design/data change;
4. do not choose whichever value is more convenient.

Code must not silently become a third source of truth.

## Godot runtime mirror rule

Canonical JSON lives under `docs/data/`.

The Godot client reads release/runtime copies under:

```text
data/app_shell_v1.json
data/games/*.json
```

These runtime copies are not independently editable authority. They must remain semantically identical to their matching canonical `docs/data/` files.

CI enforces this with:

```bash
python tools/validate_runtime_data_sync.py
```

If the mirror differs, CI fails. Do not hot-fix only the runtime copy.

## Runtime rule

Where practical, runtime + tests + simulator must load the same machine-readable config.

Do not duplicate values like:
- board size
- player count
- special-space IDs
- property prices
- event values
- premium CC grants
- rate limits
- simulation sample sizes

into unrelated source files without a generated/typed config layer.

## Validators

Run before merge:

```bash
python tools/validate_game_data.py
python tools/validate_commerce_data.py
python tools/validate_catalog_data.py
python tools/validate_runtime_data_sync.py
```

Validation success does not prove gameplay correctness; it proves structural/config invariants and catches drift early.

## Change rule

A data change that affects player behavior requires:
- corresponding Markdown design change;
- validator update if invariant changes;
- regression tests;
- simulation comparison where applicable;
- version bump when backward compatibility matters.
