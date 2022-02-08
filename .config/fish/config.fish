#!/usr/bin/fish
# cursor
# disabled to fix https://github.com/fish-shell/fish-shell/issues/3481
function fish_vi_cursor; end

# key bindings
if ! set -q NVIM_LISTEN_ADDRESS
    fish_vi_key_bindings
end
bind -M insert \b backward-kill-word

# GPG
set -gx GPG_TTY (tty)
if ! set -q SSH_AUTH_SOCK
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

# pyenv
if type -q pyenv
  pyenv init - | source
end

# direnv
direnv hook fish | source

# thefuck
thefuck --alias | source

# starship
starship init fish | source
