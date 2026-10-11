# CozyUni — Land Expansion & Modular World Building v1.2

**User feature direction (2026-10-11):** the player can purchase more adjacent land and **piece together a custom slice of the cozy world** with reusable modular nature, ground, fences, paths and structures. This is a main replayability pillar, not a decorative afterthought.

## 1. Design fantasy and positioning

In Moonberry, players live among 20 recognizable residents; each has a small place of their own that they can expand. The town is coherent and authored, while **the player-owned Residential Garden** is flexible. Start with a small garden; earn access to neighboring land through play; place paths, fences, flowers, benches, trees and personal gathering spaces; watch residents wander into the result.

**Core loop:** Explore and meet people → take part in short village activities → earn Village Coins and design pieces → buy a neighboring plot → build/rearrange with snap-pieces → villagers interact with it → save and revisit.

The result must feel like *my neighborhood*, not a building menu disconnected from the existing world.

## 2. Ownership, purchase and expansion

- **Starter property:** one free 8 m × 8 m square parcel adjoining the existing W01 `RESIDENTIAL` zone, linked to the public road by a permanently open **2 m clear path**. Its position is measured in Godot during W01 greybox; **do not assert invented world X/Z coordinates**.
- **Expansion offers:** exactly three designated **8 m × 8 m adjacent parcels** in W01. A parcel can be bought only if its edge directly touches already-owned land *and* it is an approved pre-authored offered lot. Player chooses the acquisition order among currently adjacent offers; no detached island purchases.
- **Personal maximum for W01:** 4 parcels total (1 starting + 3 purchased) = **256 m² land surface**; precise available shape and boundaries are locked as 2×2 parcels in `07_W01_BUILD_PIECES_AND_PLOT_LAYOUT.md`.
- **Prices with earned Village Coins (VC):** first purchase 100 VC, second 150 VC, third 250 VC. Charge depends on number of purchases already completed, independent of parcel chosen. Never let spending make the player lose or block a main story beat.
- **Earn VC:** M01 +40, M02 +30, M03 +30; exactly 100 VC available by the end of M03. Optional **resident-care** action +25 VC once per simulated in-game day (one care interaction, not repetitive tap grinding). No purchasable VC, real-money land payments, paid timer skip or paid access gates in the first release.
- **Purchase UI:** at the Residential Land Board, show current balance, plot shape, access/validity and price; tap Preview → Confirm/Cancel. Confirm charges **once** and extends walkable terrain/boundary in the saved world. Insufficient funds → clear message, no spend, no partial land.
- **Persistent:** bought land can never be accidentally deleted or re-locked by moving decorations. Build undo does not reverse a land purchase or create a refund exploit.

This is a **new soft-currency product decision** superseding v1.1's W01 no-currency proposal only for earned VC land purchases; Cozy Credits premium commerce stays dormant.

## 3. What a parcel is (visual + physical)

One 8×8 m purchased parcel consists of **a reusable engine-authored ground footprint**, not an 8×8 m Tripo-generated diorama. Internal tile snap spacing is **2 m**: 4×4 build cells per parcel. The continuous play-world route is *free walking*, not board-game tile/node movement. The 2 m grid appears only in **Build Mode**.

Parcel visual stages:
1. **For sale:** transparent ground preview/wooden boundary posts, not walkable owned garden. The world beyond is scenic but non-interactive.
2. **Purchased:** physical ground appears, parcel perimeter visually joins owned land, internal temporary fence opens, path connection is clear.
3. **Decorated:** player-selectable surfaces and modular assets create distinct personal layouts.

The **terrain base, ground paint, walkable layer, seams, curb logic and path join** are generated/placed by Godot, zero model calls. AI→3D meshes are for visible standalone objects/skins from known AST/MOD catalog, never the source of truth for collision or exact 2 m join dimensions.

## 4. Build Mode — exact W01 interaction contract

- Interact with a **Build sign** at own property (not a constant HUD button). Camera tilts to a gentle high-3/4 view showing the parcel boundaries and current placements. Controls remain touch-first.
- Palette tabs: `Ground` (grass / warm dirt / cobble / wooden deck), `Path & Edge` (simple 2 m path segments and approved fence/gate wrappers), `Garden` (flower bed / planter / bushes / one tree), `Furniture` (bench / lantern / picnic corner).
- Select category → select owned/unlocked item → see translucent ghost → snap to permitted 2 m cell or 2 m edge → rotate 0/90/180/270° → valid green / invalid red with reason → Confirm / Cancel.
- **Structural objects** (walkable bridges, stairs, pond edges, plot extension) are Godot-authored deterministic systems. Standalone AST meshes visually dress them only after import QA. No arbitrary 3D rotations, scaling by player, procedural house interiors or physics dragging.
- **Move / Store:** placing consumes one copy from owned decor inventory; Move changes instance position for free; Store returns the piece to inventory. Public village projects use separate locked civic sockets and do not consume land inventory.
- **Collision/readability:** player always has a free 2 m access corridor from road to each owned parcel; a furniture footprint may not overlap a required path/collision zone; no placement may block an NPC visiting point, scene travel marker, entrance or functional object.
- **Undo:** before Confirm cancel costs nothing; after Confirm item can be moved/stored at zero cost. Terrain repaint is free after unlock. No destructive permanent mistakes.
- **Feedback:** within 1–2 s the world visibly changes; a nearby NPC may make a short relevant remark or use a bench after a later schedule tick. Never require NPCs to solve complex navigation around arbitrary obstacles to finish a quest.

## 5. Assets and render-credit economy

**No new material bank generated per purchased plot.** Reuse visual world pieces from the already catalogued assets and modular kit:

- Ground/path edges: engine mesh/material; optionally wrap approved MOD kit skins only when exact 2 m modules passed snapping tests.
- Boundary family: `AST-241` straight picket fence, `AST-242` corner, `AST-246` garden gate; `AST-250` hedge fence. These are Tripo visual candidates with planning widths around 2.4 m; **structural 2 m endpoints belong to Godot**.
- Furniture: `AST-003` bench, `AST-009` flower planter, `AST-010` lantern, `AST-211` picnic table.
- Garden: `AST-021` flowering bush, `AST-022` hydrangea, `AST-028` rock/moss, `AST-011` oak tree (tree may occupy more than one snap cell).
- Later W02 farming modules: `AST-183` raised garden bed, `AST-188` greenhouse, but **not required to open W01 land purchase**.

Asset truth: 296 AST catalog entries and 150 registry slots are **not proof of 296 existing usable GLBs**. First inspect local models/rights/rigs and classify REUSE/ENGINE_BUILT/MISSING; no new generation solely because a plot was purchased in gameplay.

## 6. From small plot to a player-created world district

- **W01 first playable:** four total connected parcels prove purchasing, snapping, path connections, editing and persistence. **Four is a production test cap, not the ultimate creative-world size.**
- **W01 later expansion chapter:** grow the player-owned neighborhood to **up to 12 contiguous 8×8 m parcels**, after economy, build UX and tablet-performance gates pass. Allow players to create a real path-connected microdistrict rather than merely a bigger garden. This 12-parcel chapter is a later scope decision, not part of the initial test build.
- **World-composition palette later:** paths/intersections, hedges, fencing, planted groves, outdoor plazas, decorative pond edges, social furniture and **placeable small-house/market prefabs** (for example the cataloged AST-081/082/085/089 houses, AST-155 kiosk), all conditional on imported footprints and clearance. These are reusable building skins over a consistent engine snap/collision foundation. Do **not** allow moving the protected original Moonberry Town Hall, active NPC homes, shops or village entry.
- **W02 Countryside** can later supply another owned homestead with orchard/farm-themed modules. Other W03–W08 regions may offer themed expandable pockets (lake campsite, seaside cabin, mountain viewpoint, etc.) only after their gameplay is designed; the personal building inventory/piece rules are shared, not eight new editors.
- Every newly purchased parcel changes the visible walkable boundary, and every construction piece changes player-made scenery. A visitable custom district or shareable layout is a **future feature**, not a promise of online services in W01.
- Multiplayer visiting/trading, paying real money for land, economy simulation, public-road editing, demolishing Town Hall and publishing arbitrary custom maps are not W01 scope.

## 7. Acceptance / why it is a game

First paid-land-free 20–30 min test: a new player explores the village, completes M01–M03, sees 100 VC, previews a plot adjoining their own, confirms purchase, walks onto it, chooses ground style, places 2 different items, then saves/reloads with identical layout and balance. Repeated Confirm must not double-charge; invalid placement must not consume an item.

Second-session test: one +25 VC daily care reward is granted once, plot progress is still present, NPC recognizes at least one construction element, player can change their design without losing a decoration.

The game must feel **more personal after five minutes of building**, not merely bigger.