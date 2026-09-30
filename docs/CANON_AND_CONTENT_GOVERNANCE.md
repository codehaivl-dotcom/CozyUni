# CozyUni — Canon & Content Governance v0.1

## Purpose

Keep one coherent world while allowing many game modes and seasonal variants.

## Canon levels

### LOCKED
Shared identity that modes must not silently change:
- resident names/species/core personality
- canonical shop IDs and primary shop fantasy
- Moonberry Village place identity
- global asset IDs
- shared profile/cosmetics ownership semantics

Changes require an explicit world-level decision and migration plan.

### SHARED DEFAULT
Reusable conventions that a mode may override only in its own scope:
- default outfit
- default daytime lighting
- default shop dressing
- standard NPC positions

### MODE-LOCAL
May differ freely by game mode:
- score
- temporary inventory
- movement rules
- bots
- hazards
- session timer
- temporary event props

### SEASONAL
Temporary presentation/content that must not rewrite base canon:
- winter decorations
- Halloween props
- festival banners
- limited-time cosmetics

## Rule for new content

Before adding a permanent resident, shop, currency, region, or progression system, document:
1. why it must be global rather than mode-local;
2. which existing modes consume it;
3. save/migration impact;
4. monetization implications;
5. asset and localization cost.

## Character rule

The four core playable residents should remain visually recognizable across modes. Cosmetics may alter clothing/accessories, but silhouette and identity should remain readable.

## Shop rule

A shop should keep one strong primary identity. A mode may use the shop for different objectives, but should not casually change what the building represents.

## Economy rule

Do not promote temporary match scores into permanent currencies without a separate economy design. Festival Stars remain a match score unless explicitly redesigned.

## Documentation rule

Every mode owns a design/spec doc. Shared world changes go into world docs first, then modes consume them. Avoid copying shared canon into multiple files unless a generated snapshot is clearly marked.
