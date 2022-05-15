#!/usr/bin/fish
# cursor
# disabled to fix https://github.com/fish-shell/fish-shell/issues/3481
function fish_vi_cursor; end
# set fish_cursor_default block blink
# set fish_cursor_insert line blink
# set fish_cursor_replace_one underscore blink
# set fish_cursor_visual block

# key bindings
if ! set -q NVIM_LISTEN_ADDRESS
    fish_vi_key_bindings
end
bind -M insert \b backward-kill-word

# GPG
set -gx GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

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
