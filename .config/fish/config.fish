#!/usr/bin/fish

# GPG
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent.ssh

# direnv
direnv hook fish | source

# thefuck
thefuck --alias | source

# starship
starship init fish | source
