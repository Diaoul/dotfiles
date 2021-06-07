#!/usr/bin/fish

# GPG
set -gx GPG_TTY (tty)

# direnv
direnv hook fish | source

# thefuck
thefuck --alias | source

# starship
starship init fish | source
