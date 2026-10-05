# CozyUni — Engine Tech Stack Lock v1.0

Status: **LOCKED FOR CLIENT IMPLEMENTATION**

## 1. Game engine

- Engine: **Godot 4.7.2 stable**
- Do not move to a development/RC build without an explicit architecture change.
- Renderer for production default: **Forward+**.
- Compatibility renderer may be used only for a documented device fallback experiment; it is not the default authority.

Reason: CozyUni is a stylized 3D tablet-first game/world project that benefits from standard Godot 4 3D lighting/material/navigation features while keeping the stack lightweight.

## 2. Client language

Default: **typed GDScript**.

Rules:
- use typed function parameters/returns and typed member variables where practical;
- no C#/.NET dependency in the current client baseline;
- no GDExtension/native module unless a measured blocker justifies it and the change is approved;
- do not mix languages casually.

## 3. Primary target

Product UX target:
- landscape tablet first;
- iPad/iOS is release-critical;
- desktop Windows/macOS are development/test targets;
- Android may be evaluated later but is not allowed to distort current architecture.

Core local board games must work offline after installation.

## 4. Backend boundary

Godot is the game client only.

Commerce backend remains:
- Node.js 22 LTS;
- TypeScript strict;
- Fastify 5;
- PostgreSQL 16+;
- Apple official App Store Server Library.

Do not move paid-wallet authority into Godot/local save.

## 5. Third-party addon policy

Baseline client requires **zero third-party Godot addons**.

An addon may be proposed only when:
- built-in Godot cannot reasonably satisfy the requirement;
- license and maintenance status are verified;
- exact version/commit is pinned;
- permissions/runtime behavior are documented;
- removal path exists;
- a native implementation would cost materially more.

Do not install an MCP/editor-control plugin as a runtime game dependency.

## 6. Rendering conventions

- color space/materials: Godot 4 standard PBR workflow;
- imported 3D assets: glTF/GLB preferred;
- transparent materials are exceptional and must be performance-reviewed;
- avoid expensive screen-space effects as baseline requirements;
- no project-wide post-process look may override the locked CozyUni art direction.

## 7. Physics/navigation

Use built-in Godot 3D physics/navigation unless a measured issue requires a change.

World Visual MVP:
- `CharacterBody3D` for the player;
- `NavigationRegion3D` / navigation maps where pathing is required;
- simple static collision for environment;
- avoid per-triangle collision for repeated decorative assets unless justified.

Board games should not depend on 3D physics for rule legality.

## 8. Data

Canonical game/economy JSON under `docs/data/` is source input for implementation/testing.

Runtime production copies may live under `res://data/`, but they must be generated/copied in a traceable way and remain equivalent to canonical source values.

Do not maintain two manually divergent copies.

## 9. Save and secure storage

Local save owns only non-authoritative local state such as:
- settings;
- accessibility;
- tutorial completion;
- local stats;
- last-used local profile/avatar preferences.

Paid wallet/entitlements are server-authoritative.

Commerce credentials/session secrets must use platform-appropriate secure storage/bridge when commerce ships; never plain-text local config.

## 10. Version upgrade rule

Engine upgrade requires:
1. branch or reversible change;
2. read migration notes/changelog;
3. project parse/import test;
4. all automated game/data tests;
5. representative board screenshot comparison;
6. representative W01 world screenshot comparison once W01 exists;
7. export smoke test;
8. update this lock.

Do not upgrade because a newer minor/dev version exists.
