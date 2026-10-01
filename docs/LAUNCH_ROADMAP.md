# CozyUni — Launch Roadmap v0.3

Status: **CURRENT / GAME-FIRST / LOCAL-FIRST**

## Objective

Reach a public release with one genuinely polished local multiplayer game and a reusable shell before expanding to multi-device or world systems.

## Phase 0 — Shared local shell

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

## Phase 1 — Cozy Ludo local vertical slice

Deliver:
`Game Library -> Ludo Start -> Local Setup -> Tutorial -> Match -> Final Results -> Rematch`

Use only canonical Cozy Quick rules from `docs/games/01_COZY_LUDO.md`.

Exit gate:
- all Ludo rule tests pass
- 2/3/4 player local matches complete
- tutorial works without developer explanation
- results/rematch/reset contain no stale state
- no player-visible behavior contradicts locked docs

## Phase 2 — Cozy Ludo polish / release candidate

Only after rules/flow stable:
- final board dressing
- final AI→3D hero assets
- audio/VFX polish
- localization pass
- device performance pass
- privacy/store preparation

Do not add new rules during polish.

## Phase 3 — Cozy Caro local

Add Grid Strategy framework through locked Tic-Tac-Toe and Five-in-a-Row presets.

Exit gate:
- both presets pass G2 acceptance tests
- shared shell is reused rather than duplicated

## Phase 4 — Cozy Journey local

Reuse Path Board infrastructure from Ludo.

Use locked 36-space board and special-space table exactly.

## Phase 5 — Cozy Chess local

Add correct human-vs-human chess only.

Do not gate on bots, ratings, clocks, analysis or puzzles.

## Phase 6 — Cozy Tycoon local

Build only after earlier games prove shared shell and input/state discipline.

Use fixed 28-node / 12-round economy from locked GDD.
Balance changes require doc update plus simulation/playtest evidence.

## Phase 7 — Multi-device research milestone

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

The product may launch after any completed phase once quality is high enough.

Preferred minimum public package:
- shared local shell
- Cozy Ludo production quality
- optionally Cozy Caro if equally polished

There is no requirement to finish all five games before launch.

## Measurement hierarchy

1. app boot -> Game Library
2. game-card selection
3. local setup completion
4. tutorial completion/skip
5. match completion
6. rematch selection
7. session return
8. crash/error rate
9. later: cross-game usage
10. later: multi-device usage after that feature exists

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

## World trigger

Do not begin explorable-world production merely because asset library exists.

World work starts only after a separate full world/life-sim GDD is approved. Its quality target is a genuinely living Animal-Crossing-like experience, not a game-selection lobby.
