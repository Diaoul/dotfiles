#!/usr/bin/env bash
# editor
export EDITOR='nvim'
export VISUAL="$EDITOR"

# bash options
export HISTCONTROL='ignoreboth'
export HISTSIZE='10000'
export HISTFILESIZE='20000'

# PATH
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.krew/bin:$PATH
if [ "$(uname)" == "Darwin" ]; then
  export PATH=/opt/homebrew/bin:$PATH
fi

# man
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ripgrep
export RIPGREP_CONFIG_PATH=~/.config/ripgrep

# swww
export SWWW_TRANSITION=grow
export SWWW_TRANSITION_POS=0.75,0.7
# export PATH
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH

# if not running interactively, don't do anything else
[[ $- != *i* ]] && return

# fzf
# see https://minsw.github.io/fzf-color-picker/
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa \
  --cycle --border --height=90% --preview-window=wrap --marker=\">\""

# ls colors
export LS_COLORS="$(vivid generate rose-pine)"

# gpg
export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye >/dev/null
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# vi mode
set -o vi

# clear shortcuts
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# shopts
shopt -s checkwinsize # line wrap on window resize
shopt -s histappend   # append to history
shopt -s autocd       # change to directory by name
shopt -s cdspell      # autocorrect cd spelling mistakes
shopt -s dotglob      # include dotted files in expansion
shopt -s nocaseglob   # case-insensitive matching
shopt -s globstar     # recursive globbing with **

# ignore case on completions
bind "set completion-ignore-case on"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .3='cd ../../..'
alias .....='cd ../../../..'
alias .4='cd ../../../..'

# ls
alias l='exa -al --group-directories-first'
alias ls='exa --group-directories-first'
alias la='exa -a --group-directories-first'
alias ll='exa -l --group-directories-first'
alias lt='exa -aT --group-directories-first'

# ripgrep
alias grep='rg'

# internet ip address
alias myip="dog --short myip.opendns.com @resolver1.opendns.com"

# dotfiles git bare
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# pyenv
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

# direnv
eval "$(direnv hook bash)"

# mise-en-place
eval "$(mise activate bash)"

# thefuck
eval "$(thefuck --alias)"

# starship
eval "$(starship init bash)"

