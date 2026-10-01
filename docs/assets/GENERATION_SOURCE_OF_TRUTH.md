# CozyUni Asset Generation — Source of Truth

Status: **CANONICAL POINTER**

For local AI asset generation, use only:

`docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md`

Rules:
- `04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md` is the canonical ready-gen queue.
- It contains the complete 20-character + 296 base world/library + 15 additional unique five-game asset list.
- It also contains the exact prompt assembly contract, STYLE_LOCK, category templates, five-game reuse map, and checkboxes.
- The local agent must attach the approved reference image required by that file to every generation request.
- Do not use `03_WORLD_ASSET_PRODUCTION_MASTER.md` as a prompt source. It is retained as planning/history only.
- Do not invent or rewrite prompts during generation.
- Do not mark an item complete until the result is visually accepted against the approved reference image.
