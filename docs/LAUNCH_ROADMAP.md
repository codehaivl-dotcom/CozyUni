# CozyUni — Launch Roadmap v0.4

Status: **CURRENT / GAME-FIRST / LOCAL-FIRST / WORLD-R&D PARALLEL**

## Objective

Reach a public release with one genuinely polished local multiplayer game and a reusable shell before expanding to multi-device or deep life-sim systems.

Shipping order and world-R&D relationship are controlled by `docs/PRODUCTION_MASTER_PLAN.md`.

## Phase 0 — Godot production foundation

Deliver:
- Godot 4.7.2 project bootstrap;
- engine architecture and data loader foundation;
- CI/data validation/headless parse smoke;
- project/folder conventions;
- no speculative online/world-life-sim systems.

Exit gate:
- Godot project boots;
- canonical data validators pass;
- CI baseline passes;
- no third-party addon is required.

## Phase 1 — Shared local shell

Deliver:
- splash/boot
- Game Library
- Game Start Screen
- local player setup
- avatar/name selection
- settings/accessibility/localization foundation
- common tutorial framework
- common pause/help
- common Final Results/rematch
- deterministic local match seed/action plumbing

Exit gate:
- `00_APP_SHELL_FLOW_LOCK.md` runs end to end with a test game stub
- no Create Room / Join Room / network UI exists
- all navigation paths are deterministic

## Phase 2 — Cozy Ludo headless rules

Deliver production rules/state before final visuals.

Exit gate:
- GDD rule tests pass;
- deterministic seed/action replay passes;
- stale/duplicate actions rejected;
- simulator can call production rules rather than a rewritten Python ruleset.

## Phase 3 — Cozy Ludo local vertical slice

Deliver:
`Game Library -> Ludo Start -> Local Setup -> Tutorial -> Match -> Final Results -> Rematch`

Use only canonical Cozy Quick rules from `docs/games/01_COZY_LUDO.md`.

Exit gate:
- all Ludo rule tests pass
- 2/3/4 player local matches complete
- tutorial works without developer explanation
- results/rematch/reset contain no stale state
- no player-visible behavior contradicts locked docs
- preliminary device performance gate passes

## Phase 4 — Cozy Ludo polish / release candidate

Only after rules/flow stable:
- final board dressing
- final AI→3D hero assets
- audio/VFX polish
- localization pass
- accessibility pass
- device performance pass
- visual-regression baseline
- privacy/store preparation

Do not add new rules during polish.

## Phase 5 — Cozy Caro local

Add Grid Strategy framework through locked Tic-Tac-Toe and Five-in-a-Row presets.

Exit gate:
- both presets pass G2 acceptance tests
- shared shell is reused rather than duplicated

## Phase 6 — Cozy Journey local

Reuse Path Board infrastructure from Ludo.

Use locked 36-space board and special-space table exactly.

## Phase 7 — Cozy Chess local

Add correct human-vs-human chess only.

Do not gate on bots, ratings, clocks, analysis or puzzles.

## Phase 8 — Cozy Tycoon local

Build only after earlier games prove shared shell and input/state discipline.

Use fixed 28-node / 12-round economy from locked GDD.
Balance changes require doc update plus simulation/playtest evidence.

## Parallel Track B — World Visual R&D

A bounded visual/environment track is allowed under `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`.

It is not the public-launch critical path.

Allowed order:
1. asset/reference authority repair;
2. W01 Moonberry Village blockout;
3. one complete concept -> 3D -> Godot import proof;
4. W01 visual pass;
5. HOLD;
6. W02–W08 only after explicit production admission.

World R&D must not delay Phase 0–4.

Current World Visual MVP may include:
- walking;
- camera;
- collision/navigation;
- region composition;
- asset/module assembly;
- simple travel/return-to-library;
- ambient presentation.

It may not invent:
- NPC schedules/friendship;
- farming/crafting loops;
- housing systems;
- world quests;
- deep shop/world economy;
- persistent online/shared world.

## Multi-device research milestone

This phase does not begin until local play is stable and worth expanding.

Before code, create separate locked docs for:
- Create Room / Join Room UX
- host/server authority model
- action protocol and revisions
- reconnect / host loss
- QR payload
- privacy/security
- network failure states
- local vs remote latency behavior

Only after those docs exist may Room Mode enter production.

## Public launch choices

The product may launch after any completed shipping phase once quality is high enough.

Preferred minimum public package:
- Godot production foundation;
- shared local shell;
- Cozy Ludo production quality;
- optionally Cozy Caro if equally polished.

There is no requirement to finish all five games or all eight world maps before launch.

## Measurement hierarchy

1. app boot -> Game Library
2. game-card selection
3. local setup completion
4. tutorial completion/skip
5. match completion
6. rematch selection
7. session return
8. crash/error rate
9. performance/device stability
10. later: cross-game usage
11. later: world exploration usage after world admission
12. later: multi-device usage after that feature exists

Do not optimize monetization before repeat-play quality is proven.

## Hold rules

Hold a feature/game if:
- GDD is incomplete
- agent must invent rules
- unique art requirement grows before playable validation
- HUD obscures gameplay
- session exceeds target without design approval
- implementation duplicates shared shell
- networking is started before its design/protocol lock exists
- world work delays shipping critical path
- final assets are produced before required blockout/import proof
- required QA/performance gates fail.

## Definition of done

Use `docs/engineering/06_QA_BUILD_RELEASE_GATES.md`.

A milestone is not done until required automated, playable, visual and performance evidence passes.
