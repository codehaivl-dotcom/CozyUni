# CozyUni — Input, Camera & UI Technical Spec v1.0

Status: **IMPLEMENTATION AUTHORITY**

## 1. Primary interaction model

Current v1 is landscape tablet-first and shared-device local multiplayer.

Primary production input:
- direct touch;
- pointer/mouse as development/desktop equivalent;
- keyboard shortcuts may exist for developer/debug convenience only unless explicitly exposed in UX.

Do not design around gamepad as a release requirement.

## 2. Input ownership

Input layers:

```text
OS/Godot Input
 -> screen/mode input adapter
 -> semantic player intent
 -> authoritative mode/rules validation
 -> accepted state/event
 -> presentation animation
```

Raw touch position must never directly mutate game state.

Examples of semantic intent:
- `select_piece(piece_id)`
- `place_mark(cell)`
- `roll_dice`
- `confirm_move(move_id)`
- `end_turn`
- `open_pause`

## 3. Double input / stale input protection

Every state-changing gameplay action uses the current match revision.

Rules:
- accepted action increments revision once;
- same action cannot apply twice due to double tap;
- input is blocked or queued explicitly while a mandatory transition is resolving;
- old UI selection against stale revision is rejected and refreshed.

Do not rely on animation duration as the only anti-double-tap mechanism.

## 4. Touch target baseline

Production interactive controls should target at least **44 logical points/pixels-equivalent of comfortable touch area** as a design baseline, with larger targets for primary actions when space allows.

Board hit areas may be larger than visible geometry.

Never make a tiny 3D mesh itself the only hit target when a larger semantic hit region is available.

## 5. Shared-device turn clarity

At every turn, player ownership must be visually unambiguous through the shared HUD/board language defined in the UX locks.

Technical UI must support:
- active player emphasis;
- disabled/non-active controls;
- legal target highlights;
- confirmation states where required;
- transient result/toast messages;
- accessibility-safe color + non-color cues.

No hidden gesture is required for core game actions.

## 6. Board camera

Board-game camera rules:
- stable/readable camera is preferred over cinematic motion;
- legal cells/nodes must remain unobscured;
- UI must not cover required gameplay targets;
- camera transitions cannot change rule timing/legality;
- no free camera orbit is required for core board play.

Per-game camera composition comes from its canonical board reference and UI layout lock.

## 7. World camera

World Visual MVP uses a third-person or gentle isometric-follow camera according to the accepted reference.

Baseline requirements:
- smooth follow;
- bounded orbit if orbit is enabled;
- collision avoidance against major environment geometry;
- no violent camera snapping;
- hero landmark sightline preserved;
- camera behavior deterministic enough for canonical QA captures.

The world camera is not reused blindly for board games.

## 8. World movement

Baseline world controls:
- virtual touch movement control or direct movement UI appropriate to final UX;
- keyboard WASD may mirror movement in desktop development builds;
- walk/run behavior only if required by world visual lock;
- no combat/interact system may be invented.

Movement must use a semantic vector before character motion logic.

## 9. Input action naming

Godot InputMap baseline:

```text
ui_accept
ui_cancel
app_pause
world_move_left
world_move_right
world_move_forward
world_move_back
world_run
world_camera_left
world_camera_right
world_camera_up
world_camera_down
debug_toggle
```

Board-specific touch actions should normally be interpreted through UI/board hit testing rather than adding dozens of hard-coded InputMap actions.

## 10. UI implementation

Use Godot `Control`-based UI for app shell/HUD/text/settings.

Rules:
- layout via anchors/containers, not fixed desktop pixel coordinates;
- support safe areas/notches;
- tablet landscape is first authority;
- text uses localization keys;
- no gameplay-critical text baked into textures;
- screen routing remains explicit and testable.

## 11. Scaling / reference viewport

Use one logical design baseline for layout and test common landscape aspect ratios around it.

Exact production device matrix is defined in `04_PERFORMANCE_BUDGETS.md`.

UI acceptance must include:
- reference tablet size;
- narrower landscape case;
- wider landscape case;
- safe-area case.

Do not stretch the 3D board/world non-uniformly to solve UI layout.

## 12. Accessibility hooks

Technical UI must permit:
- scalable UI/text within approved limits;
- color-independent player/state cues;
- reduced camera motion setting;
- audio volume categories;
- haptics toggle if haptics are implemented;
- tutorial replay/help access.

Do not implement accessibility as a post-launch-only concern if architecture choices would block it.

## 13. Haptics

Haptics are optional polish.

If implemented:
- keep them presentation-only;
- honor user/system preference;
- no rule/event may depend on feeling a vibration;
- provide visual/audio equivalent feedback.

## 14. Input test cases

Every game vertical slice must test:
- double tap on primary action;
- tap during animation/transition;
- stale selection after state changes;
- rapid pause/resume;
- leave/restart confirmation;
- touch near target boundaries;
- inactive-player interaction attempt;
- rematch with previous touch state cleared.

World test cases:
- continuous movement;
- camera against wall/large prop;
- stairs/ramp traversal;
- region entry/exit;
- pause/resume while moving;
- touch release cannot leave character moving indefinitely.
