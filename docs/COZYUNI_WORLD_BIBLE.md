# CozyUni — Living World Bible v1.0

**ACTIVE WORLD-FIRST VISION / 2026-10-11.** A genuinely playable world takes precedence over the historical board-game collection.

## Fantasy
CozyUni is a lively 3D neighborhood of anthropomorphic animals, natural spaces and comforting stories. The village is already inhabited, not broken/abandoned; players add their own mark by exploring, meeting residents, gardening, photographing moments, beautifying public spots and expanding a home plot. **Every little action leaves a visible, persistent trace.**

Core pillars: (1) *Explore real places* with free walking; (2) *Meet real residents* with small time-of-day behaviors and dialogue; (3) *Make memories* through gardening/photo/album/public projects; (4) *Make space your own* through earned coin land purchase and modular building. No board/grid movement except the optional 2m building overlay while editing a parcel.

## Canonical cast
Twenty characters `CHR-001..CHR-020` in `docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md` and gameplay roles in `docs/world/living_world/05_CHARACTER_ROSTER_20.md`; their designs already exist. The actual rigged/runtime models must be verified locally and individually. No additional character generation until audit proves a real need. Avoid duplicating the selected avatar as another NPC.

## Connected geography
- **W01 Moonberry Village**: shops, Town Hall and plaza, garden, social park, homes, expandable personal parcel pocket — primary playable game.
- **W02 Countryside / Farm**: orchard and garden/homestead moments (later).
- **W03 Woodland / Meadow**: forest/trail/photo discoveries (later).
- **W04 Lake / Riverside**: boardwalk, dock and waterside ecology (later).
- **W05 Town / Urban Quarter**: market, library, railway and civic life (later).
- **W06 Harbor / Seaside**: ferry, lighthouse, marina and tide/water views (later).
- **W07 Mountain / Cable Car**: climb, lookout and lodge (later).
- **W08 Resort / Tourist District**: leisure, postcards, festival and trip memories (later).

Regions use the same cast, Album/save/build style; they must introduce different things to do. Existing route/sightline guidelines remain `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`. The new playable content and future activities are mapped in `docs/world/living_world/03_REGIONS_AND_ASSET_PLAN.md`.

## World building constraints
Public town geometry, roads, Town Hall, shop entrances and NPC routes are authored/immutable; player owns only their bounded P00–P03 Residential pocket. Starter 8×8m land plus three adjacent lots purchasable with *earned* VC; Godot owns 2m structural snapping, terrain and collision. Reuse accepted AST props; no one-GLB infinite dioramas. The home plot can change safely without blocking roads or losing purchases.

## Style and production reality
Style D: clean warm stylized game-ready 3D, restrained pastels, rich but readable painted wood/stone/foliage, shapes distinct between buildings; no noisy toy plastic/monochrome clay. Asset candidates are not automatically production binaries. H0–H6 render/import/rights gates remain binding, as do touch/camera/performance checks. W02–W08 are not claimed built merely because their asset slots are cataloged.

## Boundaries
First world release is single-player/offline-first, W01 only; no MMO, multiplayer land visits, online accounts, forced daily login, paywall for land, full interior/housing economy or five-board menu. Historical board sources remain archived for possible future independent reactivation.
