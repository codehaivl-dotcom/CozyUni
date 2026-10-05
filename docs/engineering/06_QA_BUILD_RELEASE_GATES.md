# CozyUni — QA, Build & Release Gates v1.0

Status: **IMPLEMENTATION / ACCEPTANCE AUTHORITY**

## 1. Principle

No milestone is complete because code compiles or a screenshot looks good.

Every accepted milestone passes the relevant layers:

`data -> parse/build -> unit/rules -> integration -> playable smoke -> visual -> performance -> device/export`

## 2. Gate G0 — repository/data integrity

Required when related files change:

```bash
python tools/validate_game_data.py
python tools/validate_commerce_data.py
python tools/validate_catalog_data.py
```

Expected:
- exit code 0;
- no source-of-truth mismatch;
- no invalid/missing required data.

Add new validators rather than hiding unsupported data in prose.

## 3. Gate G1 — Godot parse/import

Required for every client change.

Using locked Godot version:
- import project;
- parse all scripts;
- start project headlessly where supported;
- fail on script parse errors, missing required main scene, or fatal resource load errors.

`.godot/` cache/import output is disposable and not used to mask missing source files.

## 4. Gate G2 — deterministic rules tests

Required for game-rule changes.

Every locked rule/invariant must have a deterministic test or deterministic test scenario.

Required characteristics:
- explicit seed when RNG exists;
- same input => same accepted state/result;
- illegal actions rejected;
- stale revisions rejected;
- duplicate actions do not apply twice;
- result/ranking deterministic.

A visual playthrough is not a substitute for rules tests.

## 5. Gate G3 — integration / shell tests

Current shared-shell acceptance route:

`Boot -> Game Library -> Game Start -> Local Setup -> Match Summary -> Tutorial/skip -> Match -> Final Results -> Rematch -> Change Players -> Game Library`

Test:
- forward navigation;
- back/cancel paths;
- pause/resume;
- restart/leave confirmation;
- rematch state reset;
- settings persistence;
- unavailable/unbuilt games hidden.

## 6. Gate G4 — playable smoke test

A human or automated interaction runner must complete the representative flow without developer console intervention.

For a game vertical slice:
- start valid match;
- execute representative legal actions;
- exercise at least one important special rule;
- reach final result;
- rematch or exit cleanly.

For W01:
- spawn;
- traverse canonical route;
- pass stairs/bridge/route blockers;
- reach exit;
- pause/resume;
- no fall-through/stuck state.

Save the exact build/commit used.

## 7. Gate G5 — visual evidence

For visually relevant changes, capture deterministic or standardized screenshots.

Minimum categories:
- app shell key screens;
- each integrated game board from canonical gameplay camera;
- key tutorial/HUD/result states;
- W01 canonical hero and route views once world exists.

Compare against:
- canonical reference;
- prior accepted baseline when regression testing.

Classify differences separately:
- camera/composition;
- geometry;
- material/texture;
- lighting;
- animation/VFX;
- UI;
- missing/extra asset.

Do not fix camera mismatch by unnecessarily regenerating assets.

## 8. Gate G6 — performance evidence

Use `04_PERFORMANCE_BUDGETS.md`.

Record:
- device/build;
- route/state;
- frame timing;
- memory;
- draw calls/scene complexity where available;
- regression from prior baseline.

A milestone with a P0 performance budget failure is not accepted.

## 9. Gate G7 — asset technical QA

New/replaced 3D production assets require:
- load/import PASS;
- scale/pivot PASS;
- material/texture PASS;
- normals/geometry visual PASS;
- collision PASS where required;
- gameplay-camera visual PASS;
- repeated-instance performance check where relevant.

Generated source assets stay preserved until candidate is accepted.

## 10. Gate G8 — platform export

Before a release candidate:
- export template/version matches locked Godot version;
- release export completes;
- app launches on representative target hardware;
- no missing asset/resource errors;
- save/settings work after reinstall/update scenario defined for the milestone;
- iOS-specific signing/store operations are handled outside source-controlled secrets.

Do not commit signing certificates, private keys, App Store credentials, or real secrets.

## 11. Gate G9 — commerce enablement

Paid commerce stays feature-flagged OFF until all apply:
- backend implementation exists;
- migrations tested;
- Apple transaction verification tested;
- duplicate transaction idempotency PASS;
- App Store Server Notification idempotency PASS;
- refund/debt/reconciliation PASS;
- StoreKit Test/Sandbox purchase lifecycle PASS;
- wallet cannot be edited authoritatively by client/local save;
- localized StoreKit price used in production UI;
- privacy/release review complete.

Local board games must remain playable without commerce authentication.

## 12. Severity

### P0 — blocker
Examples:
- crash/data corruption;
- wrong game rules/result;
- purchase double grant;
- cannot complete match;
- missing critical asset/reference;
- severe navigation/stuck route;
- release export fails.

### P1 — must fix before milestone acceptance
Examples:
- important UI unreadable/blocked;
- performance gate failure;
- repeatable visual defect at gameplay camera;
- tutorial fails to communicate required rule;
- significant save/localization/accessibility regression.

### P2 — can enter bounded backlog
Non-critical polish defect with documented impact/workaround.

### P3 — optional polish
Does not materially hurt usability, correctness, visual target, or runtime budget.

## 13. Evidence directory convention

When implementation repository structure exists, use a non-runtime evidence area such as:

```text
qa/
  baselines/
  captures/
  performance/
  logs/
  reports/
```

Large binary evidence may be kept out of Git when appropriate, but the report must record where it lives and the exact commit/build measured.

Do not place QA screenshots in runtime asset folders unless the game actually uses them.

## 14. CI minimum

CI must eventually enforce at least:
- game data validation;
- commerce/catalog validation;
- Godot headless parse/start smoke;
- deterministic headless rules tests once test runner exists.

Release CI later adds export checks where signing/platform constraints permit.

## 15. Acceptance report template

Every agent milestone report should include:

```text
Milestone:
Commit:
Authority docs read:
Changed files:
G0 Data: PASS/FAIL/NA
G1 Godot parse/import: PASS/FAIL/NA
G2 Rules tests: PASS/FAIL/NA
G3 Integration: PASS/FAIL/NA
G4 Playable smoke: PASS/FAIL/NA
G5 Visual: PASS/FAIL/NA
G6 Performance: PASS/FAIL/NA
G7 Asset QA: PASS/FAIL/NA
G8 Export: PASS/FAIL/NA
Known P0/P1 defects:
Evidence paths:
Next admitted milestone:
```

No P0/P1 open => milestone may be accepted if all required gates pass.
