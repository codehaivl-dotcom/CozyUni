# CozyUni Asset Generation — Source of Truth v3

Status: **CANONICAL POINTER**

## 1. Base asset generation authority

For the original character/world/five-game ready-generation queue, use:

`docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md`

It remains canonical for:
- the 20 characters;
- the 296 base world/library assets;
- the 15 additional unique five-game assets;
- the exact base prompt assembly contract;
- Style Lock/category templates;
- game reuse map;
- completion checkboxes.

Do not use `03_WORLD_ASSET_PRODUCTION_MASTER.md` as a prompt source. It is planning/history only.

## 2. Modular world generation authority

For reusable snap/assembly world pieces, use:

`docs/assets/05_MODULAR_WORLD_KIT_MASTER.md`

This is the canonical inventory for modular ground/path/road/curb/plaza/rock/cliff/stair/fence/bridge/harbor/rail/garden/terrain-detail pieces.

These modules extend the asset library; they do not replace the 04 queue.

## 3. Batch-sheet optimization authority

For **small modular pieces only**, the generation agent may use:

`docs/assets/06_MODULAR_WORLD_KIT_BATCH_SHEETS.md`

06 is a batching/credit-saving layer on top of 05.

Rules:
- batch only approved small compatible families;
- obey 4–8 item maximum and sheet layout rules;
- batching does not merge independent runtime assets permanently;
- resulting 3D pieces still require individual production QA/import acceptance where they are used separately;
- complex/hero assets remain one image per asset.

## 4. Shared render/style authority

All generation routes obey:

`docs/assets/00_RENDER_RULES_LOCKED.md`

The local agent must attach the approved CozyUni reference image required by the relevant generation contract.

If a required reference image is unavailable, STOP with:

`MISSING_REFERENCE`

Do not substitute text-only generation when the contract requires an attached reference.

## 5. Prompt discipline

- Do not invent or paraphrase canonical item prompts during base 04 generation.
- For 05/06 modular generation, use the exact item/family names and the locked modular/style wrapper defined in those files.
- Do not add extra scenery, props or adjectives that materially alter the requested asset family.
- Never render a whole world/map reference as one 3D asset.

## 6. 3D conversion / Tripo execution authority

For actual Tripo API execution, use:

`docs/assets/07_TRIPO_API_V3_EXECUTION.md`

Repository helper:

`tools/tripo_v3.py`

Hard rules:
- official current Tripo developer docs are the external authority for endpoint/task/request/response semantics;
- the repository pins the admitted MVP route/model/settings in 07 so an agent does not select a model ad hoc;
- `TRIPO_API_KEY` is local environment state only and must never be committed;
- billable `generate` is dry-run unless `--execute` is explicitly supplied;
- a valid key does not authorize bulk rendering;
- only assets admitted by the active MVP execution step may consume generation credits;
- record generation log per asset/task;
- `TRIPO_DOC_MISMATCH` => STOP.

The active render budget and step admission authority remain:

`docs/MVP_EXECUTION_PLAYBOOK.md`
`docs/data/mvp_execution_v1.json`

## 7. Completion rule

Do not mark an asset/module complete until all applicable stages pass:
1. concept/render visual acceptance;
2. 3D generation acceptance;
3. technical mesh/material/texture QA;
4. Godot import scale/pivot/material check;
5. collision/performance check where relevant;
6. gameplay/world-camera visual acceptance.

An accepted concept image alone is not a finished production asset.
