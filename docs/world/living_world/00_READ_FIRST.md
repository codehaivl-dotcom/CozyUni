# CozyUni — Living World Gameplay Pivot v1.2 (20 characters + expandable player land)

**User product decision:** 2026-10-11. Primary game = original, freely explorable cozy world. Cozy Ludo/Caro/Journey/Chess/Tycoon are **no longer active production goals**. Existing game code and GDDs are archived/preserved, not deleted.

**Document status:** ACTIVE WORLD-FIRST GAMEPLAY DESIGN AUTHORITY (2026-10-11). Production implementation and asset readiness still require real build/QA evidence.

## Read these documents in this order
1. `05_CHARACTER_ROSTER_20.md` — the 20 canonical characters; definition vs confirmed mesh/rig is tracked separately.
2. `01_WORLD_GAMEPLAY_GDD.md` — what players do and why it is fun.
3. `02_W01_PLAYABLE_SLICE.md` — exact first playable experience, NPCs, quests, unlocks and acceptance.
4. `03_REGIONS_AND_ASSET_PLAN.md` — how all 8 world regions grow from existing catalog/asset bank.
5. `06_LAND_EXPANSION_MODULAR_BUILDING.md` — own land, buy adjacent plots with earned in-game money, snap-piece building and hard map rules.
6. `07_W01_BUILD_PIECES_AND_PLOT_LAYOUT.md` — W01 build zone sketch, placement repertoire, economy and acceptance.
7. `04_REPO_MIGRATION_AND_AGENT_ORDER.md` — how to replace outdated authority without corrupting the current project.

## Core game promise
A resident comes to Moonberry Village and gradually creates a place that feels like home. The player **walks freely**, discovers moments and residents, takes part in hands-on cozy activities, makes small choices about shared spaces, builds a photo/experience journal, and sees the village change persistently. Each region unlocks a different reason to explore, not just new scenery.

**Not a board game; not a delivery simulator; not a five-minigame menu; not an MMO; not a huge farming clone.**

**User-added core pillar (2026-10-11):** player owns a small plot, can **buy adjoining land with earned Village Coins** and combine modular garden/road/fence/landscape pieces into their own cozy neighborhood. This is *not* a paid real-money land gate or a freeform infinite-map simulator. Details in 06/07.

## Design pillars
1. **The world responds.** Completing an activity changes the scene, resident behavior, dialogue or a home/public decoration.
2. **Small actions are satisfying.** Gardening, photographing, community decorating and chatting each have an interaction with input/choice/feedback, not just one invisible quest counter.
3. **Go at your own pace.** No energy meter, forced daily login, combat, timers for punishment, pay-to-progress or punishing failure.
4. **People matter.** Familiar residents have locations, simple daily routines, stories and personalized returns.
5. **Make room for yourself.** Every land purchase physically enlarges the player-owned building zone; player chooses its layout and can rebuild without losing purchased land.
6. **Assets have a job.** An object is made for a camera view, route, interaction, recognizable landmark or repeatable decoration. No paid render because an ID slot happens to exist.

## 20-character production truth
The official master defines exactly **CHR-001..CHR-020**. The user has confirmed this cast already exists: do not commission any new character design/model on the premise that it is missing. Distinguish 20 **canonical character definitions** from individual source GLBs, rigs, animations and Godot-ready wrappers; remote GitHub does not prove those binary states. Complete the 20-row local audit before proposing character regeneration. For W01, 1 controlled character + 19 possible NPCs, not 20 NPCs plus the player. See `05_CHARACTER_ROSTER_20.md`.

## Source provenance
Read from GitHub `codehaivl-dotcom/CozyUni` (main) on 2026-10-11: `AGENTS.md`; `docs/COZYUNI_WORLD_BIBLE.md`; `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`; `docs/PRODUCTION_MASTER_PLAN.md`; `docs/assets/09_WORLD_ASSET_PRODUCTION_LOCK.md`; `docs/data/world_asset_production_lock_v1.json`; `docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md`; `docs/engineering/03_INPUT_CAMERA_UI_TECH_SPEC.md`; and asset inventory evidence.

The 296 AST names are a **catalog**, the 150 are **planning slots**, not 150 confirmed imported GLBs. GitHub main does not show the tracked production 3D bank. Some accepted GLBs may exist in a local agent workspace; they must be verified individually before reuse.