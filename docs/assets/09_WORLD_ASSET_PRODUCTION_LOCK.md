# CozyUni — World Asset Production Lock v1.0

**Authority:** CURRENT / PRE-SPEND PRODUCTION CONTRACT
**Decision date:** 2026-10-11
**State:** `SPEC_LOCKED_PRESPEND_GATES_PENDING`. **No paid Tripo queue has been authorized by this document alone.**
**English technical field names + Vietnamese instructions are intentional.**

## 1. Product decision — Why this world exists

CozyUni is **a cozy social world built around playing together**, not an eight-map art gallery.

One player-facing loop must be feasible without inventing new game rules:

```text
Spawn in Moonberry
 -> meet recognizable residents in the square
 -> perform two low-friction non-board activities
 -> gain/save one visible persistent cosmetic or decoration
 -> play Cozy Ludo directly or at a physical venue
 -> return with state intact
 -> discover a reason to revisit
```

**No forced walking to launch Ludo.** The five games keep independent Game Library entry.

During expiring-credit harvest, only the *asset acquisition* is accelerated. Deep life-sim features are not claimed complete. Asset classes are selected to support future interactions: venue, resident gathering, home, gardening, café, fishing, photo/festival.

### Product quality gate

World expansion is **not** justified by scenery alone. After Moonberry integration, human evaluation must establish exploration, activity clarity, retained world state, and a desire to revisit. W02–W08 landmark assets may be banked during credit expiry without declaring those regions produced.

## 2. Authority order and concrete artifacts

1. This document — operational production/assembly gates.
2. `docs/data/world_asset_production_lock_v1.json` — exact 150 ID registry / Stage A 48 ID baseline.
3. `docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md` — canonical per-ID ITEM and T template; prompts must not be paraphrased.
4. `docs/assets/00_RENDER_RULES_LOCKED.md` and `References/CozyUni_STYLE_LOCK.png` — Style D authority.
5. `docs/engineering/02_ASSET_IMPORT_AND_WORLD_ASSEMBLY.md`, `04_PERFORMANCE_BUDGETS.md` — import and runtime.
6. `docs/assets/07_TRIPO_API_V3_EXECUTION.md` — API code route.
7. `docs/assets/08_WORLD_ASSET_HARVEST_PLAN.md` — budget strategy.
8. `docs/world/00_WORLD_VISUAL_MVP_LOCK.md` — region identity/route topology.

**Do not use invented IDs.** IDs in the registry are present in 04. No random concept prompts or surprise additions. Every billable task requires a single approved source image associated with an ID.

## 3. What is frozen vs not yet verified

**Frozen decisions:**
- single connected-world identity, W01 as first usable pack;
- 150 selected, distinct canonical ID slots grouped A48/B52/C25/D15/E10;
- per-ID canonical name, ITEM text, model/profile, target envelope, placement purpose and wrapper path;
- Style D target;
- one isolated 3D object per paid image-to-model task;
- engine-built structural truth for grid/terrain/paths/functional snapping;
- Godot 4.7.2 Mobile renderer, 1 unit = 1 m, Y up;
- P1-20260311, 5k/10k/20k face profiles, detailed texture planning cost 60 credits;
- W01 zones `ENTRANCE`, `MAIN_STREET`, `SQUARE`, `SQUARE_TOWN_HALL`, `SHOP_STREET`, `PARK_LUDO`, `RESIDENTIAL`.

**Not yet evidenced in GitHub main as of this audit:**
- actual `References/CozyUni_STYLE_LOCK.png` file (References README exists, required PNG does not);
- canonical W01 A Hero/B Layout image files;
- the claimed S01–S05 Godot scene/wrappers/source GLBs (reported in local agent history, not confirmed in remote `main`);
- live API balance, expiry timestamp and paid/free commercial entitlement;
- exact W01 anchor transforms from a measurable scene.

The agent must **not treat an absent file or a previous chat report as evidence**. It may inspect its explicitly accessible local copy for these files and record hashes/paths, but cannot claim that remote GitHub has them without a verified commit.

## 4. Mandatory H0–H6 gates

### H0 — Rights, reference, account and workspace preflight: 0 spend

Create:
- `evidence/asset-harvest/H0_SOURCE_RIGHTS_AND_BALANCE.md`
- `evidence/asset-harvest/H0_INPUT_INVENTORY.csv`

Evidence must include:
- live `GET /v3/account/balance` with decimal `balance` and `frozen`, redacted screenshot/log;
- exact *date and timezone* when promo credits expire, verified from account notice/console (do not infer);
- account tier and **specific API promo credits commercial-use eligibility**, record governing Tripo terms version and evidence;
- ownership/license of every input concept reference including borrowed meshes;
- the Style Lock PNG path and SHA-256; if absent `MISSING_REFERENCE`;
- paths/hashes for accepted existing AST-071, AST-285, AST-091, AST-094, AST-099 (S04/S05 reuse reported but not confirmed on remote);
- confirmation of S01–S05 acceptance tests on the actually available working tree;
- `git status`, branch, commit and a plan to preserve dirty work.

Tripo's own free-tier help says commercial rights are **not automatically granted** to Free Users. Promotional *API credits* and account subscription rights must be verified separately; this doc neither asserts free credit output is commercially safe nor presumes a paid plan.

**If rights are unclear:** record `LICENSE_PENDING`, do not mark `SHIPPING_CLEARED`. Do not spend the complete bank budget as if production licensing is settled; escalate this one external legal entitlement fact.

**If account/balance/expiry unknown:** no billable queue.

### H1 — W01 scene assembly and anchor lock: 0 spend

Before any paid bulk generation, prove that there is a real Godot W01 base or create a blockout from the already locked topology (without render credits).

Mandatory existing or new scene: `scenes/world/MoonberryVillage.tscn` (or document a verified canonical replacement path).

Create `evidence/asset-harvest/H1_W01_ANCHOR_LOCK.json`. It must be **measured from the actual scene**, not invented:

```json
{
  "scene_path": "res://scenes/world/MoonberryVillage.tscn",
  "commit_sha": "<actual checked-out sha>",
  "unit_m": 1,
  "route_length_m": 127.0,
  "traversal_s": 84.08,
  "anchors": {
    "ENTRANCE": {"node_path":"...", "transform3d":"..."},
    "MAIN_STREET": {"node_path":"...", "transform3d":"..."},
    "SQUARE": {"node_path":"...", "transform3d":"..."},
    "SQUARE_TOWN_HALL": {"node_path":"...", "transform3d":"..."},
    "SHOP_STREET": {"node_path":"...", "transform3d":"..."},
    "PARK_LUDO": {"node_path":"...", "transform3d":"..."},
    "RESIDENTIAL": {"node_path":"...", "transform3d":"..."}
  }
}
```

The example ellipses are **schema documentation only**, never acceptable final data. Agent must populate actual measured values and validate every node path and transform.

Required world-to-Ludo route, player/camera/collision flow and deterministic return must be runnable. When preserving the existing route, keep its 127 m / 84.08 s benchmark. If no existing scene or route exists, create/test a replacement **before** authorizing mass generation; report the new measured route truth rather than fabricating the old measurement.

### H2 — One final mesh proves integration: 0 new calls if reusable

Use an **already accepted** GLB (prefer AST-091 or AST-285) to prove:

```text
source GLB -> import preset -> reusable wrapper tscn -> anchor placement ->
ground contact -> collision -> working route -> canonical camera ->
desktop comparative metrics -> deterministic Godot reopen/reimport
```

Do NOT spend a new call to prove the pipeline if an accepted source is available. Do not infer mesh suitability from a PNG.

### H3 — Freeze Stage A manifest: 0 spend

The 48 A registry entries are **production slots**, not 48 automatic Tripo calls.

Each slot must have exactly one disposition after local inspection:
- `REUSE_ACCEPTED`;
- `GENERATE_APPROVED`;
- `ENGINE_BUILT` (exclude 3D call, preserve design);
- `DEFER_NONCRITICAL`;
- `BLOCKED`.

For `GENERATE_APPROVED`, require:
- approved concept source path and SHA-256;
- exact 04 template + ITEM + Style Lock composition;
- intended anchor;
- source rights;
- intended width/depth/height from registry;
- Tripo model/profile/cost;
- collision policy;
- target wrapper path;
- acceptance camera.

Create frozen, reviewed `evidence/asset-harvest/WORLD_ASSET_HARVEST_MANIFEST.csv`. Never confuse a row with a paid generation count.

### H4 — Billable execution: ONLY approved rows

Order: **A -> B -> C -> D -> E**. Do not advance solely on call count. Reused A slots release credit to B/C.

Use `tools/tripo_v3.py` only. Default is dry-run, actual execution needs `--execute`. Concurrency **<=3 P-series generation tasks**, and use the helper's actual capabilities; do not invent queue or bulk CLI commands.

Per billable task: balance -> source hash -> dry-run exact request -> create task -> persist task ID **immediately** -> poll -> recover/download immediately -> SHA-256 -> usage/ledger -> quick QA -> proceed.

A task that succeeded but failed to download must be recovered with the **existing task ID**, never recharged.

Tripo API docs indicate output URLs expire quickly (around 5 minutes): store a local durable artifact, not merely a CDN URL.

Cost planning:
- `P1-20260311`, image-to-model: no texture 40 / standard 50 / detailed 60 credits.
- Face profiles: small 5,000, common 10,000, hero 20,000 (faces; verify resulting triangles in GLB).
- P2 is **not authorized** by this contract; it has different supported features and higher pricing. A deliberate model change requires separate A/B approval.
- Decimal `balance`, `frozen`, `credits_consumed` are not integer-only.

The 9,000 / 150 arithmetic is only a scenario, not a proof that today's actual balance affords 150 new detailed jobs.

### H5 — Recoverable and usable output QA

Every billable output has:
- original full GLB and its SHA-256;
- approved concept/source;
- task ID, provider response, charge, timestamps;
- asset ID;
- inspectable geometry/material/UV/texture data;
- correct scale target, ground pivot and forward/up;
- no major fused unwanted background geometry;
- collision and wrapper policy;
- `BANK_ACCEPTED`, `RUNTIME_ACCEPTED`, `REJECTED`, or `LICENSE_PENDING` separately.

`BANK_ACCEPTED` ≠ ready for scene use; `RUNTIME_ACCEPTED` ≠ cleared for paid distribution.

Keep original GLB; make optimized runtime derivatives without overwriting source.

### H6 — Moonberry pack buildability gate (before remaining credit burn)

After Stage A approved slots are complete, assemble W01 into a coherent real scene:

- recognizable arrival/entrance, main street, plaza and Town Hall, shop street, residential framing, park and Ludo venue;
- 4 structurally distinct residences;
- accepted buildings correctly grounded with entrance facing routes;
- readable SQUARE → SHOP_STREET → PARK_LUDO camera vistas;
- no collision/nav regression;
- Library -> W01 -> Ludo -> Results -> W01 repeat test green;
- no missing source asset in the required acceptance views;
- QA import/boot/smoke passing;
- desktop before/after scene metrics, native iPad A14 evidence required for release certification, not to freeze source bank.

**Do not open Stage D expansion if H6 fails due incomplete W01 buildability.** Stage B/C can continue for reusable foundational gaps. Stage A can use runtime placeholders only when explicitly documented as such; no false final-art PASS.

## 5. The 150-ID registry — production, not quota

`docs/data/world_asset_production_lock_v1.json` contains exactly:
- A: 48 W01 exterior slots;
- B: 52 shared/environment/farm/harbor supporting slots;
- C: 25 activities/social supporting slots;
- D: 15 future-region hero slots;
- E: 10 optional recovery/quality variants.

Every ID is grounded in the canonical 296-AST catalog. The registry includes the full canonical ITEM phrase, template code, specific per-slot stage and class, Stage A placement zone, footprint target, collision policy, P1 profile and target file names.

**Do not mechanically generate every row.** Preserve good existing AST-071/285/091/094/099 and other acceptable assets. Any released budget is used on the next approved useful row.

For every slot, generate **one independent GLB**, not a multiple-object contact sheet converted into one inseparable model. A contact sheet may assist human concept review, but it is NOT a promise that one Tripo 3D call outputs multiple separable assets.

## 6. Geometry and assembly lock

### Coordinate conventions
- Godot units: 1 = 1 meter.
- +Y is up.
- Mesh wrapper origin: bottom center on ground plane.
- Visual pivot/forward orientation must be normalized in wrapper, never corrected randomly per scene instance.
- Scene anchor location is authoritative from H1. W01 accepted assets are **not** relocated to fit new outputs.

### Building target envelopes
Per-ID `footprint_contract_m` in the JSON is the intended **bounding envelope** (width X, depth Z, height Y), not an assertion about Tripo's raw GLB dimensions.

Do not assume Tripo `auto_size` yields exact doors/steps. Normalize wrapper bounds and test relative to the canonical player before acceptance.

Entrances remain engine-side interaction anchors, not image-generated text/doors the engine assumes are functional.

### Precise snap geometry — engine-built first
Do **not** use a single-view Tripo mesh as source of truth for exact mechanical tolerances.

Freeze this grid as a new design decision for **new** structural module families only; existing accepted W01 topology/walkability takes precedence:

| Component | Structural constraint |
|---|---|
| snap grid | 2.0 m horizontal |
| standard sidewalk/path bay | 2.0 m width |
| wider plaza connector | 4.0 m width |
| new fence structural bay | 2.0 m end-to-end |
| new rail/curb structural bay | 2.0 m |
| stairs | total rise/run per authored Godot segment, step rise 0.15 m, run 0.30 m, do not trust mesh footsteps for nav |
| pedestrian bridge | 2.0 m clear walk width, engine-defined endpoints |

These are **design constraints for future modules**, not measured descriptions of existing imported models.

Create structural walkable path, ramp, collision, nav and snap endpoints in Godot. Generated Tripo skins must fit as **decorative cladding/standalone visuals** with no hidden navigation dependency.

If a source cannot fit its structural wrapper without deforming recognizable form, reject or remap to a non-functional decor role. Do not rescale every instance ad hoc.

### Collision map
`BUILDING_SIMPLIFIED`: simple structural volumes + walkable entrance opening.

`TRUNK_ONLY`: one trunk primitive; no collision on leafy crown.

`NO_COLLISION`: default for tiny decor, foliage cluster, signs and particles.

`SIMPLE_PRIMITIVE[_IF_BLOCKING]`: cheap intentional world collider only.

No automatic concave/trimesh collision for repeated scenery.

### Performance
Respect `docs/engineering/04_PERFORMANCE_BUDGETS.md`.

World normal camera: <=1.5M visible tris preferred, >2.0M warning; <=700 draw calls, <=900 hero; textures in one loaded region comfortably below 512MB; release A14 P95/memory certification as separately gated.

LOD, MultiMesh and texture atlasing should be decided after seeing real camera costs; do not claim 20k faces automatically equals 20k tris or that low-poly means good visuals.

## 7. Files and evidence contracts

Under local working copy:

```text
References/CozyUni_STYLE_LOCK.png
References/World/W01_Moonberry_Village_A_Hero.png
References/World/W01_Moonberry_Village_B_Layout.png
assets/production/world/<AST-ID>/source/<AST-ID>.glb
scenes/assets/world/<AST-ID>.tscn
evidence/asset-harvest/H0_SOURCE_RIGHTS_AND_BALANCE.md
evidence/asset-harvest/H0_INPUT_INVENTORY.csv
evidence/asset-harvest/H1_W01_ANCHOR_LOCK.json
evidence/asset-harvest/WORLD_ASSET_HARVEST_MANIFEST.csv
evidence/asset-harvest/TRIPO_HARVEST_LEDGER.md
evidence/asset-harvest/H6_W01_BUILDABILITY_REPORT.md
```

If assets are too large for normal Git, use documented Git LFS/artifact storage and commit an immutable manifest with hashes and resolvable URLs. Do not commit dead temporary CDN links. An asset existing only on an unavailable local machine is not a production deliverable.

## 8. Failure policy and execution verdict

Possible top-level states:
- `SPEC_LOCKED_PRESPEND_GATES_PENDING`
- `READY_TO_EXECUTE_STAGE_A`
- `STAGE_A_IN_PROGRESS`
- `H6_BUILDABILITY_PASS`
- `BANK_HARVEST_COMPLETE`
- `BLOCKED`

Stop codes:
- `MISSING_REFERENCE`, `MISSING_SCENE`, `MISSING_SOURCE_RIGHTS`, `LICENSE_PENDING`,
- `NO_ACCEPTED_SOURCE`, `ANCHOR_LOCK_MISSING`, `MANIFEST_UNFROZEN`,
- `TRIPO_KEY_MISSING`, `TRIPO_DOC_MISMATCH`, `BALANCE_UNKNOWN`,
- `RECOVERY_FAILURE`, `IMPORT_FAIL`, `BUILDABILITY_FAIL`.

**Present status:** documentation/registry selection is frozen. Source files, actual scene anchors, live account/licensing, batch manifest approval and runtime test evidence still must be verified. Therefore **no claim of "READY_TO_RENDER" or "production complete" is made by this document**.

## 9. Official external source checks (2026-10-11)

- P1 model, credit bands, face limits, rate limit: https://developers.tripo3d.ai/en/models/p1
- P-series image-to-model API: https://developers.tripo3d.ai/en/docs/generation-image-to-model/p
- P2 cost and v3 decimal credit semantics: https://developers.tripo3d.ai/en/docs/changelog
- Task freeze/refund and `balance/frozen`: https://developers.tripo3d.ai/en/docs/task-lifecycle
- Output URL expiry: https://developers.tripo3d.ai/en/docs/quick-start
- Free-tier vs paid commercial rights: https://www.tripo3d.ai/help/privacy-policy/how-to-use-tripo-models-commercially
- Commercial rights caveat: https://www.tripo3d.ai/blog/commercial-rights-checklist-ai-3d-assets-steam-mobile-games

This research supplements and does not silently supersede account-specific terms, actual provider task responses or repository code.
