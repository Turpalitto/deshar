#!/usr/bin/env python3
"""Expand curated_vocabulary.json to 1000+ quality entries from dictionary.json."""
import json
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CURATED = ROOT / "curated_vocabulary.json"
DICT = ROOT / "dictionary.json"
ASSETS = ROOT / "nokhchiin" / "assets" / "data" / "curated_vocabulary.json"
TARGET = 1050

EMOJI_BY_CATEGORY = {
    "greetings": "👋",
    "animals": "🐾",
    "colors": "🎨",
    "numbers": "🔢",
    "family": "❤️",
    "food": "🍎",
    "nature": "🌳",
    "body": "🫀",
    "home": "🏠",
    "verbs": "⚡",
    "school": "🏫",
    "phrases": "💬",
    "default": "📖",
}

RU_CATEGORY_KEYWORDS = {
    "greetings": ("привет", "спасибо", "здравств", "прощ"),
    "animals": ("живот", "птиц", "рыб", "насек", "кот", "собак", "лошад", "коров", "овц"),
    "colors": ("цвет", "красн", "син", "зелён", "жёлт", "бел", "чёрн", "сер"),
    "numbers": ("числ", "один", "два", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять", "десять"),
    "family": ("мать", "отец", "брат", "сестр", "сын", "дочь", "семь", "жена", "муж", "дед", "баб"),
    "food": ("еда", "пищ", "хлеб", "молок", "мяс", "вод", "чай", "суп", "фрукт", "овощ", "напит"),
    "nature": ("гора", "река", "лес", "небо", "солн", "дожд", "снег", "ветер", "земл", "мор", "озер"),
    "body": ("голова", "глаз", "ухо", "нос", "рот", "рука", "нога", "сердц", "тело", "палец"),
    "home": ("дом", "комнат", "окно", "двер", "стол", "стул", "книг", "школ"),
    "verbs": ("идти", "беж", "сид", "стоя", "спат", "есть", "пить", "говор", "чит", "пис", "смотр", "слуш", "знат", "работ", "игра"),
}


def norm_key(s: str) -> str:
    return re.sub(r"\s+", "", s.lower())


def guess_category(russian: str, existing: str | None) -> str:
    if existing:
        return existing
    ru = russian.lower()
    for cat, keys in RU_CATEGORY_KEYWORDS.items():
        if any(k in ru for k in keys):
            return cat
    return "default"


def is_learnable(chechen: str, russian: str) -> bool:
    if len(chechen) > 22 or len(chechen) < 1:
        return False
    if any(c in chechen for c in "()[]-+◊"):
        return False
    if chechen.startswith("-") or russian.startswith("-"):
        return False
    if len(russian) > 60:
        return False
    if re.search(r"\d{2,}", chechen):
        return False
    # Skip obscure dictionary meta
    skip_ru = ("см.", "понуд.", "прил.", "нареч.", "мн. от", "субъект", "объект")
    if any(s in russian.lower() for s in skip_ru):
        return False
    return True


def clean_russian(raw: str) -> str:
    return raw.split(",")[0].split(";")[0].strip()


def main() -> None:
    curated = json.load(open(CURATED, encoding="utf-8"))
    dictionary = json.load(open(DICT, encoding="utf-8"))

    by_key: dict[str, dict] = {}
    for e in curated["entries"]:
        by_key[norm_key(e["chechen"])] = e

    added = 0
    for e in dictionary["entries"]:
        if len(by_key) >= TARGET:
            break
        ce = e.get("chechen", "").strip()
        ru = clean_russian(e.get("russian", ""))
        if not ce or not ru:
            continue
        if not is_learnable(ce, ru):
            continue
        key = norm_key(ce)
        if key in by_key:
            continue
        cat = guess_category(ru, e.get("category"))
        sources = list(e.get("sources", ["maciev"]))
        if "curated" not in sources:
            sources.append("curated")
        by_key[key] = {
            "chechen": ce[0].upper() + ce[1:] if ce else ce,
            "russian": ru[0].upper() + ru[1:] if ru else ru,
            "category": cat,
            "emoji": e.get("emoji") or EMOJI_BY_CATEGORY.get(cat, "📖"),
            "hint": e.get("hint") or f"Слово из словаря: {ru}",
            "sources": sources,
        }
        added += 1

    entries = sorted(by_key.values(), key=lambda x: x["chechen"].lower())
    out = {
        "sources": curated.get("sources", []),
        "totalEntries": len(entries),
        "entries": entries,
    }

    for path in (CURATED, ASSETS):
        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(out, f, ensure_ascii=False, indent=2)

    print(f"Curated vocabulary: {len(entries)} entries (+{added} from dictionary)")
    print(f"  -> {CURATED}")
    print(f"  -> {ASSETS}")


if __name__ == "__main__":
    main()
