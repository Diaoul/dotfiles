#!/usr/bin/env bash
# Renders `gh pr list` with a title column sized to the current terminal.
set -euo pipefail

cols=${PRL_COLS:-$(stty size </dev/tty 2>/dev/null | cut -d' ' -f2)}
cols=${cols:-120}

lw=20                     # LABELS column
tw=$((cols - 13 - lw)) # PR col 7 + CI col 4 + 2 trailing gap
((tw < 40)) && tw=40
((tw > 114)) && tw=114    # longest title seen in this repo

tmpl=$(sed "s/@TW@/$tw/g; s/@TP@/$((tw + 2))/g; s/@LW@/$lw/g" ~/.config/gh/pr-list.tmpl)
gh pr list --json number,title,url,labels,statusCheckRollup --template "$tmpl" "$@"
