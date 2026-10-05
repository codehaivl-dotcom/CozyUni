# CozyUni — Product Strategy v0.5

Status: **CURRENT / GAME-FIRST / SINGLE-DEVICE FIRST / VISUAL-R&D WORLD TRACK ALLOWED**

## 1. Decision

Build one primary public app: **CozyUni**.

Current shipping priority is a polished collection of local board games played by multiple people on one tablet/screen.

The active game set is:
1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

Detailed gameplay authority lives in `docs/games/`.

## 2. Product promise

CozyUni should feel like a premium cute digital family game table:
- open app and immediately see available games
- tap one game card to inspect/start it
- choose local players/avatars
- play together on one screen like a physical board game
- clear short tutorials
- readable tablet-first presentation
- fast results/rematch
- cute CozyUni characters/art
- no disposable mini-game feel

## 3. Current multiplayer scope

Current v1:
- one device
- 2–4 local human players depending on game
- turn-based public-information games

Deferred:
- Create Room
- Join Room
- QR join
- one device per player
- public matchmaking
- online accounts/friends

Multi-device is a later expansion, not a current implementation requirement.

## 4. Build one game at a time

The five-game list is a roadmap, not a parallel-development plan.

Shipping production order:
`Ludo -> Caro -> Journey -> Chess -> Tycoon`

A later game does not enter full production until the current game reaches its design/QA gate.

## 5. Current app layers

### Layer A — Shared shell
- splash/boot
- Game Library
- Game Start Screen
- local player setup
- avatar/name selection
- Match Summary
- shared tutorial framework
- pause/help/settings
- common Final Results/rematch
- save/local stats

### Layer B — Board games
Each game owns:
- exact rules
- board state
- legal actions
- HUD context
- tutorial script
- match result/ranking
- game-specific stats

### Layer C — Commerce infrastructure
Design is locked but customer-facing enablement may remain feature-flagged.

Includes:
- Cozy Credits wallet
- StoreKit credit packs
- cosmetic catalog/entitlements
- server-backed wallet ledger before paid CC ships

Commerce rules live in `docs/ECONOMY_IAP_AND_STORE_LOCK.md`.

### Layer D — Future multi-device
Deferred until the local product is proven.

### Layer E — World Visual R&D track
A **bounded world visual MVP is allowed now** under `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`.

This track exists to prove:
- Godot 3D world assembly;
- the modular asset kit;
- concept -> 3D -> engine import;
- walking/camera/collision/navigation;
- environment composition and performance.

It is **not** the shipping critical path and must not delay Shell/Ludo milestones.

Allowed now:
- W01 Moonberry Village blockout;
- one complete concept -> 3D -> Godot import proof;
- world references and assembly tooling;
- later W02–W08 only after the production master plan gate permits them.

Still deferred:
- Animal-Crossing-like life simulation;
- friendship/NPC schedules;
- farming/crafting economy;
- housing/interior systems;
- persistent shared world.

The world authority is `docs/world/README.md` + `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`.

## 6. Art economics

There is no traditional 3D art team.

Therefore:
- boards/grids/paths are generated in engine
- text/cards/numbers are UI/data
- AI→3D is used for isolated production assets
- modular world pieces are grouped where safe to save generation credits
- existing assets may dress boards/world where useful
- no large bespoke art batch before the corresponding gameplay/world proof gate

## 7. What makes CozyUni different

Differentiation is not unfamiliar mechanics.

It is the combination of:
- familiar proven board-game families
- cute CozyUni characters/art
- polished tablet-first board presentation
- shared-device family/friends play
- coherent shell and visual identity
- a reusable modular 3D world art language
- later multi-device expansion if local play proves valuable
- later life-sim world if product quality justifies it

## 8. Current success hierarchy

1. App opens directly into an understandable Game Library.
2. User selects a game with one tap.
3. Local setup is frictionless.
4. Rules are correct and understandable.
5. HUD prioritizes board/action correctly.
6. Players complete matches reliably.
7. Results/rematch feel satisfying.
8. Testers voluntarily ask for another match.
9. Second/third games add value only after the first game is strong.
10. World R&D proves import/assembly without delaying the shipping track.
11. Commerce infrastructure can be implemented behind feature flags.
12. Paid monetization is enabled only after product/repeat-play gates are met.
13. Multi-device comes later.
14. Deep world/life-sim systems come later.

## 9. Mode admission gate

A game does not enter production unless:
- full locked GDD exists
- Game Library -> Start -> Setup -> Tutorial -> Match -> Final Result flow is specified
- local player counts are explicit
- AI→3D asset requirement is bounded
- rules contain no unresolved agent-choice ambiguity
- acceptance tests exist
- shared-engine reuse is documented

## 10. Monetization position

The monetization architecture is defined rather than left for agents to invent.

Current locked position:
- one global spendable premium currency: Cozy Credits (CC)
- CC is separated from all match-local money/scores
- cosmetics only for paid CC in current design
- no ads
- no subscription
- no energy
- no battle pass
- no pay-to-win

The Store may remain disabled until product metrics justify enabling it. Technical readiness and monetization pressure are separate decisions.

## 11. World position

Long-term ambition remains a real Animal-Crossing-like CozyUni life-sim/world layer.

The current world milestone is only a **visual/environment vertical slice**. It does not authorize agents to invent world progression, quests, jobs, friendship, crafting, housing economy, resource loops, or online-world behavior.

See `docs/PRODUCTION_MASTER_PLAN.md` for the relationship between the shipping game track and the visual-R&D world track.
