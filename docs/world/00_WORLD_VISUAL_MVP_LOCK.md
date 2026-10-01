# CozyUni — World Visual MVP Lock v1.0

Status: **DESIGN / PRODUCTION LOCK — BASIC WORLD MAY BE BUILT; DEEP LIFE-SIM SYSTEMS STILL DEFERRED**

Authority: this document overrides older statements that the world must remain completely unbuilt. The new decision is narrower:

> Build **one visually convincing, walkable CozyUni world made of eight small maps/regions**, with enough detail to prove the art/world pipeline. Do **not** attempt the full Animal-Crossing-like life-sim yet.

Board-game production remains independent. The world preview is a bounded visual/environment vertical slice, not a replacement for the five game GDDs.

---

## 1. Product target

The first world milestone must be something the player can actually open, walk through and judge visually.

It must provide:
- a controllable CozyUni resident/avatar;
- third-person or gentle isometric-follow exploration camera;
- eight small connected maps/regions;
- coherent roads/paths and entrances/exits;
- readable landmarks and district identity;
- strong foreground / midground / background composition;
- populated environmental detail using the approved asset library;
- basic ambient animation/VFX where inexpensive;
- photo-worthy views;
- direct access back to the five board games.

It does **not** need yet:
- deep NPC schedules;
- friendship simulation;
- farming/crafting economy;
- full building interiors;
- multiplayer world synchronization;
- quest chains;
- housing decoration systems;
- complex shops/economy;
- hundreds of interactions.

This milestone answers one question: **does CozyUni already feel like a coherent attractive place?**

---

## 2. World structure — exactly eight maps for Visual MVP

### W01 — Moonberry Village
Role: identity anchor / central hub.

Must contain:
- Town Hall / Mayor Hall as hero landmark;
- village square;
- fountain or social centerpiece;
- bakery, flower shop, general store, café/bookshop cluster;
- 4–8 residential houses visible in surrounding streets;
- bus stop / travel connection;
- park/social corner;
- one natural board-game venue.

Primary route:
`Village Entrance -> Main Street -> Village Square -> Town Hall -> Shop Street -> Park / Game Venue -> Exit routes`

Visual density: **high**.

Primary asset packs: 01, 02, 03, 06, 07, 08, 09, 14, 15, 16, 17, 21, 23, 24, 25, 29.

### W02 — Countryside / Farm
Role: open breathing space and agricultural identity.

Must contain:
- farmhouse / barn focal cluster;
- crop fields built with repeated engine modules;
- orchard;
- greenhouse;
- tool / wheelbarrow / hay / feed dressing;
- dirt road and small wooden bridge;
- windmill visible as distant or midground landmark.

Primary route:
`Village Road -> Farmhouse -> Fields -> Orchard -> Barn -> Windmill View -> Woodland Exit`

Visual density: **medium**, with larger negative space than village.

Primary packs: 02, 03, 04, 10/19 depending local inventory, 20, 23, 25, 29, 30.

### W03 — Woodland / Meadow
Role: nature exploration / quiet contrast.

Must contain:
- mixed tree silhouettes;
- meadow clearing;
- trail shelter;
- bridge or stepping-stone crossing;
- mushroom / collectible pockets;
- one old hero tree;
- lookout/photo clearing.

Primary route:
`Farm Trail -> Old Tree -> Meadow Clearing -> Creek Crossing -> Trail Shelter -> Lake Exit`

Visual density: **medium**, clustered around route; background may be denser.

Primary packs: 02, 03, 13, 20, 21, 22, 25, 30.

### W04 — Lake / Riverside
Role: water leisure / fishing / picnic identity.

Must contain:
- engine-built lake/river water surface;
- fishing dock;
- rowboat / small boat;
- reeds and lily areas;
- picnic / bench area;
- footbridge;
- riverside rocks;
- one small shrine/marker/photo POI.

Primary route:
`Woodland Exit -> Riverside Walk -> Fishing Dock -> Picnic Bend -> Footbridge -> Town Exit`

Visual density: **medium-low**; water gives negative space.

Primary packs: 02, 03, 05/07 water vehicles where appropriate, 11/18, 20, 21, 22, 24, 30.

### W05 — Town / Urban Quarter
Role: more developed everyday-services district.

Must contain:
- railway station or transit landmark;
- market hall;
- library/cultural building;
- denser shop frontage;
- urban service props;
- café plaza;
- one public board-game/social table area;
- rail/road connection toward harbor.

Primary route:
`Lake Gate -> Market Street -> Civic Block -> Station Plaza -> Café Street -> Harbor Exit`

Visual density: **high**, but sidewalks/path must remain clear.

Primary packs: 06, 07, 08, 14, 16, 17, 21, 23, 24, 25, 27, 29.

### W06 — Harbor / Seaside
Role: strongest travel / maritime identity.

Must contain:
- ferry terminal;
- lighthouse in strong sightline;
- marina / yacht-club area;
- fishing market / fish crates;
- piers and dock modules;
- boats;
- seaside café or seating;
- route toward resort.

Primary route:
`Town Exit -> Fish Market -> Ferry Terminal -> Marina -> Lighthouse Walk -> Resort Exit`

Visual density: **medium-high** near docks, lower toward water horizon.

Primary packs: 05/07, 06, 08, 12/18, 19/28, 20, 21, 24, 29, 30.

### W07 — Mountain / Cable-Car Region
Role: verticality / adventure / scenic payoff.

Must contain:
- lower cable-car or funicular station;
- uphill route / stairs / path;
- rock and pine dressing;
- camping/trail details;
- lookout platform;
- mountain lodge;
- upper station.

Primary route:
`Lower Station -> Pine Trail -> Camp Bend -> Stone Steps -> Lookout -> Lodge -> Upper Station / Resort link`

Visual density: **medium**, with strong layered elevation.

Primary packs: 02, 05/07, 08, 13, 20, 24, 25, 28, 29, 30.

### W08 — Resort / Tourist District
Role: colorful final leisure/photo district.

Must contain:
- seaside hotel/resort focal building;
- tourist plaza;
- cabana / parasol / lounge zone;
- souvenir kiosk;
- stage/festival-ready plaza;
- marina or scenic overlook connection;
- visible route back toward world network.

Primary route:
`Harbor/Mountain Entry -> Resort Plaza -> Hotel -> Leisure Deck -> Festival Plaza -> Scenic Overlook`

Visual density: **medium-high**, more decorative than farm/forest.

Primary packs: 05/07, 06, 17, 18/20, 19/28, 21, 22, 24, 25, 29, 30.

---

## 3. Scale / composition lock

The agent must not invent map scale from aesthetics alone.

For the Visual MVP:
- each map is a **small walkable district**, not an open-world continent;
- target traversal from primary entrance to primary exit: roughly **60–120 seconds at normal walking speed** before stopping for sightseeing;
- use one dominant route plus 1–3 short optional side pockets;
- no maze streets;
- every map must expose its main landmark within the first 5–10 seconds or through a deliberate sightline;
- foreground detail is concentrated around the playable route;
- distant silhouettes may be non-playable;
- decorative buildings/islands not connected to the route are not assumed playable.

Composition hierarchy:
1. **FG** — player-scale props, path edges, vegetation, interaction/photo anchors;
2. **MG** — route buildings, bridges, stations, plazas, hero clusters;
3. **BG** — skyline, distant terrain, large trees, mountain/water horizon, landmark silhouette.

---

## 4. Detail-density rule

A map is not considered detailed merely because it contains many objects.

Use three density bands:
- **Hero zone:** landmark + 6–12 supporting props/nature clusters;
- **Route zone:** visual beat every 6–12 m using benches, planters, lamps, crates, rocks, flowers, signs or other relevant assets;
- **Transition zone:** deliberately quieter, with terrain/nature doing most of the work.

Do not scatter props uniformly.
Do not block walking lines.
Do not hide building entrances.
Do not merge every asset into one diorama model.

---

## 5. Basic player/world functionality

Visual MVP requires only:
- player spawn;
- walk/run;
- collision;
- camera follow / orbit limits;
- region entrance/exit or simple map travel;
- pause/settings;
- return to Game Library;
- optional photo-mode camera if cheap;
- simple ambient loops such as water, tree sway, smoke/VFX, windmill, boats or transit where existing systems allow.

Everything else requires a separate system design before implementation.

---

## 6. Reference-image lock — two references per map

Every world map must have exactly two canonical visual references before final asset placement.

### REF-A — Hero Gameplay Composition
Purpose:
- art direction;
- final camera language;
- FG/MG/BG density;
- landmark sightline;
- color/material balance;
- route readability.

Format:
- landscape 16:9;
- no HUD;
- game-camera perspective;
- visibly walkable route;
- representative final-detail density.

### REF-B — Layout / Blockout Reference
Purpose:
- route;
- playable boundaries;
- entrance/exit;
- landmark position;
- plaza/bridge/building relationships;
- elevation logic.

Format:
- high oblique bird-view / top-down-like;
- clean readable composition;
- fewer tiny props than REF-A;
- should be reproducible using simple blockout geometry.

Reference files are authoritative for composition, but not for hidden geometry. Agent must not invent unseen building backs/interiors as gameplay requirements.

Expected paths:
```text
References/World/W01_Moonberry_Village_A_Hero.svg
References/World/W01_Moonberry_Village_B_Layout.svg
...
References/World/W08_Resort_A_Hero.svg
References/World/W08_Resort_B_Layout.svg
```

---

## 7. Board-game reference lock — two references per game board

The same rule applies to the five board games.

Exactly two references per board:
1. **A — gameplay presentation / final art direction**
2. **B — top-down layout / implementation reference**

Required:
```text
References/Games/G01_Ludo_A_Hero.svg
References/Games/G01_Ludo_B_Layout.svg
References/Games/G02_Caro_A_Hero.svg
References/Games/G02_Caro_B_Layout.svg
References/Games/G03_Journey_A_Hero.svg
References/Games/G03_Journey_B_Layout.svg
References/Games/G04_Chess_A_Hero.svg
References/Games/G04_Chess_B_Layout.svg
References/Games/G05_Tycoon_A_Hero.svg
References/Games/G05_Tycoon_B_Layout.svg
```

The locked GDD wins over any accidental rule/layout ambiguity in a generated image.

---

## 8. Tripo production contract

Official source: `https://developers.tripo3d.ai/en/docs`

The agent must treat the official Tripo developer documentation as the only authority for API endpoints, task types, request fields, upload formats, polling/status fields, output URLs and error handling.

### Hard no-guess rule
The agent must **not** invent:
- endpoint paths;
- API versions;
- task type strings;
- request JSON keys;
- model/version names;
- undocumented parameters;
- undocumented enum values;
- response fields;
- retry semantics.

Before first Tripo API use in a run, the agent must:
1. open/read the current official docs;
2. identify the documented workflow needed for the exact task;
3. copy the endpoint and field names exactly;
4. record the docs page/section used in the local generation log;
5. STOP with `TRIPO_DOC_MISMATCH` if the required workflow/field is not documented or cannot be retrieved.

Do not replace a missing documented field with a guessed equivalent.

### Image-to-3D production rule
For each standalone asset:
1. use its exact checked generation prompt from `docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md`;
2. attach the approved CozyUni style reference;
3. generate/approve the concept image locally;
4. use only a Tripo image-to-3D workflow explicitly documented by the official docs;
5. wait/poll only using the documented task-status mechanism;
6. download only output URLs/fields documented by Tripo;
7. validate the resulting mesh/texture locally;
8. mark `[x]` only after visual + 3D QA.

For a scene/map: **never submit the whole world reference as one Tripo model**. Break it into standalone reusable assets. Terrain, water, roads, paths, grass, fog and repeated modular networks remain engine-built.

---

## 9. Tripo generation log required per asset

Local agent must record:
```text
Asset ID:
Concept image path:
Reference image path:
Tripo docs page/section used:
Tripo task type (exact documented string):
Input file(s):
Request fields used:
Task ID:
Final status:
Output file path:
3D QA: PASS / RETRY
Reason if RETRY:
```

No log = asset is not accepted.

---

## 10. World-map assembly workflow

For every map:

### Step 1 — Reference audit
Read REF-A + REF-B and list:
- FG assets;
- MG assets;
- BG assets;
- engine-built terrain/modules;
- hero landmark;
- route;
- entry/exit;
- low-detail/background-only assets.

### Step 2 — Blockout first
Build with primitive geometry only.
Validate:
- player scale;
- walkable route;
- elevation;
- camera;
- landmark sightline;
- entrance/exit;
- occlusion;
- approximate density.

No final Tripo assets before blockout QA.

### Step 3 — Hero replacement
Replace in this order:
1. hero landmark;
2. route-defining buildings/bridge/station;
3. large trees/terrain dressing;
4. player-scale props;
5. distant/background silhouettes.

### Step 4 — Detail pass
Add detail by zone, not uniform scatter.
Vary repeated assets through position/rotation/limited scale variation.
Preserve walking clearance.

### Step 5 — Camera QA
Compare against REF-A from the canonical camera.
Then compare top-down route against REF-B.

### Step 6 — Acceptance
Map is accepted only if:
- route is readable;
- hero landmark matches intended silhouette/sightline;
- no major empty accidental areas;
- no over-clutter;
- materials/colors remain CozyUni Style D;
- no generated building blocks entrance or route;
- background remains clearly non-playable unless connected.

---

## 11. Five-board assembly workflow

Board surfaces, paths, grids, numbers, labels and UI are engine/UI-generated.
AI→3D/Tripo is only for isolated board pieces, landmark miniatures and reusable decorative assets listed in the all-in-one master.

For each board:
1. reproduce REF-B layout procedurally;
2. verify locked GDD topology/rules;
3. set gameplay camera;
4. place final 3D assets;
5. reproduce REF-A art density/color balance;
6. verify HUD does not obscure legal cells or key state.

Generated reference images never override the exact GDD rules.

---

## 12. Current priority

Recommended sequence:
1. W01 Moonberry Village blockout + references;
2. Cozy Ludo board + references;
3. prove one complete concept -> Tripo -> 3D -> engine import chain;
4. finish W01 visually;
5. then W02–W08;
6. board games continue in locked product order.

The goal is **one convincing world + five convincing game tables**, not a huge unfinished life-sim system.
