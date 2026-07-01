#!/usr/bin/env python3
"""Find suspicious dictionary entries and lookup sample words."""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOOLS_DIR = Path(__file__).resolve().parent
DEFAULT_DICT = ROOT / "dictionary.json"
FALLBACK_DICT = ROOT / "nokhchiin" / "assets" / "data" / "dictionary.json"
DEFAULT_OUT = TOOLS_DIR / "output"
SAMPLE_KEYS = [
    "маршалла",
    "цициг",
    "нана",
    "ваха",
    "деша",
    "хьун",
    "маьлхан",
    "Ӏуьйре",
]


def resolve_dict(path: Path | None) -> Path:
    if path is not None:
        return path
    if DEFAULT_DICT.exists():
        return DEFAULT_DICT
    return FALLBACK_DICT


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dict",
        type=Path,
        default=None,
        help="Path to dictionary.json (default: repo root or nokhchiin/assets/data/)",
    )
    parser.add_argument(
        "--out-dir",
        type=Path,
        default=DEFAULT_OUT,
        help="Directory for bad_entries.txt and lookup.txt",
    )
    args = parser.parse_args()

    dict_path = resolve_dict(args.dict)
    if not dict_path.exists():
        raise SystemExit(f"Dictionary not found: {dict_path}")

    with open(dict_path, encoding="utf-8") as f:
        data = json.load(f)

    entries = data["entries"]
    bad = [
        e
        for e in entries
        if len(e["chechen"]) > 25
        or "]" in e["chechen"]
        or "(" in e["chechen"]
        or e["chechen"].startswith("-")
    ]

    out_dir = args.out_dir
    out_dir.mkdir(parents=True, exist_ok=True)

    bad_path = out_dir / "bad_entries.txt"
    with open(bad_path, "w", encoding="utf-8") as out:
        out.write(f"Total bad: {len(bad)}\n\n")
        for e in bad[:50]:
            out.write(f"{e['chechen']} -> {e['russian']}\n")

    lookup_path = out_dir / "lookup.txt"
    with open(lookup_path, "w", encoding="utf-8") as out:
        for key in SAMPLE_KEYS:
            found = [
                e
                for e in entries
                if e["chechen"].lower().replace(" ", "") == key.replace(" ", "")
            ]
            out.write(f"{key}: {found[:2]}\n")

    print(f"Analyzed {dict_path}")
    print(f"  bad entries: {len(bad)} -> {bad_path}")
    print(f"  lookup: {lookup_path}")


if __name__ == "__main__":
    main()
