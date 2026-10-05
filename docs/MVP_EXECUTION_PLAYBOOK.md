# CozyUni — MVP Execution Playbook v1.0

Status: **CURRENT / AGENT EXECUTION AUTHORITY / QUICK-WIN LOCK**

Purpose: turn the existing design bible, Godot project, Ludo vertical slice, world plan, and asset inventories into a **small-step execution system** that an agent can follow after cloning the repository without inventing work.

This playbook adapts the production discipline used by `frabcd/codex-ai-game-studio`: inspect first, make one bounded plan, apply only the admitted scope, verify with automated + visual evidence, then advance. CozyUni does not copy that repository's tooling; it adopts the same discipline of **reversible, evidence-gated steps**.

---

## 1. MVP-01 product target

The first quick win is **Moonberry Village + Cozy Ludo**, not all eight maps and not all five games.

Target playable loop:

```text
Boot
-> Game Library
-> Enter Moonberry Preview
-> walk Moonberry Village
-> approach/select the Cozy Ludo table/venue
-> existing Ludo Start Screen
-> Local Player Setup
-> Tutorial when required
-> full Ludo match
-> Final Results
-> Return to Moonberry OR Rematch
```

MVP-01 proves exactly five things:
1. CozyUni has a coherent visual identity beyond a menu.
2. One world zone is pleasant to move through.
3. World -> game -> result -> world is understandable.
4. Cozy Ludo is complete enough for real people to play without developer explanation.
5. The project can reuse existing assets selectively instead of rendering the full asset library.

MVP-01 does **not** authorize:
- W02-W08 production;
- Caro/Journey/Chess/Tycoon production work;
- deep life-sim systems;
- quests, NPC schedules, housing, farming, crafting, friendship;
- online rooms/matchmaking;
- mass asset generation;
- monetization UI rollout.

---

## 2. Required execution protocol

Every agent run for MVP-01 follows this loop:

```text
INSPECT
-> READ CURRENT STEP
-> DECLARE EXACT FILE SCOPE
-> APPLY ONLY THAT STEP
-> RUN REQUIRED CHECKS
-> CAPTURE REQUIRED EVIDENCE
-> PASS / FAIL
-> UPDATE EXECUTION STATE
-> STOP
```

The machine-readable authority is:

`docs/data/mvp_execution_v1.json`

The human-readable authority is this file.

If they conflict: **STOP with `MVP_EXECUTION_CONFLICT`**.

### Hard rule: one step per run

The agent may execute only `current_step` from `docs/data/mvp_execution_v1.json`.

After a PASS:
- mark the current step PASS;
- set `current_step` to its declared `next_step`;
- commit evidence/state changes;
- **STOP**.

Do not start the next step in the same run unless the user explicitly asks to override the one-step rule.

### Hard rule: no self-created tasks

The agent must not add a new implementation task because it “would be nice”, “is needed later”, or “fits the architecture”.

Unexpected required work must be reported with one of:
- `MVP_BLOCKED_MISSING_DEPENDENCY`
- `MVP_BLOCKED_MISSING_ASSET`
- `MVP_BLOCKED_MISSING_REFERENCE`
- `MVP_BLOCKED_AUTHORITY_CONFLICT`
- `MVP_BLOCKED_PERFORMANCE`
- `MVP_BLOCKED_BUILD`
- `MVP_BLOCKED_RENDER_BUDGET`

Then stop.

---

## 3. Asset strategy — do not render the library

The master asset inventory is a library, **not a render queue**.

For MVP-01 every visible asset receives exactly one status:

- `REUSE_NOW` — accepted existing asset is available and good enough.
- `ENGINE_BUILT` — Godot creates the surface/system; do not render it.
- `PLACEHOLDER_OK` — primitive/procedural representation is acceptable for this step.
- `RENDER_NOW` — required, missing, visible enough to justify cost, and explicitly allowed by the current step.
- `DEFER` — not required for MVP-01.
- `BLOCKED` — required but cannot proceed under current authority/budget.

### Render authorization rule

A generation call is legal only if all are true:
1. current step allows rendering;
2. asset ID/family appears in the step render allowlist;
3. inventory evidence shows no acceptable existing substitute;
4. it is visible in the canonical camera/route;
5. render budget has capacity;
6. generation follows `docs/assets/GENERATION_SOURCE_OF_TRUTH.md`.

Otherwise stop with `RENDER_NOT_AUTHORIZED`.

### MVP-01 render budget

Until asset audit passes:

```text
new concept image generations: 0
new 3D generations: 0
```

After audit, cumulative MVP-01 ceiling without explicit user expansion:

```text
concept/image generations: <= 12
3D generations: <= 8
batch sheets: <= 2
```

This is a **ceiling, not a target**. Reuse/engine/placeholder should reduce the actual number.

If the plan needs more, stop with `MVP_BLOCKED_RENDER_BUDGET` and show screenshot evidence plus the missing asset reason.

---

## 4. MVP-01 world scope — W01 only

Authority remains `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`.

For Quick Win, W01 is reduced to the minimum convincing slice.

### Required visible zones

1. **Village Entrance / Bus Stop**
2. **Main Street**
3. **Village Square / Fountain**
4. **Town Hall hero sightline**
5. **Shop Street**
6. **Park / Cozy Ludo venue**
7. **four residential silhouettes around the playable district**
8. **closed/decorative exits toward future regions**

### Required route topology

```text
Entrance
  |
Main Street
  |
Village Square ---- Shop Street
  |                    |
Town Hall            General Store / Bakery / Flower Shop / Bookshop
  |
Park -------- Cozy Ludo venue
  |
Future-exit marker (closed/decorative in MVP-01)
```

No maze. No hidden required route. No interior required.

### Density

- Entrance: medium-low, readable arrival.
- Main Street: medium.
- Square/Town Hall: hero/high.
- Shop Street: high but walkable.
- Park/Ludo: hero/high around the table; quieter at edges.
- Residential perimeter: medium-low; mainly silhouette/background support.

Details are concentrated on the route. Do not decorate the entire map uniformly.

---

## 5. W01 candidate asset shortlist

These IDs are **candidates for reuse**, not automatic render permission.

### Hero / structure candidates

- `AST-071` Town Hall
- `AST-091` Bakery Shop
- `AST-094` Flower Shop
- `AST-097` Bookshop
- `AST-099` General Store
- `AST-081` Storybook Cottage
- `AST-082` Tall Narrow Townhouse
- `AST-085` Courtyard Patio House
- `AST-089` Garden Villa House
- `AST-129` Bus Stop Shelter
- `AST-285` Grand Fountain Plaza

### Route-detail candidates

- `AST-003` Garden Bench
- `AST-008` Village Signpost
- `AST-009` Flower Planter
- `AST-010` Lantern Post
- `AST-011` Oak Tree
- `AST-012` Maple Tree
- `AST-018` Sakura Tree
- `AST-021` Flower Bush Cluster
- `AST-024` Lavender Patch
- `AST-025` Wildflower Ground Patch
- `AST-028` Rock & Moss Cluster
- `AST-029` Grass Tuft Patch
- `AST-151` Garden Gazebo
- `AST-155` Garden Café Kiosk
- `AST-156` Pergola Bench

### Cozy Ludo candidates

The board/grid/path itself remains engine/UI-built.

Possible reusable 3D components:
- `AST-251` Six-Sided Die
- `AST-252` Wooden Pawn Token
- `AST-256` Trophy Cup
- `AST-257` Shrine Goal Marker
- `AST-258` Flower Tile Marker
- `AST-260` Turn Arrow Marker
- `GAM-298` Ludo Yard Socket

For Quick Win, procedural board/pawns are acceptable until the visual polish step. Do not render these merely because they exist in the master list.

---

## 6. Engine-built list for MVP-01

Do **not** send these to image-to-3D unless a later authority explicitly changes the classification:

- terrain base;
- grass surface;
- dirt/cobble path surfaces where a material/spline/module suffices;
- simple plaza floor;
- simple road/path layout;
- water if used decoratively;
- sky/fog/lighting;
- collision volumes;
- navigation region;
- route blockers / invisible boundaries;
- debug markers;
- Ludo board grid/path;
- Ludo labels/numbers/text;
- legal-move highlights;
- UI panels/buttons/tutorial overlays.

Modular meshes from 05/06 may be used if already available, but absence of a decorative modular piece does not justify generation during greybox.

---

## 7. UI/UX scope for MVP-01

### Game Library

Required:
- existing five-game library behavior remains stable;
- add one **development/preview-gated** entry/action to enter Moonberry Preview;
- it must not masquerade as a sixth board game;
- no online/account/store clutter.

### Moonberry HUD

Required only:
- unobtrusive `Back to Library` / pause access;
- movement control appropriate to tablet test build;
- contextual `Play Cozy Ludo` prompt only inside the Ludo venue interaction zone;
- optional small location label `Moonberry Village` on entry;
- no quest log, minimap, currency HUD, XP, inventory, social feed or world progression.

### Ludo transition

Use existing shell screens:

`Game Start -> Local Player Setup -> Match Summary -> Tutorial -> Countdown -> Match -> Final Results`

Do not create a second Ludo setup flow inside the 3D world.

### Results

MVP-01 requires:
- winner/ranking;
- rematch;
- change players;
- return to Moonberry;
- return to Game Library.

Do not add progression rewards.

---

## 8. Cozy Ludo gameplay scope

Only Cozy Ludo is admitted for MVP-01.

Current rules authority remains:
- `docs/games/01_COZY_LUDO.md`
- `docs/data/games/ludo_v1.json`

Must retain:
- 2/3/4 local humans;
- 3 pieces each;
- deploy on 6;
- safe cells;
- capture non-safe enemy;
- Home Lane/Home;
- clamped finish behavior defined by current GDD;
- max one bonus roll from original 6 after successful legal move;
- deterministic result/ranking;
- rematch starting-player rotation.

No bots. No powerups. No extra dice mechanic. No world bonus affecting the match.

Tutorial must explain only the rules needed to finish a match:
1. whose turn;
2. roll;
3. deploy on 6;
4. choose highlighted legal piece;
5. capture outside safe cells;
6. safe/star behavior;
7. reach Home;
8. one bonus roll rule;
9. all three Home wins.

---

## 9. Execution steps

The canonical current step is stored in `docs/data/mvp_execution_v1.json`.

### MVP01-S00 — Baseline + asset audit

**Mutation scope:** reports/state only. No gameplay/world feature code. No generation.

Inspect:
- current Git commit;
- CI state;
- A0/A1/A2/A3 files/tests;
- existing repository 3D/image assets;
- any explicitly provided local asset roots;
- W01 references actually available;
- current Ludo screenshots/build evidence if present.

Produce:
- `evidence/mvp01/S00_BASELINE_REPORT.md`
- `evidence/mvp01/S00_ASSET_INVENTORY.csv`
- `evidence/mvp01/S00_MISSING_INPUTS.md` only if required.

Inventory columns:

```text
asset_id,name,source_path,status,quality_note,visible_in_mvp01,recommended_action
```

Allowed actions:
`REUSE_NOW, ENGINE_BUILT, PLACEHOLDER_OK, RENDER_NOW_CANDIDATE, DEFER, BLOCKED`

Gate:
- CI baseline known;
- every W01 shortlist item classified;
- every Ludo shortlist item classified;
- required references presence/absence recorded;
- zero render calls performed.

---

### MVP01-S01 — W01 greybox

**Render budget:** 0.

Build only primitive/engine geometry:
- W01 route topology from this file;
- player spawn;
- walk/run foundation;
- follow camera;
- collision;
- route boundaries;
- placeholder Town Hall / shops / houses / fountain / bus stop / Ludo venue;
- decorative closed future exits.

Do not import final art just because it is available.

Evidence:
- top-down/blockout screenshot;
- entrance gameplay screenshot;
- square hero-sightline screenshot;
- park/Ludo screenshot;
- measured traversal time entrance -> Ludo venue -> future-exit marker;
- collision/navigation notes.

Gate:
- route is completable;
- no accidental maze/dead end;
- Town Hall sightline readable;
- Ludo venue reachable;
- traversal is within W01 target after layout scaling;
- no asset generation.

If route time misses target, adjust **layout scale/spacing first**, not unrelated player speed constants.

---

### MVP01-S02 — World interaction skeleton

**Render budget:** 0.

Implement only:
- Moonberry preview entry from Game Library behind explicit preview/development flag;
- world scene load/unload;
- player spawn/reset;
- pause/back to Library;
- Ludo venue interaction zone;
- contextual `Play Cozy Ludo` action;
- transition from venue into existing Ludo Game Start flow;
- result option to return to Moonberry at a deterministic return spawn.

No shop/NPC/inventory/quest interactions.

Gate:
- Library -> Moonberry -> Ludo Start -> back/leave paths work;
- no stale player/session state;
- entering/leaving world repeatedly does not duplicate world/player instances;
- shell smoke tests remain green.

---

### MVP01-S03 — Camera-driven asset shortlist

**Render budget:** 0.

Using the greybox canonical screenshots, classify only what the player actually sees.

For each candidate:
- screen importance: `HERO`, `ROUTE`, `BACKGROUND`;
- existing substitute path;
- approximate on-screen size/readability;
- final action.

Produce:
- `evidence/mvp01/S03_VISIBLE_ASSET_PLAN.md`

Selection priority:
1. Town Hall hero silhouette;
2. Ludo venue/table anchor;
3. 3-4 route-defining shops;
4. fountain/square anchor;
5. four residential silhouettes;
6. bus stop;
7. a minimal repeated set of trees/bench/planter/lamp;
8. everything else deferred.

Gate:
- explicit `REUSE_NOW` list;
- explicit `RENDER_NOW` list;
- explicit `DEFER` list;
- proposed render list stays inside cumulative MVP budget.

Do not generate during this step.

---

### MVP01-S04 — One complete asset pipeline proof

**Maximum:** 1 new concept image + 1 new 3D generation.

If S03 found no required missing hero asset, use one already-approved candidate to prove import/reimport only and spend **zero** generation credit.

If generation is required, choose exactly one missing high-value asset from S03.

Prove:

`authority -> reference -> concept -> approval -> documented 3D generation -> mesh/texture QA -> Godot import -> scale/pivot/material/collision -> canonical screenshot`

Log must follow generation source-of-truth and Tripo/world rules.

Gate:
- repeatable import;
- acceptable gameplay-camera appearance;
- technical QA pass;
- measured performance impact;
- exact credit usage recorded.

No batch generation yet.

---

### MVP01-S05 — W01 hero replacement pass

Use `REUSE_NOW` first.

Replace only:
- Town Hall;
- fountain/square hero anchor;
- 3-4 route shops;
- Ludo venue anchor;
- four residential silhouettes;
- bus stop.

Render only items admitted by S03 and only if still missing after reuse check.

Per-step generation ceiling:
- concept images <= 6;
- 3D generations <= 4;
- still subject to cumulative MVP ceiling.

Gate:
- all hero structures have correct scale/ground contact;
- route entrances remain clear;
- no final asset breaks collision/camera;
- Town Hall/square/Ludo screenshots visibly improve over greybox;
- no off-route building batch generated.

---

### MVP01-S06 — Route detail pass

Prefer existing small props/modular pieces.

Populate only three hero areas:
1. Entrance/Main Street;
2. Square/Shop Street;
3. Park/Ludo venue.

Target visual beat every ~6-12 m using a **small repeated palette**, not unique props everywhere.

Recommended reusable palette:
- 2-3 tree variants maximum;
- bench;
- planter;
- lamp;
- signpost;
- flower/ground-cover cluster;
- rock/moss cluster.

Per-step generation ceiling:
- concept images <= 2;
- 3D generations <= 1;
- batch sheets <= 1;

A missing decorative prop is normally `DEFER`, not a render request.

Gate:
- route feels intentionally dressed;
- no uniform scatter;
- no blocked walk lines;
- background remains cheaper than hero route;
- performance budget remains healthy.

---

### MVP01-S07 — Ludo UX completion in world loop

No new game rules.

Verify/polish:
- world interaction clearly explains entering Ludo;
- Game Start/Setup/Match Summary are readable after world transition;
- tutorial wording covers all required rules;
- current-player indication is obvious;
- legal piece highlight is obvious;
- no-legal-move/capture/home/bonus feedback is understandable;
- pause/restart/leave works;
- Final Results offers `Return to Moonberry`;
- rematch does not reload world unnecessarily.

Render budget: 0 unless a previously authorized Ludo hero component remains missing and is explicitly in the execution state allowlist.

Gate:
- two new testers can complete a 2P match without developer explanation;
- no rule/UI contradiction;
- touch smoke + rules acceptance remain green.

---

### MVP01-S08 — Ludo visual polish, minimum viable

This is **not** a full asset-library art pass.

Polish in this order:
1. board readability;
2. player colors + non-color cues;
3. dice feedback;
4. token readability;
5. safe/home distinction;
6. compact HUD;
7. result celebration.

Procedural/engine board remains preferred.

Only consider 3D component generation if the procedural component materially fails the canonical camera/readability check.

Maximum additional generation:
- concept images <= 2;
- 3D generations <= 2;
- cumulative ceiling still applies.

Gate:
- board can be read in one glance;
- HUD does not cover legal targets;
- 2P/3P/4P remain playable;
- screenshots are presentation-ready enough for internal market test.

---

### MVP01-S09 — Full-loop QA + performance

No feature additions.

Run:
- CI full suite;
- 2P/3P/4P complete Ludo matches;
- Library -> Moonberry -> Ludo -> Results -> Moonberry;
- Return to Library;
- 3 rematches;
- 3 world enter/exit cycles;
- pause/resume while moving;
- touch-release movement stop;
- camera collision cases;
- longest Ludo move/capture/result sequence;
- memory/performance capture per engineering budget.

Gate:
- no P0/P1 defects;
- no state duplication/leak across loops;
- native representative device evidence recorded;
- performance within accepted budget or explicit blocker recorded.

---

### MVP01-S10 — Market-test package

No new gameplay.

Produce:
- one clean 15-30 second capture of Moonberry -> Ludo entry;
- one gameplay capture showing roll/move/capture/result;
- 5 screenshots: Library, Village Entrance, Square, Ludo venue, Ludo gameplay/results;
- one TestFlight/internal build when release tooling is available;
- a short tester script/questions focused on clarity, desire to rematch, visual appeal, and whether the world adds value.

Gate:
- build/capture reproducible from current commit;
- screenshots identify exact commit/build;
- package is suitable for human feedback without explaining unfinished future systems.

After PASS, MVP-01 is complete. Do not automatically begin Caro or W02.

---

## 10. Explicit DEFER list for MVP-01

Even if assets already exist, do not spend time polishing these for MVP-01 unless needed as a visible background substitute:

- W02 farm systems/assets beyond distant exit dressing;
- W03 woodland content;
- W04 lake content;
- W05 town/rail district;
- W06 harbor;
- W07 mountain/cable car;
- W08 resort;
- vehicles not required for static W01 dressing;
- sports/recreation sets except the Ludo venue itself;
- food/market micro-props not visible enough to matter;
- culture/tourism landmarks outside W01;
- complete 20-character production set;
- Caro assets;
- Journey assets;
- Chess assets;
- Tycoon assets;
- commerce cosmetics.

---

## 11. Evidence structure

Use:

```text
evidence/mvp01/
  S00_...
  S01_...
  ...
  S10_...
```

Each step report must include:
- commit before;
- commit after;
- step ID;
- exact files changed;
- tests/checks run;
- result;
- screenshots/logs produced;
- render credits used in the step;
- cumulative render usage;
- blockers/deferred notes;
- next admitted step.

Do not claim PASS without evidence.

---

## 12. Commit discipline

Prefer one coherent commit per small implementation unit, but the step report is the acceptance authority.

Commit messages should include the step ID when practical, e.g.:

```text
MVP01-S01: add Moonberry greybox route
MVP01-S02: connect world preview to Ludo shell
```

Never mix future-step work into the current-step commit.

---

## 13. What the agent should say when starting after clone

Before mutation, agent should report only:

```text
MVP step: <current_step>
Authority read: PASS/FAIL
Baseline checks: PASS/FAIL
Exact files planned: ...
Render budget this step: ...
Stop conditions: ...
```

Then execute the admitted step.

It must not propose a new roadmap unless this playbook itself is being revised by explicit user request.

---

## 14. Definition of Quick Win success

MVP-01 succeeds when a fresh tester can:
1. launch CozyUni;
2. enter a visually convincing Moonberry Village;
3. understand where the Ludo venue is;
4. start a local 2-4 player game;
5. understand the tutorial;
6. complete the match;
7. see a satisfying result;
8. return to Moonberry or rematch;
9. say whether they want another round without being shown W02-W08 or future life-sim features.

That is the decision point for expanding production.
