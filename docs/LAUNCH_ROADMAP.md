# CozyUni — Launch Roadmap v0.2

Status: **CURRENT / GAME-FIRST**

## Objective

Reach a public release with one genuinely polished game and a reusable shell before expanding content.

The explorable CozyUni world is not required for the initial launch path.

## Phase 0 — Shared shell foundation

Deliver:
- game list/start screen shell
- profile/name/avatar selection
- One Device setup
- Create Room / Join Room / lobby
- settings/accessibility/localization foundation
- common tutorial framework
- common pause/help
- common Final Results/rematch
- deterministic match seed/action plumbing

Exit gate:
- `00_SHARED_GAME_EXPERIENCE_LOCK.md` flow can be executed end to end with a test game stub
- reconnect/forfeit behavior has automated tests where Room Mode is enabled

## Phase 1 — Cozy Ludo vertical slice

Deliver the locked G1 flow from:
`Game Start -> Mode Select -> Setup/Lobby -> Tutorial -> Match -> Final Results -> Rematch`

Use only the canonical Cozy Quick rules from `docs/games/01_COZY_LUDO.md`.

Exit gate:
- all G1 acceptance tests pass
- 2/3/4 player One Device matches complete
- Room Mode completes/reconnects deterministically
- no implementation decision contradicts GDD
- playtesters can start/finish/rematch without developer explanation

## Phase 2 — Cozy Ludo polish / release candidate

Only after rules/flow are stable:
- final board dressing
- final AI→3D hero assets
- audio/VFX polish
- localization pass
- device performance pass
- store/privacy preparation

Do not add new Ludo rules during polish.

## Phase 3 — Cozy Caro

Add the Grid Strategy framework through the locked Tic-Tac-Toe and Five-in-a-Row presets.

Exit gate:
- both presets satisfy G2 acceptance tests
- shared shell requires no duplicate implementation

## Phase 4 — Cozy Journey

Reuse Path Board infrastructure from Ludo.

The fixed 36-space board and special-space table are authoritative; no extra event content is required.

## Phase 5 — Cozy Chess

Add correct human-vs-human chess only.

Do not gate release on bots, ratings, clocks, analysis or puzzles.

## Phase 6 — Cozy Tycoon

Build only after earlier games prove shared shell/room systems.

The fixed 28-node / 12-round economy in the locked GDD is the first target. Balance changes require doc update plus simulation/playtest evidence.

## Public launch choices

The product may launch after any completed phase once quality is high enough.

There is no requirement to finish all five games before public release.

Preferred minimum public package:
- shared shell
- Cozy Ludo production quality
- optionally Cozy Caro if equally polished

## Measurement hierarchy

1. game start completion
2. tutorial completion/skip
3. match completion
4. rematch selection
5. session return
6. Room creation/join success
7. crashes/disconnect failures
8. later: cross-game usage

Do not optimize monetization before repeat-play quality is proven.

## Hold rules

Hold a feature/game if:
- GDD is incomplete
- agent must invent rules
- unique art requirement grows before playable validation
- HUD obscures gameplay
- average session exceeds its target without deliberate design approval
- Room Mode causes divergent game logic

## World trigger

Do not begin explorable-world production merely because the asset library exists.

World work starts only after a separate full world/life-sim GDD is approved. Its quality target is a genuinely living Animal-Crossing-like experience, not a game-selection lobby.
