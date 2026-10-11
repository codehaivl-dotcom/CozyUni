# CozyUni — Active World App Flow (2026-10-11)

**ACTIVE:** replaces the former board-game Game Library startup for CozyUni Living World.

```text
Boot -> CozyUni Splash -> Continue World / New World / Settings
     -> Character select (only locally verified available models; default Miko placeholder if needed)
     -> W01 Moonberry Village -> explore / Talk / Garden / Photo / Album / Personal Build
     -> Pause -> Save & Return -> Continue World
```

**First seconds:** character spawns in W01's known route near entrance / starter home, can walk freely and see Town Hall/Fountain landmark. No Ludo/gameboard menu, no matchmaking/login or disabled five-board entries. Retain working board code as an archive without exposing its routes.

**World interface:** camera follows in gentle third-person/high-isometric style; tablet touch controls with comfortable hit zones, desktop WASD for development. HUD stays compact; object-specific prompts for Talk, Plant/Water, Photo, Arrange, Land Board and Build. No giant always-on quest panel, countdown, battle HUD or board cells.

**Build:** interact with property Build sign; camera tilts to show P00..P03; only owned parcels editable; ground/path 2m grid visible in Build Mode; select palette, see valid/invalid ghost, rotate by 90°, Confirm/Cancel, Move/Store. Plot purchase uses earned Village Coins and an explicit confirmation showing the current price.

**Save:** Continue restores selected avatar, location, album, resident/chapter progress, garden, VC, purchased parcels and build instances; reloading must not double-charge, duplicate props or grant one-time rewards twice.

**Acceptance:** start → garden → photo/Album → earn 100 VC → purchase adjacent 8×8m parcel → lay 2 ground cells/place 2 props → quit/reopen → identical saved state. Old `docs/games/00_APP_SHELL_FLOW_LOCK.md` is historical only.
