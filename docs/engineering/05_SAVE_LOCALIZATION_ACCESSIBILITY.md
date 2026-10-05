# CozyUni — Save, Localization & Accessibility v1.0

Status: **IMPLEMENTATION AUTHORITY**

## 1. Scope

This document defines technical boundaries for local persistence, localization, and accessibility in the current local-first client.

It does not create cloud save, account sync, friends, or social profile behavior.

## 2. Local save ownership

Local save may persist:
- language;
- audio volumes;
- accessibility settings;
- tutorial completion flags;
- local game stats;
- last-used local player names/avatars if UX permits;
- local cosmetic presentation cache;
- non-authoritative cached entitlement/wallet display data when commerce exists.

Local save must not be authoritative for:
- purchased Cozy Credits;
- permanent paid entitlements;
- Apple transactions;
- refund state;
- backend account identity.

## 3. Save format

Use a versioned structured format.

Required top-level concepts:

```text
schema_version
settings
accessibility
tutorials
local_profiles
stats
cache
```

Rules:
- every breaking schema change increments `schema_version`;
- migration code handles supported prior versions;
- unknown future version must not be overwritten with an older schema;
- malformed save should recover safely to defaults while preserving diagnostic evidence in development builds.

Do not use arbitrary node serialization as the long-term save contract.

## 4. Atomicity

Save writes must avoid leaving a partially written canonical save.

Preferred behavior:
- write candidate/temp;
- validate;
- replace canonical file atomically where platform semantics permit;
- maintain a minimal backup/last-good strategy if practical.

A crash during write must not routinely erase settings/stats.

## 5. Match persistence

Current board games do not require mid-match cloud recovery.

If a mode later supports local resume, its state must be deterministic and versioned separately from general settings.

Do not silently add match resume behavior before its UX/rule implications are designed.

## 6. Localization source

All player-visible reusable text should use localization keys rather than literals scattered through scene code.

Baseline languages for architecture:
- English (`en`);
- French (`fr`);
- Vietnamese (`vi`).

This locks technical support, not final translation completeness for every milestone.

## 7. Localization conventions

Keys should be stable semantic IDs, for example:

```text
app.game_library.title
common.play
common.settings
game.ludo.title
game.ludo.tutorial.deploy
result.rematch
```

Rules:
- no text baked into gameplay textures when it must localize;
- do not concatenate translated fragments to form sentences;
- support plural/variable formatting through one localized template;
- avoid assuming English word order;
- keep developer/debug strings separate from user-facing localization.

## 8. Layout resilience

UI must tolerate translation expansion.

Acceptance:
- no clipped critical buttons/text in baseline languages;
- containers expand/wrap where intended;
- gameplay board is not obscured by long translation strings;
- critical status is understandable without relying solely on text length fitting one line.

## 9. Accessibility baseline

Current architecture must support:
- color-independent state/player identification;
- adjustable master/music/SFX volumes;
- reduced camera motion option for world camera;
- tutorial replay/help;
- readable text contrast;
- sufficiently large touch targets;
- visual feedback for audio-only events that affect understanding;
- audio feedback for important interactions where practical.

## 10. Color use

Player colors are not the only identifier.

Each local player/state must have at least one additional cue such as:
- icon;
- avatar;
- shape/pattern;
- label;
- positional treatment.

Legal/selected/blocked states should not be distinguishable by hue alone.

## 11. Motion

Reduced-motion setting should reduce or remove non-essential:
- camera sweeps;
- excessive screen shake;
- long parallax motion;
- repeated UI bouncing;
- decorative motion that can be distracting.

It must not alter game rules, random outcomes, or turn timing.

## 12. Audio categories

Minimum logical buses/settings:
- Master;
- Music;
- SFX;
- UI/Ambience may be separate if the mix needs them.

Volume settings persist locally.

Do not hardcode per-scene master volume overrides that bypass user settings.

## 13. Haptics

If implemented:
- user can disable them;
- haptics are presentation only;
- every important haptic cue has a visual/audio equivalent;
- unsupported devices degrade gracefully.

## 14. Tutorial/accessibility interaction

Tutorial text should:
- be localizable;
- not require color-only descriptions;
- avoid precise timing requirements unless game rules demand them;
- permit replay from Help/Start flow according to shared UX lock.

## 15. Testing

Automated/manual acceptance includes:
- first run with no save;
- valid existing save;
- prior supported schema migration;
- malformed/truncated save recovery;
- language switch + restart persistence;
- long French/Vietnamese strings in key screens;
- reduced motion toggle;
- volume persistence;
- color-independent active-player/legal-action check;
- no paid wallet mutation from local save edits.

## 16. Privacy

Do not place secrets, payment tokens, or unnecessary personal data in local save.

Local player names are device-local convenience data in the current product and must not be presented as globally synced identity.

When commerce authentication is implemented, secure session material follows the dedicated commerce/platform security design, not this plain local save format.
