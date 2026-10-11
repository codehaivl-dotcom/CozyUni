# CozyUni — Product Strategy v1.0: Living World First

**ACTIVE as of 2026-10-11.** The user changed CozyUni from board-game-first to an original **3D cozy living-world** game. This file supersedes prior Game Library / Ludo shipping priorities. Preserve their source/data/tests as history; do not extend or delete them as part of this pivot.

## Product promise
Freely explore Moonberry as a beloved animal resident; meet locals; plant, photograph, improve public spaces, create album memories, **earn Village Coins and buy adjoining land to build a personal cozy neighborhood**. Actions change the visible world and persist. CozyUni is neither a 20-node board nor an empty environment gallery.

World loop: **Explore → encounter a resident/landmark → tactile activity (garden/photo/chat/decor) → persistent Album/world reward → Village Coins → purchase adjacent 8×8m land → snap-build with reusable modules → revisit**.

## First playable release
Only **W01 Moonberry Village**, using the existing seven semantic scene zones: entrance, main street, square, town hall, shop street, social park (old internal name PARK_LUDO), residential. W01 includes M01–M07 story, 5 active NPCs plus one controllable canonical character, day phase, community garden, photo Album, decor and player property. Personal plots: P00 owned plus three purchasable 8×8m connected lots; 2m grid *inside Build Mode only*, ordinary movement remains free walking. Prices first/second/third: 100/150/250 **earned Village Coins**.

## Identity and future
Keep 20 already-defined CHR-001..CHR-020 characters (model/rig proof separately audited). World has eight previously designed regions W01–W08; W02–W08 wait for W01 replayability and technical evidence. Style D, the 296 AST master and vetted 150-slot inventory are retained, not regenerated mechanically. Never confuse catalog with shipped GLB files. No commercial-use claim before rights preflight.

Single-player/offline-first W01; no forced daily login, combat, pay-to-open-land, board game, arbitrary player-authored infinite terrain or MMO. Existing premium Cozy Credits and commerce code remain dormant; land purchase uses separate **earned-only** Village Coins.

## Active authority
`docs/world/living_world/README.md` and `docs/data/world_execution_v1.json` own implementation content and sequence. `docs/PRODUCTION_MASTER_PLAN.md` owns gates. `docs/assets/09_WORLD_ASSET_PRODUCTION_LOCK.md` retains the H0–H6 rights/render/import safety contract. Shippability requires actual Godot input-to-save tests and user playtesting, not documentation alone.
