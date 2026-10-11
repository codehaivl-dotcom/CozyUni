# CozyUni — Asset Harvest Production-Readiness Audit

Date: 2026-10-11
Verdict: **NOT YET CLEARED FOR BULK PAID GENERATION**; production design is specified, but hard evidence is missing.

## Observations verified on GitHub `main`

- The canonical 04 master contains exactly 296 distinct `AST-001..AST-296` entries, plus separate characters/game items. The new 150-slot registry is deliberately a subset of those exact IDs.
- Existing `docs/assets/05_MODULAR_WORLD_KIT_MASTER.md` describes 296 additional *modular pieces*, but some of these need dimensional snapping while Tripo output from one perspective is not guaranteed to have exact mating faces.
- The 06 sheet plan uses 4–8 assets per concept sheet. This **does not establish** that one Tripo image-to-3D request will produce 4–8 independently useful GLBs; do not multiply savings by incorrectly conflating image sheet and 3D task.
- `References/README.md` exists, but `References/CozyUni_STYLE_LOCK.png` and W01 A/B image files were absent from inspected remote.
- `assets/` was absent from inspected GitHub `main`. Previously reported S04–S05 source/wrapper paths require verification on the actual local agent workspace; remote existence cannot be asserted.
- `docs/engineering/02_ASSET_IMPORT_AND_WORLD_ASSEMBLY.md` specifies Godot meters/pivots and says module family dimensions must be locked before creation, but does not independently prove a built/working full-world snap kit.
- Old source docs disagree about scope (game-first vs eight-region visual slice vs harvest). The new production contract narrows the current override to credit-expiry source acquisition, **not** to declaring a full life sim already approved/finished.

## Research-verified Tripo facts

- Official v3 endpoint: `https://openapi.tripo3d.ai/v3`.
- P1-20260311 image-to-model with detailed texture is **60 credits**, standard texture **50**, no texture **40**; face limit up to 20,000.
- P2-20260801 is newer, supports up to 50,000 triangle faces and more features, but costs more. **Do not auto-switch models mid-queue.**
- P Series documented concurrency limit is 3 parallel tasks.
- Account reports decimal `balance` and `frozen`; task consumption uses `credits_consumed` on v3.
- Credits are frozen at submission and charged on success. Failures release frozen credits according to provider lifecycle docs.
- Output URL is short-lived, approximately five minutes.
- API promotional/free credit balance **does not by itself settle output commercial rights**. Tripo explicitly describes different rights for Free and Paid Users; tier/account-specific entitlement must be documented before labeling bank output cleared for a sold game.

Primary sources:
- https://developers.tripo3d.ai/en/models/p1
- https://developers.tripo3d.ai/en/docs/changelog
- https://developers.tripo3d.ai/en/docs/task-lifecycle
- https://developers.tripo3d.ai/en/docs/quick-start
- https://www.tripo3d.ai/help/privacy-policy/how-to-use-tripo-models-commercially

## Core production contradiction corrected

Previous implicit logic:

```text
150 free model calls -> 150 random isolated assets -> maybe someday assemble a world
```

Correct logic:

```text
working W01 topology + exact scene anchors + strict asset slots +
known commercial rights + Style D sources + one proven import wrapper
  -> approved named generation queue
  -> immediate GLB recovery
  -> reusable asset bank
  -> W01 actual buildability evidence
  -> subsequent high-reuse/future-region harvesting
```

**Production decisions frozen now:**
- no random new IDs;
- 150 distinct canonical AST entries selected;
- Stage A = 48 precisely identified W01 slots, *not* 48 mandatory paid requests;
- target envelopes/collision/scenes defined per row;
- exact mechanical snap/walkable geometry is Godot-built, Tripo is visual;
- price/model/profile specified;
- every output tied to license, source, hash and task ID;
- usable W01 integration required before broad future expansion.

**Still unresolved external evidence:**
- H0 account rights/expiry/balance;
- required Style Lock and exact source images;
- H1 actual W01 scene/route anchor transforms;
- H2 real Godot round-trip import proof;
- H3 status of 48 slots against the local/source asset directory.

Conclusion: **Do not launch paid mass rendering merely on the basis of document completeness.**
This audit requires objective evidence and prevents the agent from inventing a 'PASS' on missing prerequisites.

No Tripo credits were consumed during this GitHub documentation audit.
