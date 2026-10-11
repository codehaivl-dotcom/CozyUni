# W01 — Modular Land Blueprint and Build Piece Catalogue (v1.2)

## 1. Layout and placement — semantic blockout, NOT surveyed scene coordinates

The personal-build pocket is directly alongside **W01 RESIDENTIAL**, branching from the Village residential lane and outside the protected authored route. One four-parcel **2×2 square** is reserved in greybox:

```text
                        [MAIN STREET → SQUARE]    NO BUILD / PUBLIC WORLD
                                     |
                          [RESIDENTIAL LANE]     NO BUILD / PUBLIC ROAD
                                     | 2 m access path (must never close)
                     ┌───────────────┴───────────────┐
                     │ P00  STARTER │ P01 FOR SALE   │
                     │ 8m × 8m     │ 8m × 8m       │
                     │ PLAYER HOME │ (BUY 1/2/3)    │
                     ├──────────────┼───────────────┤
                     │ P02 FOR SALE │ P03 FOR SALE  │
                     │ 8m × 8m     │ 8m × 8m       │
                     │ (BUY 1/2/3) │ (BUY 1/2/3)   │
                     └──────────────┴───────────────┘
                              PERSONAL EXPANSION POCKET
```

- P00 initially owned; P01 and P02 initially purchasable because they share an edge with P00; P03 becomes purchasable only after P01 or P02 is owned. Price applies by **purchase ordinal**, not parcel ID.
- P00’s **PLAYER HOME** is an exterior landmark at edge of the parcel, not a free-build/relocatable house; home footprint should not consume mandatory 2 m access corridor or be falsely counted as a tiny prop. Reuse a locally verified approved house mesh when possible, otherwise blockout until real asset import.
- The building zone is visually adjacent to W01 but never replaces the four distinct canonical neighborhood residences. Public shops/square/road and NPC doors remain protected and never selectable.
- 4 parcels × 8×8m = 256 m². The worldbuilder measures global transforms and validates these lot positions in Godot; the 2×2 topology is normative, the illustrated page orientation is not a claim of north/world-space X/Z.

## 2. Gameplay construction rules

- **Surface cells:** 2m × 2m, 16 per parcel, 64 across the fully expanded garden. Select grass, dirt, cobble or timber deck (engine materials). Walking is continuous and unrestricted by cell squares.
- **Edge snaps:** 2m segments. Place repeatable visual fence, hedge, garden gate; do not block the gate/road approach. Boundary endpoints from engine, decorative AST skins can be fitted only through validated wrappers.
- **Decor anchors:** primarily cell centers; large objects occupy a rectangular footprint of multiple cells, never overlap reserved walkway. Props always use their verified runtime dimensions, not unverified raw Tripo scale.
- **Big tree:** `AST-011` planned envelope 4×4 m → reserve at least 2×2 cells.
- **Garden bench:** `AST-003`, plan as a 1-cell decoration category, but validate final mesh and approach clearance; never use its raw measured bounding box until imported.
- **Gazebo:** `AST-151` intended 5×5m footprint, may only be eligible after at least a large connected free area; **not part of first two-decor building test**, no purchase-dependent render.
- **Fence family:** `AST-241/242/246` visual envelopes reported as 2.4m wide, while structural snap is 2.0m. Validate import/wrapper or use engine-built fence placeholder; never claim clean joins without seam proof.
- **Keep-out:** 2m continuous public access and 2m internal connection corridor; 1m clear around personal interaction sign and player-home doorway; never place blocking assets over NPC/photo points or borders outside purchased parcels.

## 3. W01 owner catalog at start — no new ID inventions

| ID/category | Player use | Unlocked when | Production method |
|---|---|---|---|
| `GROUND-GRASS`, `GROUND-DIRT`, `GROUND-COBBLE`, `GROUND-DECK` | Repaint purchased cells | Beginning | Godot authored procedural surface; *local build-palette keys, not fake canonical AST IDs* |
| `PATH-2M` | Connect roads inside purchased land | Beginning | Engine-built walkable path & mesh |
| `AST-009` Flower Planter | 1-cell garden decoration | Beginning | Reuse accepted GLB, else placeholder |
| `AST-003` Garden Bench | 1-cell seating | Beginning | Reuse accepted GLB, else placeholder |
| `AST-010` Lantern Post | Evening atmosphere | After M04 | Reuse accepted GLB, else placeholder |
| `AST-021` Flower Bush | Garden variety | After M02 | Reuse accepted GLB, else placeholder |
| `AST-022` Hydrangea Bush | Garden variety | After M02 | Reuse accepted GLB, else placeholder |
| `AST-241/242` Picket Fence | Edge decoration, not collision truth | At first plot purchase | Godot 2m structure + accepted wrapper/placeholder skin |
| `AST-246` Arched Garden Gate | Access edge decoration | At first plot purchase | Godot protected opening + accepted visual |
| `AST-011` Oak Tree | 4×4m garden focus, if free cells | After first plot purchase | Reuse accepted GLB, else placeholder |
| `AST-211` Picnic Table | Outdoor meetup | After chapter M06 | Reuse accepted GLB, else placeholder |
| `AST-151` Garden Gazebo | Larger outdoor project (not slice prerequisite) | Later chapter | Defer until dimensions/footprint safe |
| `AST-081/082/085/089` Residential houses | Prefab player-built house/guest structures **in later expanded district only** | After W01 first slice + ≥2 contiguous plots where footprint fits | Reuse an accepted GLB; original four public residential silhouettes remain immovable |
| `AST-155` Café Kiosk | Small social building in player microdistrict (later) | After first slice + design approval | Reuse accepted GLB, test access and collision |

All **actual binary asset states** require source path, rights/hash, import, scale and wrapper verification. The table is **design assignment**, not proof that those binaries exist.

## 4. Purchase / save truth (authoritative intended rules)

- First purchase: M01 +40 VC, M02 +30 VC, M03 +30 VC = 100 VC; spend 100 VC on P01 or P02; current balance goes to 0 VC.
- Second purchase: costs 150 VC; third purchase: 250 VC. Earning one resident-care action = +25 VC/in-game day; not awarded more than once for same in-game day even after quit/reload.
- Save identities: `P00..P03`, `owned`, immutable `purchase_index`, `balance_vc`, `placed_instance_id`, canonical `asset_id` or engine palette key, `parcel_id`, local cell/edge coordinate, 90-degree rotation, custom ground per cell, inventory quantity and daily-reward day key.
- All player-placed items restore only **once** on loading scene. If old save lacks the feature, default to P00 owned, P01–P03 unowned, 0 VC plus unclaimed quest rewards, no lost garden/public progress.
- Invalid placement, no access, insufficient funds, already-owned parcel or duplicate purchase event **must not deduct money or duplicate decorations**.

## 5. Functional acceptance checklist for agent

1. A new avatar can **walk freely** from main village street to player home and onto P00 with no node/board movement.
2. The property Build overlay shows P01/P02 as offers and P03 locked until an adjacent purchase.
3. Completing M01–M03 grants exactly 100 VC; buying P02 costs exactly 100 VC once; P01 and P03 are now valid adjacent offers.
4. A newly bought parcel immediately has engine-built terrain + walkable collision; no credit/API generation call.
5. Paint 2 cells, place a planter and bench, rotate/move/store/re-place the bench. Ghost invalid when blocking the mandatory approach; no item/money consumed on invalid attempt.
6. Quit/reload twice: purchased parcel, 2 cell finishes, inventory and furnishing placements remain identical; no duplicate garden objects, coins or NPCs.
7. NPC remark or casual visit reacts to the placed garden; public map landmarks remain protected.
8. W01 runs with placeholders for any unavailable AST model, but final-art gate demands actual accepted mesh/wrapper.