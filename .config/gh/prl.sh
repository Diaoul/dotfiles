#!/usr/bin/env bash
# Renders `gh pr list` with a title column sized to the current terminal.
set -euo pipefail

cols=${PRL_COLS:-$(stty size 2>/dev/null </dev/tty | cut -d' ' -f2 || true)}
[[ $cols =~ ^[0-9]+$ ]] || cols=120

# gh's hyperlink emits OSC 8 escapes even when stdout is not a terminal
link=0
[[ -t 1 ]] && link=1

lw=20                  # LABELS column
tw=$((cols - 13 - lw)) # PR col 7 + CI col 4 + 2 trailing gap
((tw < 40)) && tw=40
((tw > 114)) && tw=114 # longest title seen in this repo

tmpl=$(sed "s/@TW@/$tw/g; s/@TP@/$((tw + 2))/g; s/@LW@/$lw/g; s/@LINK@/$link/g" ~/.config/gh/pr-list.tmpl)
gh pr list --json number,title,url,labels,statusCheckRollup --template "$tmpl" "$@"
