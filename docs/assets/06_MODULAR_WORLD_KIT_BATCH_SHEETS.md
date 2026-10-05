# CozyUni — Modular World Kit Batch Sheets v1.0

Status: **READY-GEN BATCH PLAN / DOES NOT REPLACE 05 INVENTORY**

## 1. Goal

This file defines the credit-saving generation plan for the **small modular world pieces** in `05_MODULAR_WORLD_KIT_MASTER.md`.

Instead of rendering every tiny modular piece as one concept image, the generation agent may render **multiple compatible small pieces in one clean asset sheet**, then separate/use the resulting pieces through the approved image-to-3D workflow.

This applies only to small modular/environment pieces.

It does **not** apply to:
- characters;
- vehicles;
- buildings;
- hero landmarks;
- hero props that require silhouette fidelity;
- large trees;
- complex unique structures.

## 2. Hard rule

Batching is a **concept-generation credit optimization**, not permission to merge independent runtime modules into one permanent world mesh.

If a piece is too large, unique, complex, tall, thin/fragile, or dependent on precise silhouette fidelity, use:

`one asset = one image`.

If one item repeatedly fails inside a sheet, split that item into a single-image retry.

## 3. Batch-sheet rendering contract

Each batch image must:
1. contain **4–8 assets maximum**;
2. contain only one compatible family;
3. use large gaps between assets;
4. show every item completely;
5. contain no overlap;
6. use the locked CozyUni style/reference authority;
7. use a plain neutral background;
8. use only a soft contact shadow;
9. contain no decorative environment scene;
10. contain no baked text labels;
11. use a clean grid/layout;
12. keep similar object scale within the sheet;
13. avoid transparent/fragile thin loose detail unless unavoidable;
14. remain readable for image-to-3D separation/reconstruction.

## 4. Prompt wrapper

Use the exact item names from this file together with the current Style Lock/reference requirements from the canonical generation authority.

```text
Create a clean asset sheet containing EXACTLY [N] separate CozyUni modular assets in one image.
Use the attached CozyUni style reference as PRIMARY style authority.
Match its proportions, silhouette language, edge sharpness, material response, saturation, color blocking and lighting.

Premium cozy stylized 3D videogame art: compact readable proportions; soft-but-crisp rounded geometry; clean bevels; slightly exaggerated functional shapes; strong silhouettes; clear material separation; medium saturation; cream only as supporting neutral; sage, muted teal, dusty blue, terracotta, muted coral, honey yellow, olive and natural wood brown. Soft stylized PBR, matte-to-satin highlights, subtle hand-painted variation. Professionally modeled game asset, not handmade sculpture.

NO clay, ceramic, porcelain, pottery, wax, chalk, resin figurine, monochrome beige, washed-out pastel, blobby/melted edges, toy-plastic gloss, photorealism or painterly illustration.

Show the assets isolated on a plain light warm-gray background, arranged in a clean grid, evenly spaced, no overlap, no text and no decorative scene. Each asset must be fully visible and clearly separated so the image can be used for image-to-3D generation.

All items must belong to the SAME modular family. Keep the forms simple, readable and consistent with CozyUni Style D.
```

Then append exactly the family item list for the selected sheet. Do not add scenery or invented objects.

---

# 5. Approved batch sheets

## A. Ground / terrain

- [ ] `SHEET-MOD-001` — Grass family — short grass tile; lush grass tile; dry grass tile; clover grass tile; trimmed lawn tile; meadow grass patch.
- [ ] `SHEET-MOD-002` — Dirt family — plain dirt tile; compact dirt tile; warm dirt tile; dusty path tile; muddy patch tile; worn earth tile.
- [ ] `SHEET-MOD-003` — Stone-ground family — pebble ground tile; gravel tile; rocky dirt tile; packed stone-dirt tile; mossy dirt tile.
- [ ] `SHEET-MOD-004` — Water-edge ground — pond-edge grass tile; muddy bank tile; stony bank tile; reed bank tile; lily-edge tile.
- [ ] `SHEET-MOD-005` — Seasonal ground — light snow tile; compact snow tile; leaf-litter tile; blossom-petal tile; autumn floor tile.

## B. Roads / paths

- [ ] `SHEET-MOD-006` — Dirt Path Kit A — straight dirt path; gentle dirt curve; dirt corner; dirt T-junction; dirt crossroad.
- [ ] `SHEET-MOD-007` — Dirt Path Kit B — narrow dirt path; worn dirt path; puddle dirt path; muddy rut path; broken dirt edge path.
- [ ] `SHEET-MOD-008` — Cobblestone Path Kit A — straight cobblestone path; curve cobblestone path; corner cobblestone path; T-junction; crossroad.
- [ ] `SHEET-MOD-009` — Cobblestone Path Kit B — old stone paving tile; cracked paving tile; mossy paving tile; mixed stone patch; plaza stone tile.
- [ ] `SHEET-MOD-010` — Wooden Walkway Kit — straight plank path; curve plank path; corner plank path; short bridge plank tile; broken plank variant.

## C. Curbs / borders / edges

- [ ] `SHEET-MOD-011` — Low Stone Borders — straight; corner; short end-cap; broken segment; mossy segment.
- [ ] `SHEET-MOD-012` — Wood Borders — straight timber edging; corner timber edging; short divider; planter edge; retaining timber edge.
- [ ] `SHEET-MOD-013` — Hedge Borders — straight hedge edge; corner; rounded cap; trimmed divider; hedge gateway edge.
- [ ] `SHEET-MOD-014` — Canal / Embankment Edges — stone canal edge; wood canal edge; sloped bank edge; reinforced edge; stair-edge landing.

## D. Rocks / cliffs / stone

- [ ] `SHEET-MOD-015` — Small Rock Pack A — small round rock; flat rock; pointed rock; split rock; mossy rock; clustered rock.
- [ ] `SHEET-MOD-016` — Small Rock Pack B — river rock cluster; shoreline rock; cliff rubble; stepping stone; decorative boulder; half-buried stone.
- [ ] `SHEET-MOD-017` — Cliff Modules A — low cliff wall; outer corner; inner corner; end-cap; cliff notch.
- [ ] `SHEET-MOD-018` — Cliff Modules B — layered rock ledge; sloped cliff base; broken cliff edge; mossy cliff face; ridge chunk.
- [ ] `SHEET-MOD-019` — Stone Utility Pieces — stepping-stone set; flat slab stone; stacked rock marker; memorial stone; squat boulder.

## E. Stairs / ramps / elevation

- [ ] `SHEET-MOD-020` — Stone Stairs — short stair; wide stair; corner stair; landing stair; mossy stair variant.
- [ ] `SHEET-MOD-021` — Wooden Stairs & Ramps — short wood stair; ramp plank; side-supported ramp; dock ramp; garden step ramp.
- [ ] `SHEET-MOD-022` — Slope Helpers — grassy slope piece; stone slope piece; dirt slope piece; retaining slope edge; ramp transition tile.

## F. Fences / walls / gates

- [ ] `SHEET-MOD-023` — Picket Fence Set — straight fence; corner; gate; short end; broken fence.
- [ ] `SHEET-MOD-024` — Ranch Fence Set — straight; corner; gate; short end; angled piece.
- [ ] `SHEET-MOD-025` — Stone Wall Set — straight wall; corner; low stone gate; capped wall; broken wall.
- [ ] `SHEET-MOD-026` — Harbor Rail Set — railing straight; corner; end post; safety-rail gate; stair-rail segment.
- [ ] `SHEET-MOD-027` — Garden Gate Set — arch garden gate; simple side post; short hedge gate; low wood gate; stone gate opening.

## G. Harbor / water structures

- [ ] `SHEET-MOD-028` — Dock Modules A — straight dock; dock corner; T-dock; end-cap; narrow finger dock.
- [ ] `SHEET-MOD-029` — Dock Modules B — pile-support dock; rope-edge dock; low platform dock; floating dock; weathered dock tile.
- [ ] `SHEET-MOD-030` — Harbor Small Props — bollard; life-ring stand; dock rope coil; net bundle; dock post; buoy stand.
- [ ] `SHEET-MOD-031` — Canal Structure Kit — canal wall straight; canal corner; canal step; canal bridge stub; water-gate edge.

## H. Rail / transit structures

- [ ] `SHEET-MOD-032` — Rail Track Kit — straight rail; curved rail; visual switch piece; crossing rail; short end rail.
- [ ] `SHEET-MOD-033` — Platform Edge Kit — platform segment; corner platform; stair-access edge; canopy-support base; platform end-cap.
- [ ] `SHEET-MOD-034` — Transit Street Modules — bus-stop base; ticket-kiosk base; curb-stop marker; waiting-shelter base; mini traffic island.

## I. Garden / park small modules

- [ ] `SHEET-MOD-035` — Planter Set — square planter; round planter; long planter; flower box; herb planter; shrub planter.
- [ ] `SHEET-MOD-036` — Park Surface Decor — leaf pile; flower-bed patch; bush cluster; hedge mound; mulch patch; stepping-path cluster.
- [ ] `SHEET-MOD-037` — Park Small Props — simple bench; lamp bollard; trash bin; signpost; drinking fountain; tiny notice board.

## J. World-building fillers

- [ ] `SHEET-MOD-038` — Utility Small — mailbox; utility box; hydrant; street bollard; parking stopper; small pole light.
- [ ] `SHEET-MOD-039` — Market Fillers — crate stack; sack pile; basket cluster; folded awning frame; produce box; parcel pile.
- [ ] `SHEET-MOD-040` — Farm Fillers — hay bale; feed sack; trough; bucket set; small tool rack; fence-post bundle.
- [ ] `SHEET-MOD-041` — Festival Fillers — lantern cluster; bunting pole; folded stall table; speaker box; ticket-rope post; balloon-bunch stand.
- [ ] `SHEET-MOD-042` — Board-Game World Fillers — star marker; arrow marker; blank round token; safe-tile topper; path marker; finish marker.

---

## 6. Assets that stay single-image

Always default to one image per asset for:
- characters;
- vehicles;
- buildings;
- hero landmarks;
- large trees;
- unique shop façades;
- complex sports structures;
- major harbor machines;
- large tourism landmarks;
- board-game hero pieces;
- any module whose sheet version cannot be separated/reconstructed reliably.

## 7. Credit-saving policy

Recommended:
- tiny modular pieces -> 5–6 items/sheet;
- small prop families -> 4–6 items/sheet;
- medium/complex modular assets -> one image each;
- hero assets -> one image each.

Do not maximize item count at the cost of readable 3D reconstruction.

## 8. Naming

Concept sheet examples:
- `SHEET-MOD-001_grass_family.png`
- `SHEET-MOD-028_dock_modules_A.png`

Resulting production assets keep distinct stable IDs/names after separation/import.

## 9. Acceptance

A sheet is accepted only if:
- exact requested item count is present;
- no overlap;
- every module is fully visible;
- family style/materials are coherent;
- individual pieces are distinguishable enough for the downstream 3D workflow;
- no invented scene clutter exists.

A sheet `[x]` does not automatically mark all corresponding runtime 3D modules accepted. Each resulting production module still requires technical/visual 3D QA.
