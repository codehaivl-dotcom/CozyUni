# CozyUni — Canonical Visual References

This directory is the canonical home for visual references required by world/board/asset production workflows.

## Required style authority

Expected file:

`References/CozyUni_STYLE_LOCK.png`

If this image is missing, any generation route whose contract requires it must STOP with `MISSING_REFERENCE`. Do not silently fall back to text-only generation.

## World references

`docs/world/00_WORLD_VISUAL_MVP_LOCK.md` requires two references per world map:

- `World/W01_Moonberry_Village_A_Hero.*`
- `World/W01_Moonberry_Village_B_Layout.*`
- ... through W08.

`A_Hero` = gameplay/art-direction composition.
`B_Layout` = route/blockout/layout authority.

Primitive greybox work may proceed before final references exist; final art placement may not.

## Board references

Two references per board game:

- `Games/G01_Ludo_A_Hero.*`
- `Games/G01_Ludo_B_Layout.*`
- ... through G05.

Generated reference imagery never overrides the locked GDD or machine-readable game data.

## File policy

- preserve approved references; do not replace silently;
- use stable names;
- keep source/provenance information alongside externally sourced or generated references where applicable;
- final production tasks should record which exact reference file/version was used.
