# CozyUni — Game-First Render Priority v0.2

Status: **CURRENT PRODUCTION PRIORITY**

Principle: render only what the active game needs. The existing world library is preserved but world production is deferred.

## 1. Current game order

1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

Cozy Checkers is not active.

## 2. Existing world library

Already-rendered characters, buildings, shops, transport, nature, food, infrastructure, parks and sports assets remain valuable.

Current use:
- optional static board/diorama dressing
- reusable miniatures in Journey/Tycoon where appropriate
- future life-sim world inventory

Do not render more generic world assets during current game-first milestone unless a locked game requires them.

## 3. Engine-first content — no AI render credit

Generate in engine/UI:
- Ludo board/path
- Caro/Tic-Tac-Toe grids
- Journey path/space numbers
- Chess board
- Tycoon board/nodes
- text and labels
- card faces
- values/prices
- ownership colors
- highlights/selection markers
- rule icons where 2D is sufficient

Do not AI-render whole boards as monolithic meshes.

## 4. P0 — Shared board-game kit

High reuse:
1. Cozy D6
2. Winner Trophy
3. optional universal turn marker only if UI-only marker is insufficient
4. optional universal star/reward token only if a current game requires a 3D version
5. Cozy Coin / coin stack for Tycoon later

Do not render all five merely because listed. Mandatory active-game assets come first.

## 5. P1 — Cozy Ludo

Current first production game.

Essential likely assets:
1. `ludo_dice` / shared Cozy D6
2. `ludo_finish_pavilion`
3. `shared_winner_trophy`

Piece strategy:
- first test simplified existing animal characters/tokens
- if board readability fails, render/generate one simple generic pawn/medallion family and runtime recolor

Do not render:
- shortcut gate
- Lucky Gift
- extra board themes

Those mechanics are out of current Ludo v1.

**Expected new 3D renders: 2–4.**

## 6. P2 — Cozy Caro

Preferred: zero bespoke AI→3D art.

Use simple generated discs with:
- Berry icon/material
- Leaf icon/material

Only render bespoke Berry/Leaf tokens if procedural tokens look visually inadequate.

Shared trophy reused.

**Expected new renders: 0–2.**

## 7. P3 — Cozy Journey

Reuse existing transport/world library heavily:
- train/station
- ferry/dock
- cable car
- bridges
- town/harbor/mountain buildings
- nature

Potential bespoke:
1. Journey Start Arch
2. Journey Finish Pavilion if Ludo pavilion cannot be reused

Shared D6/trophy reused.

Special-space icons should be 2D/UI.

**Expected new renders: 1–2.**

## 8. P4 — Cozy Chess

Render exactly six core piece archetypes:
1. King
2. Queen
3. Bishop
4. Knight
5. Rook
6. Pawn

Rules:
- one mesh/archetype each
- runtime material differentiates sides
- standard silhouette recognition first
- simple chunky geometry
- no fragile ornaments

Board generated in engine.

**Expected new renders: exactly 6.**

## 9. P5 — Cozy Tycoon

Do not render until economy prototype is ready for art.

Reuse existing buildings for 12 properties and existing transport assets.

Potential bespoke/shared:
1. Cozy Coin / coin stack
2. ownership base/banner marker
3. upgrade star marker
4. Community Star token
5. shared D6
6. shared trophy

Cards/property info/score are UI/data.

**Expected new renders: ~3–5 after shared reuse.**

## 10. Render order right now

1. Ludo D6
2. Ludo Finish Pavilion
3. Shared Winner Trophy
4. test Ludo board with existing character representation
5. only if needed: fallback Ludo pawn/medallion
6. stop rendering and finish playable
7. render next game's assets only when that game enters production

## 11. Asset ROI classes

### A — Mandatory gameplay
Prototype cannot read/function correctly without it.

### B — High reuse
Used by several active games.

### C — Cosmetic polish
Nice but not required.

Render order: **A -> B -> C**.

If current game is not fun/playable, do not spend credits on C.

## 12. Future world

No current render pack exists for the life-sim world.

When world production restarts, it will use its own full GDD and asset priority. The old broad world checklist is not current production authority.
