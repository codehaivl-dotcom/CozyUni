# CozyUni — Product Strategy v0.4

Status: **CURRENT / GAME-FIRST / SINGLE-DEVICE FIRST**

## 1. Decision

Build one primary public app: **CozyUni**.

Current priority is a polished collection of local board games played by multiple people on one tablet/screen.

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

Production order:
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
Design is now locked but customer-facing enablement may remain feature-flagged.

Includes:
- Cozy Credits wallet
- StoreKit credit packs
- cosmetic catalog/entitlements
- server-backed wallet ledger before paid CC ships

Commerce rules live in `docs/ECONOMY_IAP_AND_STORE_LOCK.md`.

### Layer D — Future multi-device
Deferred until the local product is proven.

### Layer E — Future world
Deferred.

Existing 3D buildings, transport, nature, food, leisure and infrastructure assets are reserved for a future genuine life-sim world.

Do not build a shallow decorative hub merely to consume those assets.

## 6. Art economics

There is no traditional 3D art team.

Therefore:
- boards/grids/paths are generated in engine
- text/cards/numbers are UI/data
- AI→3D is used for small isolated hero assets
- existing assets may dress boards where useful
- no large bespoke art batch before gameplay is proven

## 7. What makes CozyUni different

Differentiation is not unfamiliar mechanics.

It is the combination of:
- familiar proven board-game families
- cute CozyUni characters/art
- polished tablet-first board presentation
- shared-device family/friends play
- coherent shell and visual identity
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
10. Commerce infrastructure can be implemented behind feature flags.
11. Paid monetization is enabled only after product/repeat-play gates are met.
12. Multi-device comes later.
13. World/life-sim comes later.

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

The monetization architecture is now defined rather than left for agents to invent.

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

That future world must justify the large asset library through actual life-sim interaction, NPC/world behavior, discovery, progression and social presence.

Until a full world GDD exists, world production stays deferred.
