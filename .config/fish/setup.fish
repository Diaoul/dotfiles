#!/usr/bin/env fish

# editor
set -Ux EDITOR nvim
set -Ux VISUAL $EDITOR

# greeting
set -U fish_greeting ""

# PATH
set -U fish_user_paths \
  $HOME/.local/bin \
  $HOME/.cargo/bin \
  $HOME/.krew/bin

# man
set -Ux MANROFFOPT "-c"
set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"

# ripgrep
set -Ux RIPGREP_CONFIG_PATH ~/.config/ripgrep

# swww
set -Ux SWWW_TRANSITION grow
set -Ux SWWW_TRANSITION_POS 0.75,0.7

# fzf
# see https://minsw.github.io/fzf-color-picker/
set -Ux FZF_DEFAULT_OPTS "
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa \
  --cycle --border --height=90% --preview-window=wrap --marker=\">\""

# ls colors
set -Ux LS_COLORS (vivid generate rose-pine)

# navigation
alias -s .. "cd .."
alias -s ... "cd ../.."
alias -s .... "cd ../../.."
alias -s .3 "cd ../../.."
alias -s ..... "cd ../../../.."
alias -s .4 "cd ../../../.."

# internet ip address
alias -s myip "dog --short myip.opendns.com @resolver1.opendns.com"

# dotfiles
alias -s dotfiles "git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# fisher
curl -sL https://git.io/fisher | source && fisher update

# local configuration
if test -f ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
end
