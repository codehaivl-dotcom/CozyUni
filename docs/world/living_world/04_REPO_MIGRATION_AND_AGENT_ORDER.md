# World Regions and Asset Production — Gameplay-First Plan

## 1. Eight regions with eight distinct reasons to visit

A new region is approved only when it contributes a genuinely different kind of world activity. **Personal modular land building is a shared world system**, not an eighth minigame or a license to terraform every region. The following are **proposed gameplay designs**, while the W01–W08 geographical identities come from the existing World Visual MVP lock.

| Region | Identity | Meaningful play | Persisting world result | Existing asset examples |
|---|---|---|---|---|
| **W01 Moonberry Village** | Home and community | Garden, photo album, choose public decorations, **buy and expand personal land**, meet residents | Square, park, personal plot and relationships evolve | AST-071 Town Hall, AST-285 Fountain, AST-091 Bakery, AST-094 Florist, AST-151 Gazebo |
| **W02 Countryside/Farm** | Growth and seasons | Tend a small shared orchard, discover produce and animal habitat; **future approved farm plot kit** | Orchard plots and harvest calendar visuals | AST-014 Apple Tree, AST-015 Pear Tree, AST-183 Raised Garden Bed, AST-188 Greenhouse, AST-283 Windmill |
| **W03 Woodland/Meadow** | Discovery and wonder | Woodland observation, find animal tracks/mushroom types, restore a peaceful trail | Nature scrapbook and trail clearing | AST-017 Birch, AST-020 Old Tree, AST-026 Mushroom Cluster, AST-007 Firefly Jar |
| **W04 Lake/Riverside** | Quiet leisure | Light fishing/shore discovery and photo moments, lakeside picnic | Pier and picnic scene evolves | AST-016 Willow, AST-027 Reeds, AST-030 Lily Edge, AST-171 Pier |
| **W05 Town/Urban** | Community exchange | Curate small public exhibition / explore shops, meet traveling residents | Community display and album chapter | AST-072 Railway Station, AST-073 Library, AST-076 Market Hall, AST-209 Postcard Stand |
| **W06 Harbor/Seaside** | Travel and collecting | Discover shoreline objects and boats, mark a travel journal | Harbor postcard wall; reopened scenic spot | AST-277 Ferry Terminal, AST-282 Lighthouse, AST-141 Dock Corner |
| **W07 Mountain** | Expedition and viewpoints | Easy trail hike and viewpoint/photo journal, arrange campsite comfort | Lookout journal and warm shelter | AST-146 Cable Car Station, AST-149 Lookout, AST-273 Lodge |
| **W08 Resort/Tourist** | Celebration and social payoff | Show album finds at a communal gathering; seasonal events | Festival plaza and finale scenes | AST-271 Boutique Hotel, AST-272 Seaside Resort, AST-158 Stage, AST-191 String Lantern Arch |

**Not eight independent minigames.** The same world interaction verbs (move, talk, observe, plant/arrange where relevant, photo, journal) accumulate a single coherent world life story. Additional region mechanics should be added one at a time after W01 works.

## 2. Confirmed catalog vs actual asset bank

Remote GitHub `main` contains:
- 296 `AST-*` definitions in the canonical master;
- a 150-ID planning/production registry: A48 + B52 + C25 + D15 + E10;
- character definitions `CHR-001..CHR-020` in the master (separate from 150 AST slots);
- modular construction candidates in `docs/assets/05_MODULAR_WORLD_KIT_MASTER.md`.

Remote **does not establish 296 usable GLBs**; the S00 inventory reports production binaries as NOT_TRACKED. Check local agent GLB inventory, content hashes and rig state before classifying any model as reuse-ready.

### W01 asset mapping — only IDs already in the canonical registry

| Gameplay need | Existing IDs | Placement | Visual/runtime implication |
|---|---|---|---|
| Village welcome and mayor | AST-129 Bus Stop; AST-008 Signpost; AST-228 Welcome Arch; AST-071 Town Hall | ENTRANCE → SQUARE_TOWN_HALL | World route + one talk point; no interior |
| Central social identity | AST-285 Grand Fountain; AST-018 Sakura; AST-022 Hydrangea; AST-234 String Lights | SQUARE | Fountain photo zone, evening lights, gathering anchor |
| Everyday lively street | AST-091 Bakery; AST-094 Flower Shop; AST-099 Store; AST-097 Bookshop; AST-105 Restaurant | SHOP_STREET | Interaction at storefront, NPC scene, optional café exterior; no shop economy yet |
| Garden activity | AST-009 Flower Planter; AST-021 Flower Bush; AST-024 Lavender; AST-025 Wildflowers; AST-151 Gazebo | PARK_SOCIAL | Use engine-authored plant interaction beds; meshes are visuals |
| Decoration choice | AST-003 Bench; AST-009 Flower Planter; AST-010 Lantern Post | SQUARE | One approved placement socket, visual preview and saved choice |
| Photo activity | AST-285 Fountain; AST-091/094 Shop frontages; AST-151 Gazebo | SQUARE/SHOP_STREET/PARK | Photo trigger regions and camera UI are engine-built |
| Social seating | AST-211 Picnic Table; AST-212 Café Table Set; AST-155 Café Kiosk | PARK_SOCIAL/SHOP_STREET | NPC gather around existing silhouettes, don't build full interiors |
| Residential identity | AST-081/082/085/089 four residences; AST-240 Mailboxes; AST-241/242 Fences | RESIDENTIAL | Distinct building masses; small personal doorway decoration socket |
| Wayfinding/detail | AST-001 Crate; AST-002 Barrel; AST-003 Bench; AST-010 Lantern; AST-028 Moss Rocks | route-specific | Repeat tastefully, not uniform prop scatter |
| Neighborhood photo kiosk (later) | AST-196 Photo Booth | SQUARE | Defer until camera/album already playable; not a prerequisite |

**Technical alias note:** `PARK_LUDO` in old Stage A entries must be remapped to `PARK_SOCIAL` or retained only as an explicit deprecated alias until scene/data migration. Do not leave visible signs or interactions advertising Ludo.

### New construction-system asset mapping (no bulk render required)

The user requested **land parcels as modular world-building pieces**. Build the **structural land 8×8 m plots, 2 m snap cells, parcel purchase overlay, walkable paths, collision and seam blending in Godot**, not via paid image-to-3D. Reuse verified existing visual AST modules where possible:

- `AST-241/242` picket fence straight/corner; `AST-246` arched garden gate; `AST-250` hedge fence — decorative skins snapped to engine-authored 2 m edge structure. Registry visual width for some is **2.4 m**: never pretend they are mechanically exact 2 m snap modules without import normalization/proof.
- `AST-003` garden bench; `AST-009` flower planter; `AST-010` lantern post; `AST-211` picnic table; `AST-022` hydrangea; `AST-021` flower bush; `AST-028` moss rock; `AST-011` oak tree.
- `AST-183` raised garden bed is a Stage-B catalog candidate; use engine planter box placeholder until its actual mesh passes import QA.
- No need to buy/render 16 independent grass/ground road tiles from modular candidate catalog just to purchase a new plot: the engine owns surfaces/edges.

Building variations come from arranging the **same reusable asset families**, not from one GLB per buyer-generated plot. Exact constraints, W01 shape and QA in `06_LAND_EXPANSION_MODULAR_BUILDING.md` and `07_W01_BUILD_PIECES_AND_PLOT_LAYOUT.md`.

## 3. Crucial production gap: living characters

The 150-slot registry deliberately contains `AST-*` world objects, **not an accepted animated player/NPC cast**. Cozy world gameplay cannot rely on attractive static buildings and lack of rigged residents.

Before generating future distant landmarks, prove:
- playable `CHR-001 Miko Rabbit` or another approved cast member with movement and interaction poses;
- a rig/animation workflow that supports Mayor `CHR-006 Pip Hedgehog` and at least three other resident silhouettes;
- basic locomotion/idle/talk and at least one use animation reused across characters;
- correct Godot import/pivot/scale/performance for W01.

Character generation requires its own production and budget gate; do not silently steal from the locked AST registry. The **priority should move above Stage D future-region hero landmarks** after user-approved source/rights/credits reconciliation.

## 4. Credit reallocation decision proposal

Keep the 150 asset IDs and generation history **as a planning registry**, but create a new World Gameplay priority view:

1. W01 core architecture + route-visible nature/props from Stage A (reuse first, avoid unnecessary complete 48 calls).
2. W01 player/NPC rig proof and animation, outside existing AST queue (must be explicitly budgeted/approved).
3. **W01 modular personal-land system** — engine-built parcel surfaces/2m snap/collision/save at zero generation credits; reuse AST-241/242/246/250 fencing plus AST-009/003/010/211/022/011 scenery.
4. W01 interactive objects/decoration from A/B/C; prioritize AST-009, 003, 010, 151, 211, 212 and their production viability.
5. Shared nature/roads/bridges for real W02/W03 gameplay expansions, not eight dioramas.
6. Later-region hero silhouettes from Stage D when associated gameplay and camera are validated.

**Render gate stays denied** until existing H0–H3 evidence is proven and new character/gameplay demands are reconciled. For engine-built terrain, exact walk surfaces, placement sockets, navigation, photo UI, farming beds and status flags: spend zero 3D credits.

## 5. No hidden dependency traps

- The avatar/NPCs and interactions should function with primitives before replacing art.
- The photo system must not depend on an expensive physical camera mesh.
- Planter growth is visual state replacement, not real-time horticulture simulation.
- Benches/furnishing are snap-to-socket visuals, not full freeform furniture physics.
- No region's gameplay assumes unavailable interiors.
- The game can pass W01 playable QA even with visibly marked placeholder art; FINAL ART PASS requires accepted real sources, not a pretty concept PNG.