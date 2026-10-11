# CozyUni — Canonical 20-Character Roster / World Assignment (v1.2)

**Grounding:** `docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md` in GitHub `main` defines CHR-001 to CHR-020. User confirms the twenty characters are already created. **Do not render/create new characters on that basis.** The current remote repository does NOT prove a source GLB, accepted rig or animation for each. Agent must verify actual local files before planning import work.

**Roles and region proposals below are NEW GAME DESIGN** (not pre-existing character lore). Casting can change through explicit game-design revision, not automatic agent improvisation. All 20 cast IDs are retained, none is deleted.

| Canon ID | Canon name | Display | Proposed region/capacity | First meaningful gameplay use |
|---|---|---|---|---|
| `CHR-001` | Miko Rabbit | Miko | W01 starter player | default avatar; idle/walk/talk/plant/build; not spawned as duplicate NPC when selected |
| `CHR-002` | Poppy Bear | Poppy | W01 NPC | bakery greeting and picnic/café moment |
| `CHR-003` | Milo Dog | Milo | W01 NPC | photo trail and photography hints |
| `CHR-004` | Lumi Cat | Lumi | W01 NPC | flower shop and garden mentor |
| `CHR-005` | Finn Fox | Finn | W01 NPC | park and public decoration guidance |
| `CHR-006` | Pip Hedgehog | Pip | W01 NPC | mayor; story intro, land deed, evening gathering |
| `CHR-007` | Nori Duck | Nori | W04/W06 proposal | lakeside / waterside gathering; no current W01 quest dependency |
| `CHR-008` | Clover Lamb | Clover | W02 proposal | orchard/community tending |
| `CHR-009` | Toby Puppy | Toby | W01 later ambient proposal | residential visitor and welcome reactions |
| `CHR-010` | Koko Koala | Koko | W03 proposal | woodland lookout and observation |
| `CHR-011` | Bao Panda | Bao | W05 proposal | library/civic exchange |
| `CHR-012` | Otti Otter | Otti | W04/W06 proposal | shoreline and pier observation |
| `CHR-013` | Hazel Deer | Hazel | W03 proposal | meadow/botanical photo moments |
| `CHR-014` | Remy Raccoon | Remy | W05 proposal | market sorting/showcase |
| `CHR-015` | Sora Squirrel | Sora | W03 proposal | tree/woodland discovery |
| `CHR-016` | Bibi Frog | Bibi | W04 proposal | pond nature story |
| `CHR-017` | Runa Red Panda | Runa | W07 proposal | mountain lookout / lodge moments |
| `CHR-018` | Mochi Mouse | Mochi | W01 later ambient proposal | photo booth / collecting album; after W01 core passes |
| `CHR-019` | Peaches Piglet | Peaches | W02 proposal | farm garden gathering |
| `CHR-020` | Olive Owl | Olive | W07 proposal | mountain observations / evening lookout |

## Implementation truth table

Keep an inventory **one row per CHR** with exact source concept PNG path/hash, model GLB path/hash, rig availability, tested animation clips, final Godot wrapper, materials/licensing status and import test result. Status must be `DEFINED`, `MODEL_VERIFIED`, `RIG_VERIFIED`, `RUNTIME_ACCEPTED` or `BLOCKED`. Do **not** infer RIG_VERIFIED from a beautiful still screenshot.

W01 first playable: Miko as player and 5 named NPCs (Pip/Poppy/Milo/Lumi/Finn). Other 14 characters stay in the universe roster and get **distinct region/story jobs**, rather than being parked together in Moonberry Square. When another CHR is selected as player, do not spawn that same character identity again as a full NPC without a deliberate duplicate-identity rule.

**Rig reuse:** try one shared locomotion set and retarget where anatomy permits, but separately test tail/wings/ears and limb deformation per source. All twenty characters must be audited before calling the entire character bank production-ready.