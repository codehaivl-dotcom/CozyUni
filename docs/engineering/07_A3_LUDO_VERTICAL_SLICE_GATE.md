# CozyUni — A3 Cozy Ludo Vertical Slice Gate v1.0

Status: **CURRENT / A3 ACCEPTANCE AUTHORITY**

This gate exists so agents do not confuse "the screen renders" with "the vertical slice is accepted".

Authority:
- `docs/PRODUCTION_MASTER_PLAN.md`
- `docs/games/01_COZY_LUDO.md`
- `docs/games/00_APP_SHELL_FLOW_LOCK.md`
- `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
- `docs/games/00_SHARED_UI_LAYOUT_LOCK.md`
- `docs/engineering/04_PERFORMANCE_BUDGETS.md`
- `docs/engineering/06_QA_BUILD_RELEASE_GATES.md`

---

## 1. A3 implementation target

Required end-to-end path:

`Game Library -> Ludo Start -> Local Player Setup -> Match Summary -> Tutorial when needed -> Countdown -> Ludo Match -> Final Results -> Rematch / Change Players / Library`

A3 is still a vertical slice. Final art/audio are not required yet, but the game must already be understandable and reliably playable.

---

## 2. Automated gates — required on every relevant change

CI must prove all of the following:

### Data / parse
- canonical game-data validator passes;
- runtime data mirror validator passes;
- Godot 4.7.2 imports/parses project successfully;
- main scene headless boot succeeds.

### Shared shell
- legal route sequence passes `tests/shell/shell_flow_smoke.gd`;
- invalid route jumps are rejected;
- match -> results -> rematch/change players/library transitions remain legal.

### Ludo rules
- `tests/ludo/ludo_rules_acceptance.gd` passes;
- deterministic same-seed/same-actions behavior passes;
- deploy, capture, safe cells, own-cell blocking, bonus-roll limit, no-legal-move, home/overshoot, ranking and stale-revision rules pass.

### Match completion reliability
- `tests/ludo/ludo_match_completion_smoke.gd` completes at least 100 deterministic matches each for 2P, 3P and 4P using only production legal actions;
- no match reaches the action safety cap;
- every completed match returns one valid winner and ranking covering all players;
- failures must preserve player-count + seed in logs.

### UI / touch contract
- `tests/ludo/ludo_ui_smoke.gd` passes;
- 2P/3P/4P production state can be created for UI;
- a legal piece produces a touch target at least 52x52 px in the current test board;
- a screen-touch inside the legal target selects the correct piece;
- a touch outside legal targets selects nothing.

Automated CI passing is necessary but **not sufficient** to mark A3 complete.

---

## 3. Manual device gate — mandatory before A4

Representative authority is a native build on the tablet class defined in `04_PERFORMANCE_BUDGETS.md`. Desktop editor behavior is useful development evidence but cannot close this gate.

Run at minimum:

### 2-player full match
- fresh tutorial path;
- roll;
- deploy on 6;
- choose legal piece;
- capture when encountered;
- reach Home;
- Final Results;
- Rematch.

### 3-player full match
- player names remain attached to correct slots;
- unique avatars remain correct;
- turn indicator does not drift;
- pause/resume works;
- restart confirmation works;
- change players returns to setup without stale match state.

### 4-player full match
- all four player summaries remain readable;
- legal pieces are visually obvious;
- no UI overlap blocks board actions;
- Final Results includes all four players;
- returning to Game Library clears active match state.

---

## 4. Tutorial comprehension gate

At least one tester who is not reading the GDD should be able to understand from the in-game flow:
- when a piece may leave Yard;
- what a roll of 6 means;
- how to choose a legal piece;
- what capture does;
- what safe cells do;
- how pieces reach Home;
- what ends the match.

If verbal developer explanation is required, A3 is not accepted.

Record confusing step(s); do not alter rules to solve presentation problems.

---

## 5. Performance gate

Use the exact board-game budgets from `04_PERFORMANCE_BUDGETS.md`.

Required measurements on representative device:
- target 60 FPS;
- gameplay P95 <= 16.67 ms after warm-up;
- no repeated ordinary-turn hitch > 33 ms;
- steady memory target <= 1.2 GB;
- peak target <= 1.5 GB;
- board visible triangles target <= 500k;
- draw calls target <= 400;
- board-game transition target <= 2 s;
- no unbounded memory growth after 3 consecutive rematches.

Measure:
1. idle board;
2. dice action;
3. longest token movement available in the test run;
4. capture state;
5. results transition;
6. three rematches.

Do not substitute desktop numbers.

---

## 6. Evidence record

Create one report under `evidence/device/` when this manual gate is run.

Required fields:

```text
Commit SHA:
Godot version:
Device/model:
OS version:
Build type:
Tester:

2P full match: PASS/FAIL
3P full match: PASS/FAIL
4P full match: PASS/FAIL
Tutorial without developer explanation: PASS/FAIL
Pause/resume/restart/leave: PASS/FAIL
Rematch/reset/change players/library: PASS/FAIL
Touch/readability: PASS/FAIL

FPS / frame-time P50/P95/max:
Memory steady/peak:
Draw calls:
Visible triangles/primitives:
Transition/load timings:
3-rematch memory regression:

P0 defects:
P1 defects:
Screenshots/capture paths:
Notes:
```

---

## 7. Acceptance decision

A3 may be marked **PASS** only when:
- all automated CI gates are green;
- 2P/3P/4P native-device matches complete;
- tutorial comprehension passes;
- touch/readability passes;
- performance budgets pass or an explicit product-approved budget revision exists;
- no unresolved P0/P1 defects remain.

Until then use status:

`A3 IMPLEMENTED / DEVICE GATE PENDING`

Do not begin A4 production polish merely because CI is green.
