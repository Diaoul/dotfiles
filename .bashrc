#!/bin/bash
# exports
export EDITOR='nvim'
export HISTCONTROL='ignoreboth';
export HISTSIZE='10000'
export HISTFILESIZE='20000'

# export PATH
export PATH=$HOME/.bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# gpg
export GPG_TTY="$(tty)"
if [ -z "$SSH_AUTH_SOCK" ]
then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

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

# dotfiles git bare
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# pyenv
if command -v pyenv &> /dev/null
then
  eval "$(pyenv init -)"
fi

# direnv
eval "$(direnv hook bash)"

# thefuck
eval "$(thefuck --alias)"

# starship
eval "$(starship init bash)"
