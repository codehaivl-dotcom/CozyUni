# CozyUni — Living World Production Design Pack v1.2

**User directions as of 2026-10-11:** abandon board-game-first shipping; world gameplay is main; preserve canonical 20-character cast; **allow players to buy adjoining land and construct a personal modular world pocket**.

This is the **world-first gameplay design package in the repository**, not evidence of an already playable Godot build. Former board docs and tests are preserved. Current world production follows `docs/data/world_execution_v1.json`. Tripo harvest remains pre-spend gated; the 296 AST entries are not 296 verified GLBs.

## Reading order
1. `00_READ_FIRST.md` — authority and promises
2. `05_CHARACTER_ROSTER_20.md` — all twenty actual canonical character IDs
3. `01_WORLD_GAMEPLAY_GDD.md` — the game
4. `02_W01_PLAYABLE_SLICE.md` — chapter 1 and M01–M07
5. `06_LAND_EXPANSION_MODULAR_BUILDING.md` — buy/build mechanics
6. `07_W01_BUILD_PIECES_AND_PLOT_LAYOUT.md` — parcel topology and existing IDs
7. `03_REGIONS_AND_ASSET_PLAN.md` — eight-region growth and render budget
8. `04_REPO_MIGRATION_AND_AGENT_ORDER.md` — coordinated authority change and implementation sequence

## Major v1.2 additions
- First owned **8×8m plot**, three adjacent purchasable plots, 2m snap, up to 256m² personal space in **the first playable test**. Longer-term: 12-contiguous-parcel microdistrict with placeable prefabricated houses/shops and region-themed building pockets after acceptance gates.
- One lightweight earned-only land currency (Village Coins), guaranteed first purchase without grinding.
- No real-money gating, unrestricted terrain hacking, fake made-up AST IDs or duplicated character generation.
- Verified canonical AST IDs (fences, bench, planter, trees etc.) mapped to modular placement; terrain/path structural base engine-built at zero 3D credits.
- Added missing `05_CHARACTER_ROSTER_20.md` that v1.1 referenced but had not actually included.