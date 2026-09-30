# CozyUni — Product Strategy v0.1

## Decision

**Build one primary public app first: CozyUni.**

Do not launch many near-identical small apps that reuse the same characters/world with only minor gameplay differences. Instead, ship one polished app with a clear first game mode, then expand it with additional modes/events when they pass quality gates.

## Why one app first

### Advantages
- one install funnel
- one App Store listing to build ratings/reviews
- one player profile and save
- one identity/brand
- one asset download/update pipeline
- one analytics funnel
- cross-mode retention: a player who tires of one mode can switch activities without leaving the product
- cosmetics and progression have more value because they appear across multiple activities
- marketing spend compounds into one product instead of being fragmented

### Main risk
An all-in-one app can become bloated, confusing, or expensive if every prototype is shipped into it.

Therefore CozyUni should **not** mean “put everything in one giant menu.” It means a shared platform with strict admission gates for modes.

## Recommended product shape

### Layer 1 — CozyUni shell
Shared:
- account/profile
- four core characters
- cosmetics
- home/hub
- settings/accessibility/localization
- friends/lobby
- achievements / collection
- seasonal calendar
- notifications (if later justified)
- save + analytics

### Layer 2 — Play modes
Examples:
- Festival Board
- Festival Rush
- Firefly Catch
- Delivery Dash
- Shop Panic

Each mode owns its own gameplay loop, tutorial, scoring, telemetry, and balancing.

### Layer 3 — Events
Low-cost variants:
- Halloween dressing
- winter festival
- spring flowers
- night market
- anniversary event

Events should reuse an existing mode whenever possible instead of becoming new permanent modes.

## When to make a standalone app

A mode should split into a separate app only if several of these become true:
- different target audience
- fundamentally different control scheme
- much larger content/download footprint
- incompatible monetization
- different age rating or store positioning
- different retention cadence
- the mode becomes strong enough to support its own brand/search demand

Until then: keep it in CozyUni.

## Launch strategy

### V0 / soft launch
Ship only:
- shared shell
- Moonberry Village
- 4 characters
- Festival Board as the flagship mode
- one lightweight second mode only if it is already fun and stable

Do not delay launch just to reach an arbitrary number of modes.

### V1 growth
Add one proven quick-win mode, likely Festival Rush or Firefly Catch.

### V2 retention
Add seasonal events, cosmetics, achievements, collections, and a third mode based on telemetry.

## Product success hierarchy

1. The first session is understandable.
2. The flagship mode is genuinely fun.
3. The app runs reliably and loads quickly.
4. Players have a reason to return.
5. Shared identity/progression makes multiple modes more valuable together.
6. Monetization comes after product value is demonstrated.

## Mode admission gate

No mode enters production app unless it passes:
- core loop understood without developer explanation
- fun/playtest threshold defined in its design doc
- stable performance on target devices
- no regression to shared shell
- session start/end clearly defined
- mode-specific telemetry implemented
- tutorial/onboarding cost justified
- asset reuse documented

A prototype may live in the repo without appearing in production navigation.
