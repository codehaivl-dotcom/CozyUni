# CozyUni — Product Strategy v0.2

Status: **CURRENT / GAME-FIRST**

## 1. Decision

Build one primary public app: **CozyUni**.

Current product priority is the polished board-game collection, not the explorable world.

The active game set is:
1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

Detailed gameplay authority lives in `docs/games/`.

## 2. Product promise

CozyUni should feel like a premium cute digital family game table:
- easy to understand
- pleasant for children and adults
- One Device play like a physical board game
- Room Mode when players use separate devices
- consistent CozyUni art/characters
- low-friction rematch
- no disposable mini-game presentation

## 3. Build one game at a time

The five-game list is a roadmap, not a parallel-development plan.

Production order:
`Ludo -> Caro -> Journey -> Chess -> Tycoon`

A later game does not enter full production until the current game reaches its design/QA gate.

## 4. Current app layers

### Layer A — Shared shell
- game list
- profile/name/avatar
- settings/accessibility/localization
- One Device setup
- Create/Join Room
- lobby/readiness
- common tutorial hooks
- common results/rematch
- save/stats

### Layer B — Board games
Each game owns:
- exact rules
- board state
- legal actions
- HUD context
- tutorial script
- match result/ranking
- game-specific stats

### Layer C — Future world
Deferred.

Existing 3D buildings, transport, nature, food, leisure and infrastructure assets are reserved for a future genuine life-sim world.

Do not build a shallow decorative hub merely to consume those assets.

## 5. Art economics

There is no traditional 3D art team.

Therefore:
- game boards/grids/paths are generated in engine
- text/cards/numbers are UI/data
- AI→3D is used for small isolated hero assets only
- existing assets are reused as board dressing when helpful
- no large bespoke art batch before gameplay is proven

## 6. What makes CozyUni different

The differentiation is not inventing unfamiliar board mechanics.

It is the combination of:
- familiar proven game families
- cute CozyUni characters/art
- polished tablet-first board presentation
- shared-device family play
- multi-device private room play
- shared shell and identity
- future world/life-sim expansion if product quality justifies it

## 7. Current success hierarchy

1. Start Game flow is frictionless.
2. Rules are correct and understandable.
3. HUD prioritizes the board/action correctly.
4. Players complete matches reliably.
5. Results/rematch feel satisfying.
6. Testers voluntarily ask for another match.
7. Multiple games add value only after the first game is strong.
8. World/life-sim development comes later.
9. Monetization comes after repeat-play value is demonstrated.

## 8. Mode admission gate

A game does not enter production unless:
- full locked GDD exists
- Start -> tutorial -> match -> final result flow is specified
- AI→3D asset requirement is bounded
- rules contain no unresolved agent-choice ambiguity
- acceptance tests exist
- shared-engine reuse is documented

## 9. Monetization position

No gameplay design document currently requires:
- ads
- subscriptions
- energy
- battle pass
- pay-to-win

Monetization requires its own later product decision and must not be invented during game implementation.

## 10. World position

Long-term ambition remains a real Animal-Crossing-like CozyUni life-sim/world layer.

That future world must justify the large asset library through actual life-sim interaction, NPC/world behavior, discovery, progression and social presence.

Until a full world GDD exists, world production stays deferred.
