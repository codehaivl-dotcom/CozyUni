# MVP01-S00 Baseline Report

Status: PASS
Step: MVP01-S00 — Baseline and asset audit
Lead: producer
Support: asset-pipeline-specialist, godot-specialist
Review: qa-lead, lead-programmer

## Baseline

- Repository: `codehaivl-dotcom/CozyUni`
- Branch: `main`
- Audited commit: `83f30a0a4b9004b40232f09d6a04ebbc34fe3912`
- Latest GitHub Actions run: `CozyUni CI` run #100 (`37320796503`)
- CI conclusion at audited commit: **success**
- Render/generation calls performed by S00: **0**
- Tripo credits spent by S00: **0**

## Existing implementation

The tracked repository already contains the shared Godot project and Cozy Ludo implementation foundation.

Observed source/runtime areas include:
- `project.godot`
- `src/app/`
- `src/core/`
- `src/data/`
- `src/modes/cozy_ludo/ludo_rules.gd`
- `src/modes/cozy_ludo/ludo_match.gd`
- `src/ui/`
- `data/games/ludo_v1.json`

Tracked test coverage includes shell and Ludo test suites under `tests/shell/` and `tests/ludo/`. The CI workflow runs canonical-data validators, runtime-data sync, role/MVP validators, Godot 4.7.2 import/parse, shell flow smoke, Ludo deterministic rule acceptance, 2P/3P/4P completion batches, Ludo UI/touch smoke, and main-scene boot.

The latest CI run for the audited commit completed successfully, so S01 inherits a green tracked baseline.

## Tracked asset audit

No tracked top-level `assets/` directory exists at the audited commit. Therefore none of the MVP01 candidate asset IDs listed by `docs/data/mvp_execution_v1.json` has a tracked production binary/source file available for reuse in this GitHub baseline.

This is not a blocker for S01 because S01 is explicitly primitive/engine-geometry greybox work with zero generation budget.

The detailed classification is recorded in `evidence/mvp01/S00_ASSET_INVENTORY.csv`.

## Reference availability

`References/` contains only `References/README.md` at the audited commit.

Missing canonical visual files include:
- `References/CozyUni_STYLE_LOCK.png`
- `References/World/W01_Moonberry_Village_A_Hero.*`
- `References/World/W01_Moonberry_Village_B_Layout.*`
- Ludo hero/layout reference files described by `References/README.md`

Per reference policy, missing final references block generation/final-art routes that require them, but primitive greybox work may proceed. Therefore reference absence does **not** block MVP01-S01.

## Candidate disposition summary

- Hero structure IDs: tracked source missing -> `BLOCKED` for final/reuse art until a valid source/reference path exists; S01 uses placeholders.
- Route-detail IDs: source missing and nonessential to greybox -> `DEFER`.
- Optional Ludo visual component IDs: source missing; procedural/engine-built board primitives remain preferred -> `DEFER`.
- Terrain, path, plaza, sky/fog/lighting, collision, navigation, route blockers, Ludo grid/path/text/highlights and shell/tutorial UI remain `ENGINE_BUILT` per execution authority.

## Reviews

### QA Lead
PASS. Baseline commit and CI state are recorded, required candidate groups are explicitly classified, reference presence/absence is documented, and no rendering occurred.

### Lead Programmer
PASS. Existing tracked Godot/Ludo implementation and CI form a valid baseline for the next admitted step. Missing final-art inputs do not prevent the primitive-only W01 greybox step.

## Gate result

- baseline CI state recorded: PASS
- all W01 candidate assets classified: PASS
- all Ludo candidate assets classified: PASS
- reference availability recorded: PASS
- zero generation calls: PASS

**MVP01-S00 PASS. Advance only to MVP01-S01.**
