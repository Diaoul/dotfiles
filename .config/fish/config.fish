#!/usr/bin/fish

# GPG
set -gx GPG_TTY (tty)

# starship
starship init fish | source
