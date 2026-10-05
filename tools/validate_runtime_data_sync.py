#!/usr/bin/env python3
"""Fail when Godot runtime JSON drifts from canonical docs/data JSON."""

from __future__ import annotations

import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
PAIRS = [
    (ROOT / "docs/data/app_shell_v1.json", ROOT / "data/app_shell_v1.json"),
    *[
        (ROOT / "docs/data/games" / name, ROOT / "data/games" / name)
        for name in (
            "ludo_v1.json",
            "caro_v1.json",
            "journey_v1.json",
            "chess_v1.json",
            "tycoon_v1.json",
        )
    ],
]


def load_json(path: Path):
    if not path.exists():
        raise FileNotFoundError(path)
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> int:
    failures: list[str] = []
    for canonical, runtime in PAIRS:
        try:
            canonical_data = load_json(canonical)
            runtime_data = load_json(runtime)
        except (OSError, json.JSONDecodeError) as exc:
            failures.append(str(exc))
            continue
        if canonical_data != runtime_data:
            failures.append(f"runtime drift: {runtime.relative_to(ROOT)} != {canonical.relative_to(ROOT)}")

    if failures:
        for failure in failures:
            print(f"ERROR: {failure}", file=sys.stderr)
        return 1

    print(f"runtime data sync PASS ({len(PAIRS)} files)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
