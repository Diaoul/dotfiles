#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["fonttools>=4.53"]
# ///
"""Install a "Monospace" font family on macOS, aliasing the Nerd Font of choice.

Linux resolves the generic `monospace` family through
~/.config/fontconfig/fonts.conf. macOS has no fontconfig and CoreText offers no
user-editable alias table, so the shared terminal configs (ghostty, kitty, foot,
alacritty) that ask for "Monospace" would fall back to a random default.

This script fakes the alias the only way CoreText understands: it writes patched
copies of the source faces whose family name literally is "Monospace" into
~/Library/Fonts. Re-run it after upgrading the font cask.

Only the four faces a terminal needs are installed (regular, bold, italic, bold
italic); extra weights in a single family confuse CoreText's style matching.

The Mono variant of the Nerd Font is the source on purpose: kitty (and ghostty's
font listing) only consider families CoreText reports as monospaced, and the
non-Mono variant, with its double-width icons, is not one.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from fontTools.ttLib import TTFont

# subfamily -> source file suffix, matching ~/.config/fontconfig/fonts.conf
FACES = {
    "Regular": "Regular",
    "Bold": "Bold",
    "Italic": "Italic",
    "Bold Italic": "BoldItalic",
}

CASKROOM = Path("/opt/homebrew/Caskroom")
DEFAULT_CASK = "font-caskaydia-cove-nerd-font"
DEFAULT_PREFIX = "CaskaydiaCoveNerdFontMono"
DEST = Path.home() / "Library" / "Fonts"

# name IDs we rewrite; anything else keeps pointing at the upstream font
FAMILY, SUBFAMILY, UNIQUE_ID, FULL_NAME, POSTSCRIPT = 1, 2, 3, 4, 6
# typographic + legacy compatibility names, dropped so nothing leaks the old family
DROP_IDS = (16, 17, 18, 20, 21)


def source_dir(cask: str) -> Path:
    """Newest installed version directory of the font cask."""
    versions = sorted(p for p in (CASKROOM / cask).glob("*") if p.is_dir())
    if not versions:
        sys.exit(f"{cask} is not installed: brew install --cask {cask}")
    return versions[-1]


def patch(src: Path, subfamily: str, family: str, dest: Path) -> None:
    font = TTFont(src)
    name = font["name"]

    for record in list(name.names):
        if record.nameID in DROP_IDS:
            name.removeNames(record.nameID, record.platformID, record.platEncID, record.langID)

    full = family if subfamily == "Regular" else f"{family} {subfamily}"
    postscript = f"{family.replace(' ', '')}-{subfamily.replace(' ', '')}"
    for name_id, value in (
        (FAMILY, family),
        (SUBFAMILY, subfamily),
        (UNIQUE_ID, f"{postscript}; patched alias of {src.stem}"),
        (FULL_NAME, full),
        (POSTSCRIPT, postscript),
    ):
        name.setName(value, name_id, 3, 1, 0x409)  # Windows, Unicode BMP, en-US
        name.setName(value, name_id, 1, 0, 0)  # Macintosh, Roman, English

    # CoreText only offers monospaced families to terminals; say so explicitly
    font["post"].isFixedPitch = 1

    font.save(dest)
    font.close()
    print(f"{src.name} -> {dest.name} ({full})")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cask", default=DEFAULT_CASK, help="font cask to alias")
    parser.add_argument("--prefix", default=DEFAULT_PREFIX, help="source file name prefix")
    parser.add_argument("--family", default="Monospace", help="family name to install as")
    args = parser.parse_args()

    src_dir = source_dir(args.cask)
    DEST.mkdir(parents=True, exist_ok=True)

    for subfamily, suffix in FACES.items():
        src = src_dir / f"{args.prefix}-{suffix}.ttf"
        if not src.is_file():
            sys.exit(f"missing source face: {src}")
        dest = DEST / f"{args.family.replace(' ', '')}-{suffix}.ttf"
        patch(src, subfamily, args.family, dest)


if __name__ == "__main__":
    main()
