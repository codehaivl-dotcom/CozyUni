# CozyUni — Production Master Plan v2.0: Living World First

**ACTIVE / DESIGN LOCK / NOT YET IMPLEMENTED OR RELEASE-CLEARED — 2026-10-11.** User decision supersedes old Ludo-to-Tycoon shipping sequence. Board code/GDD/test assets stay untouched and archived.

## Definition of the game
Ship W01 Moonberry as a **living-world game**: boot into world, walk freely, meet Pip/Poppy/Milo/Lumi/Finn, plant and water, photograph three places, help decorate the community, earn 100 Village Coins through M01–M03, purchase adjacent 8×8m land, paint ground, place/move/store modular props, see NPC/world reactions, save and return.

Specific gameplay/content: `docs/world/living_world/01_WORLD_GAMEPLAY_GDD.md`, `02_W01_PLAYABLE_SLICE.md`. Character roster `05_CHARACTER_ROSTER_20.md`. Land systems `06_LAND_EXPANSION_MODULAR_BUILDING.md` and `07_W01_BUILD_PIECES_AND_PLOT_LAYOUT.md`. New startup UI `08_WORLD_APP_FLOW.md`.

## Execution gate — only one active next step
The only active work graph is `docs/data/world_execution_v1.json`: WORLD-00 (authority & world home) → WORLD-01 (W01 walkable) → WORLD-02 (resident/garden) → WORLD-03 (photo/Album) → WORLD-04 (decor/save) → WORLD-04B (land purchase/build) → WORLD-05 (resident rhythms/chapter) → WORLD-06 (20-character source/rig proof) → WORLD-07 (accepted art) → WORLD-08 (usability/performance) → WORLD-09 (market-test W01 package).

Each agent runs `INSPECT → ONE READY STEP → IMPLEMENT → TEST → EVIDENCE → REVIEW → MARK PASS/NEXT READY → STOP`. Old `docs/data/mvp_execution_v1.json` validates historical board work only and never grants new production permission. Preserve unrelated dirty work.

## Asset policy (no invented spending)
Existing 150 AST slots grouped A48/B52/C25/D15/E10 are acquisition candidates, **not** automatically approved calls. The 296 AST + 296 modular catalog lists are specifications, not proof that exported GLB binaries exist. 20 CHR canon does not prove all rig/animation imports passed. Verify local files, provenance, rights and hashes. H0 account rights/references/balance, H1 actual W01 scene anchors, H2 asset round-trip, H3 frozen disposition manifest must PASS before any billable queue. H4–H6 quality/buildability remain. Zero paid generation through WORLD-05 and WORLD-04B. `PARK_LUDO` may remain only as a legacy semantic scene identifier for the **social park**.

Terrain, 2m snap grid, roads, collision, navigation and ground materials are Godot authored; visible AST/MOD are reusable decoration/skins validated on import. Do not generate entire lots/maps as one model. Child-safe world input and tablet-camera QA remain from engineering docs.

## Quality gate
A new player can complete W01 M01–M03, earn exactly 100 VC, buy P01 or P02 **once** for 100 VC, walk the parcel, arrange 2 props, photograph and store Album entries, exit/reload twice with unchanged ownership, layout, inventory, coins and residents. Routes and NPC entrance access must not be blocked. Test duplicate purchase/placement, double tap and unavailable art fallback. Later region authorization depends on W01 real play/revisit evidence.

**Out of scope:** active Ludo/Caro/Journey/Chess/Tycoon implementation, board menu, online multiplayer, purchasable real-money land, full interior/editor, huge farming economics, combat, speculative regional render batch.
