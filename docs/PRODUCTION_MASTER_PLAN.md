# CozyUni — Production Master Plan v1.1

Status: **CURRENT / AGENT AUTHORITY / IMPLEMENTATION ORDER LOCK**

This file resolves the production-order ambiguity between the shipping board-game product and the bounded world visual MVP.

## 1. Two-track model

CozyUni has exactly two active production tracks.

### Track A — SHIPPING GAME
This is the critical path.

Order:

`A0 Godot bootstrap -> A1 Shared Shell -> A2 Cozy Ludo rules/headless -> A3 playable Ludo -> A4 Ludo polish/QA -> A5 Caro -> A6 Journey -> A7 Chess -> A8 Tycoon`

No later game enters full production before the current game's exit gate passes.

### Track B — WORLD VISUAL R&D
This is a bounded parallel R&D track.

Order:

`B0 asset/reference authority repair -> B1 W01 blockout -> B2 one concept->3D->Godot proof -> B3 W01 visual pass -> HOLD -> B4 W02-W08 only after explicit gate`

Track B must never block Track A.

If resources conflict, Track A wins.

---

## 2. Current quick-win overlay — MVP-01

The active practical execution package is:

`MVP-01 = Moonberry Village + Cozy Ludo`

Authority:
- `docs/MVP_EXECUTION_PLAYBOOK.md`
- `docs/data/mvp_execution_v1.json`
- `tools/validate_mvp_execution.py`

MVP-01 intentionally combines the already-developed Ludo vertical slice with only enough W01 world work to prove the player-facing loop:

`Library -> Moonberry -> Ludo venue -> Ludo match -> Results -> Moonberry / Rematch`

This does **not** merge Track A and Track B into an uncontrolled scope. The playbook admits exactly one small step at a time.

Hard execution rules:
- agent executes only `current_step` from the machine-readable task graph;
- one step per agent run unless explicitly overridden by the user;
- no future step starts automatically;
- no mass asset generation;
- only W01 and Cozy Ludo are admitted;
- W02-W08 and Caro/Journey/Chess/Tycoon remain deferred until MVP-01 finishes or the user changes authority.

The asset library is treated as a reuse pool, not a production queue. Rendering is controlled by per-step allowlists and cumulative budgets in the execution data.

---

## 3. A0 — Godot production foundation

Deliver:
- locked engine/version/renderer;
- root `project.godot`;
- deterministic folder/source conventions;
- minimal Boot -> Game Library scene;
- autoload/service skeleton only where required;
- data loader capable of reading canonical JSON;
- input map foundation;
- local save/settings foundation;
- headless parse/smoke command;
- CI foundation;
- no game-specific rule implementation yet.

Exit gate:
- project opens without parse errors in the locked Godot version;
- headless project startup exits successfully;
- Game Library placeholder scene boots;
- canonical game JSON validation passes;
- CI runs validators and Godot smoke checks;
- no third-party Godot addon required.

---

## 4. A1 — Shared Shell vertical foundation

Authority:
- `docs/games/00_APP_SHELL_FLOW_LOCK.md`
- `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
- `docs/games/00_SHARED_UI_LAYOUT_LOCK.md`

Deliver only:
- splash/boot;
- Game Library;
- Game Start Screen;
- Local Player Setup;
- Match Summary;
- tutorial framework placeholder;
- pause/settings/help shell;
- Final Results/rematch shell;
- deterministic match seed/action plumbing;
- a test/stub mode to prove navigation.

Exit gate:
- full shell flow completes using test mode;
- back/restart/rematch paths do not leak stale state;
- no Create Room / Join Room / network UI exists;
- shell navigation automated smoke test passes.

---

## 5. A2 — Cozy Ludo headless rules

Authority:
- `docs/games/01_COZY_LUDO.md`
- `docs/data/games/ludo_v1.json`

Deliver:
- pure match state;
- legal action calculation;
- deterministic D6/RNG service;
- deploy/move/capture/safe/home/bonus-turn logic;
- ranking/result payload;
- deterministic serialization for tests/simulation;
- no final board art required.

Exit gate:
- every GDD acceptance invariant has an automated test;
- same seed + actions => same state revisions/results;
- illegal/stale/double-submitted actions are rejected;
- headless simulation interface can use the production rules engine;
- no UI code decides legal moves.

---

## 6. A3 — Playable Cozy Ludo vertical slice

Deliver:

`Game Library -> Ludo Start -> Local Setup -> Tutorial -> Match -> Final Results -> Rematch`

Requirements:
- 2/3/4 local humans;
- readable board interaction;
- required animations only;
- temporary/approved art allowed;
- audio may remain minimal;
- complete match must be playable without developer explanation.

Exit gate:
- 2P/3P/4P matches complete reliably;
- touch/pointer hit areas pass usability gate;
- tutorial communicates deploy/move/capture/home/bonus behavior;
- no rules contradiction with locked GDD/data;
- rematch and change-player flows reset correctly;
- representative device performance is within preliminary budget.

Current implementation has automated Ludo rules/completion/UI smoke coverage; representative-device/human usability evidence remains part of the exit gate.

---

## 7. A4 — Ludo production polish / release candidate

Only after A3 passes:
- final board dressing;
- final character/token/dice assets;
- final audio/VFX;
- localization;
- accessibility pass;
- performance optimization;
- screenshots/visual regression baseline;
- privacy/store preparation where release-relevant.

Exit gate is defined by `docs/engineering/06_QA_BUILD_RELEASE_GATES.md`.

No new Ludo gameplay rules may be introduced during polish without a design-contract change.

For the current Quick Win, A4 work is admitted only through the bounded Ludo visual/UX steps in `docs/MVP_EXECUTION_PLAYBOOK.md`.

---

## 8. A5–A8 — Later games

### A5 Cozy Caro
Reuse Grid Strategy framework.

### A6 Cozy Journey
Reuse Path Board framework from Ludo.

### A7 Cozy Chess
Correct human-vs-human chess only; no bot/clock/rating scope creep.

### A8 Cozy Tycoon
Use locked 28-node/12-round data. Economy balance changes require data update plus simulation/playtest evidence.

Each phase repeats:

`headless rules -> automated tests -> playable vertical slice -> visual polish -> QA gate`

During active MVP-01 these phases are not admitted implementation work.

---

## 9. B0 — Asset/reference authority repair

Before any automated world generation:
- `docs/assets/GENERATION_SOURCE_OF_TRUTH.md` must acknowledge modular kit and batch-sheet plan;
- approved style/reference files required by generation docs must exist locally/repo as appropriate;
- missing reference => `MISSING_REFERENCE`, no text-only substitution;
- Tripo API behavior must come from current official docs, never guessed.

Exit gate:
- generation agent can unambiguously locate source lists, prompts, style authority, and output naming.

---

## 10. B1 — W01 Moonberry Village blockout

Authority:
- `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`
- active MVP-01 step graph when Quick Win is active.

Use primitive geometry / engine modules only.

Prove:
- player scale;
- 60–120 second principal traversal target;
- dominant route + optional side pockets;
- entrances/exits;
- landmark sightline;
- collision;
- navigation;
- camera;
- approximate density zones.

No large final-asset batch before this gate passes.

---

## 11. B2 — one full asset pipeline proof

Choose one representative production asset and prove:

`canonical prompt/reference -> concept image -> approved candidate -> Tripo documented image-to-3D -> downloaded mesh/textures -> local QA -> Godot import -> scale/pivot/material/collision QA -> in-engine screenshot`

Exit gate:
- all steps logged;
- no guessed Tripo field/endpoint;
- result survives reopen/reimport;
- material and scale are acceptable in canonical camera;
- performance impact is measured.

Do not batch-generate the world until this proof works.

Under MVP-01, the exact render allowance is controlled by the active execution step.

---

## 12. B3 — W01 visual pass

Replace blockout in order:
1. hero landmark;
2. route-defining buildings/bridge/station;
3. terrain/large nature;
4. player-scale props;
5. repeated modular details;
6. distant silhouettes.

Use GridMap/MeshLibrary, MultiMesh, individual scenes, or engine terrain according to engineering rules; never treat a full map as one generated mesh.

Exit gate:
- visual comparison against W01 canonical references;
- route remains readable;
- no collision/navigation regression;
- performance budget passes;
- no accidental entrance blocking;
- before/after evidence stored.

After B3: **HOLD** unless the user explicitly authorizes B4 or Track A has enough capacity.

---

## 13. B4 — W02–W08

These maps are allowed by the world visual lock but are **not automatically admitted to production**.

Admission requires:
- W01 pipeline proven;
- modular kit/import workflow stable;
- device performance known;
- no impact on Track A critical milestone;
- explicit production decision.

Then build maps sequentially, not all at once.

During MVP-01, B4 is explicitly locked.

---

## 14. Backend / commerce track

Commerce architecture may be implemented behind feature flags, but it is not a prerequisite for local board-game play.

Before paid Cozy Credits are enabled, require:
- real backend implementation;
- database migration applied in test environment;
- Apple transaction verification;
- idempotent grant/refund/reconciliation tests;
- StoreKit Test/Sandbox evidence;
- privacy and release review.

Never block A1–A3 on commerce login.

Commerce implementation is outside MVP-01 unless the user explicitly changes scope.

---

## 15. Definition of done for any agent milestone

A milestone is complete only when all applicable categories pass:
- design authority;
- deterministic implementation;
- automated tests;
- playable smoke test;
- visual evidence;
- performance evidence;
- accessibility/input checks;
- data validation;
- no unresolved P0/P1 defects;
- exact changed-file scope documented.

Writing code without evidence is not completion.

For MVP-01, the current step's specific gate is also mandatory.

---

## 16. Hold / stop conditions

STOP rather than invent when:
- source documents conflict;
- a game rule is missing;
- reference image required by pipeline is missing;
- engine/plugin dependency is not approved;
- asset cannot satisfy import/quality gate;
- performance budget is exceeded and no approved optimization route exists;
- external API docs do not support a requested parameter/workflow;
- task would require implementing a deferred feature;
- work belongs to a future locked MVP step;
- asset generation is outside the active render allowlist/budget.

Use the stop codes defined in root `AGENTS.md` and `docs/MVP_EXECUTION_PLAYBOOK.md`.
