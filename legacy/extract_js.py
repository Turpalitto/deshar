#!/usr/bin/env python3
"""Extract inline script from legacy index.html into app.js."""
from pathlib import Path

LEGACY_DIR = Path(__file__).resolve().parent
HTML_PATH = LEGACY_DIR / "index.html"
OUT_JS = LEGACY_DIR / "app.js"


def main() -> None:
    if not HTML_PATH.exists():
        raise SystemExit(f"Not found: {HTML_PATH}")

    html = HTML_PATH.read_text(encoding="utf-8")
    idx = html.find('<script src="lessons_data.js"></script>')
    idx2 = html.find("<script>", idx)
    idx3 = html.find("</script>", idx2)
    if idx2 < 0 or idx3 < 0:
        raise SystemExit("Could not find inline <script> block in index.html")

    js = html[idx2 + 8 : idx3].strip()
    OUT_JS.write_text(js, encoding="utf-8")
    print(f"Extracted {len(js)} chars -> {OUT_JS}")


if __name__ == "__main__":
    main()
