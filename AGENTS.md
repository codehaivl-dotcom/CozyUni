# CozyUni contributor / coding-agent instructions

These instructions apply to the entire repository unless a deeper `AGENTS.md` explicitly narrows them.

## 1. Authority order

When implementing player-visible behavior, read in this order:

1. `docs/PRODUCTION_MASTER_PLAN.md`
1A. `docs/assets/09_WORLD_ASSET_PRODUCTION_LOCK.md` + `docs/data/world_asset_production_lock_v1.json` for all Harvest Mode jobs
2. `docs/assets/08_WORLD_ASSET_HARVEST_PLAN.md` while Asset Harvest Mode is active
3. `docs/data/world_asset_harvest_v1.json` for harvest budget/allocation policy
4. `docs/MVP_EXECUTION_PLAYBOOK.md` when performing MVP implementation work
5. `docs/data/mvp_execution_v1.json` for the exact current MVP implementation step
6. `docs/agents/00_MULTI_AGENT_WORKFLOW.md`
7. `docs/data/agent_roles_v1.json`
8. `docs/data/mvp_role_assignments_v1.json`
9. `docs/games/00_APP_SHELL_FLOW_LOCK.md`
10. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
11. `docs/games/00_SHARED_UI_LAYOUT_LOCK.md`
12. selected game GDD under `docs/games/`
13. matching machine-readable data under `docs/data/games/`
14. `docs/APP_ARCHITECTURE.md`
15. engineering locks under `docs/engineering/`

World work additionally obeys:
1. `docs/world/README.md`
2. `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`
3. `docs/assets/GENERATION_SOURCE_OF_TRUTH.md`
4. `docs/assets/07_TRIPO_API_V3_EXECUTION.md` when Tripo is used

Commerce additionally obeys:
1. `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
2. `docs/backend/`
3. `docs/data/economy_v1.json`
4. `docs/data/commerce_backend_v1.json`

If two authorities conflict and the hierarchy above does not resolve the conflict, **STOP and report `AUTHORITY_CONFLICT`**. Do not choose whichever behavior seems nicer.

## 2. Current production scope

Shipping critical path:

`Godot bootstrap -> Shared Shell -> Cozy Ludo rules/headless tests -> playable Ludo -> Ludo polish/QA -> next game`

Current temporary production priority:

`COZYUNI WORLD ASSET HARVEST V1 = audit + render the highest-value reusable 3D bank for W01–W08 before free credits expire`

Authority:
- `docs/assets/08_WORLD_ASSET_HARVEST_PLAN.md`
- `docs/data/world_asset_harvest_v1.json`

MVP-01 is preserved as the implementation track, but its W01-only generation caps do not apply to manifest-approved Harvest Mode jobs. Do not alter MVP execution state merely to authorize harvesting.

During the expiry window, asset acquisition is the critical path. Normal gameplay/world implementation may continue when it does not endanger the harvest queue.

Do not implement current-version features that are explicitly deferred:
- online rooms / matchmaking;
- public accounts/friends;
- bots for product gameplay;
- deep life-sim systems;
- farming/crafting/housing economies;
- world quests/friendship schedules;
- paid competitive power.

## 3. MVP one-step execution rule

For MVP-01, every agent run follows:

`INSPECT -> CURRENT STEP -> ASSIGN DECLARED ROLES -> EXACT FILE SCOPE -> APPLY -> VERIFY -> REVIEW -> EVIDENCE -> UPDATE STATE -> STOP`

Hard rules:
- run `python tools/validate_agent_roles.py` and `python tools/validate_mvp_execution.py
python tools/validate_world_asset_production.py` before mutation;
- read `current_step` from `docs/data/mvp_execution_v1.json`;
- read the exact team for that step from `docs/data/mvp_role_assignments_v1.json`;
- do not execute any future `LOCKED` step;
- do not create additional tasks because they seem useful;
- obey the current step render budget and render allowlist;
- after a step passes, mark it `PASS`, set only its declared `next_step` to `READY`, update `current_step`, then stop;
- do not start the newly-ready step in the same run unless the user explicitly overrides the one-step rule.

If unexpected work is required, use the MVP blocker codes defined by `docs/MVP_EXECUTION_PLAYBOOK.md` and stop instead of inventing scope.

## 3A. Multi-agent role workflow

CozyUni uses bounded specialist roles similar in structure to a small game studio.

Authority:
- `docs/agents/00_MULTI_AGENT_WORKFLOW.md`
- `docs/data/agent_roles_v1.json`
- `docs/data/mvp_role_assignments_v1.json`
- `.codex/agents/*.toml`

Hard rules:
- only the roles assigned to the current step may be activated automatically;
- exactly one declared lead role owns the step handoff;
- support roles stay inside delegated scope;
- review roles independently return PASS/CONCERNS/BLOCKED;
- parallel read-only analysis is allowed, but parallel writes to the same file are forbidden;
- every mutable file has exactly one writer role per pass;
- a role name never expands permissions, render budget, secrets access, current-step scope, or authority;
- the step cannot PASS until required reviewers have completed their review;
- if an unassigned role is required and is not in the step escalation list, STOP with `ROLE_NOT_AUTHORIZED` rather than silently adding the role.

Each role must return the standard role handoff defined in `docs/agents/00_MULTI_AGENT_WORKFLOW.md`.

## 4. Engine lock

The game client uses the version and renderer locked in `docs/engineering/00_ENGINE_TECH_STACK_LOCK.md`.

Rules:
- typed GDScript is the default game language;
- do not introduce C#, GDExtension, a third-party Godot addon, or a second engine without an explicit architecture change;
- `.godot/` is generated import/cache data and is never source truth;
- do not commit editor-generated noise unless the file is intentionally source-controlled by the project.

## 5. Data-driven gameplay

Do not hard-code values that are owned by canonical JSON/data files.

The production rules engine and simulator must read the same authoritative data.

The UI may submit player intent, but it must not decide legality. One authoritative rules/state owner validates actions and advances a monotonic state revision.

If required gameplay behavior is absent from GDD + data, **STOP with `MISSING_GAME_RULE`** instead of inventing it.

## 6. Asset rules

Do not invent generation prompts.

Follow `docs/assets/GENERATION_SOURCE_OF_TRUTH.md` exactly.

Normally, the master asset inventory is a library, not a render queue.

During active World Asset Harvest Mode, **the 150-slot registry alone never authorizes a billable job**. First pass H0–H3 of `docs/assets/09_WORLD_ASSET_PRODUCTION_LOCK.md`. Then only the locally evidenced, frozen and reviewed manifest may authorize generation; MVP per-step allowlist does not apply. Only manifest-approved P0/P1/P2 assets may be rendered, and the live credit ledger/reserve policy is mandatory.

Outside Harvest Mode, an asset may be generated only when the active MVP step permits it, has budget, allowlists it, and evidence shows no acceptable substitute.

Otherwise stop with `RENDER_NOT_AUTHORIZED`.

For generated assets:
- preserve source/reference files;
- create candidates beside originals;
- never replace a production asset before validation/approval;
- maintain stable asset IDs and file naming;
- validate scale, pivot, normals, materials, collision, and import before acceptance.

Boards, paths, labels, numbers, cards, and grids that are specified as engine/UI-built must not be generated as monolithic 3D assets.

## 7. Tripo API rules

When using Tripo:
- read `docs/assets/07_TRIPO_API_V3_EXECUTION.md` first;
- use `tools/tripo_v3.py`; do not create a second ad-hoc API client;
- by default only the assigned `asset-pipeline-specialist` may initiate Tripo dry-run/execution;
- the secret is supplied only through local `TRIPO_API_KEY` environment state;
- never commit, echo, log, screenshot, or paste the real API key into repository files;
- never pass the key as a CLI argument;
- billable image-to-3D generation remains dry-run unless `--execute` is explicitly used;
- `--execute` is allowed only when the active MVP step already authorizes the specific render and has budget remaining;
- a user providing an API key does not waive the render budget or current-step restrictions;
- do not silently change the pinned Tripo model/settings;
- if official Tripo docs and repository contract differ materially, STOP with `TRIPO_DOC_MISMATCH` before spending credits;
- task failure does not authorize an automatic paid retry.

Downloaded Tripo candidates under `generated/tripo/` are local working output and are not automatically production assets.

## 8. World construction rules

Blockout first. Final art later.

Every world milestone must prove:
- player scale;
- spawn and route reachability;
- collision;
- navigation where required;
- camera and sightline;
- entrance/exit;
- deterministic/reproducible placement for procedural content;
- performance budget.

Do not submit a whole map reference to image-to-3D as one mesh.

## 9. Code boundaries

Prefer small modules and explicit interfaces.

Do not duplicate shared shell/rules primitives inside individual modes.

Do not put game-specific rules into generic Path Board / Grid Strategy / Economy Board helpers.

Do not let commerce code grant or mutate match-local currencies.

Do not let UI directly mutate canonical match state or paid-wallet state.

## 10. Task discipline

Before changing code:
1. state the milestone and acceptance gate;
2. identify authoritative docs/data;
3. identify the current step's declared lead/support/review roles;
4. identify exact files to change and one writer role per mutable file;
5. preserve unrelated dirty work;
6. prefer the smallest reversible implementation.

Do not opportunistically refactor unrelated systems.
Do not add speculative abstractions for deferred features.
Do not silently add dependencies, plugins, network services, or hosted tools.

## 11. Required validation

At minimum, run all validators relevant to changed data (including the asset production contract when changed):

```bash
python tools/validate_game_data.py
python tools/validate_commerce_data.py
python tools/validate_catalog_data.py
python tools/validate_agent_roles.py
python tools/validate_mvp_execution.py
python -m py_compile tools/tripo_v3.py
```

For Godot/client work, also run the gates defined by `docs/engineering/06_QA_BUILD_RELEASE_GATES.md`, including parse/headless smoke tests and game-specific tests.

For world/visual changes, capture evidence from canonical cameras and run the performance/asset checks defined by engineering docs.

A task is not complete because code was written. It is complete only when its acceptance gate passes.

## 12. Evidence and failure reporting

When a gate fails:
- preserve the failing seed/log/screenshot where useful;
- report the exact failed invariant;
- do not hide a failure by weakening the gate unless the canonical design changes;
- do not mark generated assets or milestones complete while known required checks fail.

Use explicit stop reasons such as:
- `AUTHORITY_CONFLICT`
- `MISSING_GAME_RULE`
- `MISSING_REFERENCE`
- `ASSET_IMPORT_FAIL`
- `PERFORMANCE_GATE_FAIL`
- `TRIPO_DOC_MISMATCH`
- `TRIPO_KEY_MISSING`
- `BUILD_GATE_FAIL`
- `MVP_EXECUTION_CONFLICT`
- `MVP_BLOCKED_MISSING_DEPENDENCY`
- `MVP_BLOCKED_MISSING_ASSET`
- `MVP_BLOCKED_MISSING_REFERENCE`
- `MVP_BLOCKED_AUTHORITY_CONFLICT`
- `MVP_BLOCKED_PERFORMANCE`
- `MVP_BLOCKED_BUILD`
- `MVP_BLOCKED_RENDER_BUDGET`
- `RENDER_NOT_AUTHORIZED`
- `RENDER_BUDGET_EXCEEDED`
- `ROLE_NOT_AUTHORIZED`

## 13. Contract changes

If a public/gameplay contract changes, update together as applicable:
- GDD / authority doc;
- machine-readable data;
- validation/test;
- affected implementation;
- changelog/roadmap only when milestone scope changes.

Never change only the implementation and leave the source-of-truth docs/data inconsistent.
