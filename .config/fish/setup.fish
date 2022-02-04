#!/usr/bin/env fish

# theme
set theme_black     282828
set theme_brblack   928374
set theme_red       cc241d
set theme_brred     fb4934
set theme_green     98971a
set theme_brgreen   b8bb26
set theme_yellow    d79921
set theme_bryellow  fabd2f
set theme_blue      458588
set theme_brblue    83a598
set theme_magenta   b16286
set theme_brmagenta d3869b
set theme_cyan      689d6a
set theme_brcyan    8ec07c
set theme_white     a89984
set theme_brwhite   ebdbb2
set theme_orange    d65d0e
set theme_brorange  fe8019
set theme_bg0_h     1d2021
set theme_bg0       282828
set theme_bg1       3c3836
set theme_bg2       504945
set theme_bg3       665c54
set theme_bg4       7c6f64
set theme_gray      928374
set theme_bg0_s     32302f
set theme_fg4       a89984
set theme_fg3       bdae93
set theme_fg2       d5c4a1
set theme_fg1       ebdbb2
set theme_fg0       fbf1c7

set -U fish_color_autosuggestion     brblack
set -U fish_color_cancel             -r
set -U fish_color_command            cyan
set -U fish_color_comment            brblack
set -U fish_color_cwd                cyan
set -U fish_color_cwd_root           brred
set -U fish_color_end                $theme_orange
set -U fish_color_error              red
set -U fish_color_escape             $theme_orange
set -U fish_color_history_current    --bold
set -U fish_color_host               normal
set -U fish_color_match              --background=brblue
set -U fish_color_normal             normal
set -U fish_color_operator           red
set -U fish_color_param              brwhite
set -U fish_color_quote              brgreen
set -U fish_color_redirection        bryellow
set -U fish_color_search_match       --background=$theme_bg2
set -U fish_color_selection          -r
set -U fish_color_status             red
set -U fish_color_user               brgreen
set -U fish_color_valid_path         --underline
set -U fish_pager_color_completion   normal
set -U fish_pager_color_description  yellow
set -U fish_pager_color_prefix       --bold --underline
set -U fish_pager_color_progress     brwhite --background=blue

# editor
set -Ux EDITOR nvim
set -Ux VISUAL $EDITOR

# greeting
set -U fish_greeting ""

# PATH
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $HOME/.cargo/bin $HOME/.poetry/bin

# navigation
alias -s .. "cd .."
alias -s ... "cd ../.."
alias -s .... "cd ../../.."
alias -s .3 "cd ../../.."
alias -s ..... "cd ../../../.."
alias -s .4 "cd ../../../.."

# vim (or nvim)
alias -s vim "nvim"

# bat
abbr -a cat bat
set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"

# docker
curl -sfLo ~/.config/fish/completions/docker.fish --create-dirs \
    https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish
abbr -a d docker

# dog
abbr -a dig dog

# exa
alias -s exa "exa --group-directories-first"
abbr -a l exa -la
abbr -a ls exa
abbr -a la exa -a
abbr -a ll exa -l
abbr -a lt exa -laT

# fd
abbr find fd

# git
abbr -a gco git checkout
abbr -a gs git status -s
abbr -a gd git diff
abbr -a gds git diff --staged
abbr -a ga git add
abbr -a gaa git add -A
abbr -a gau git add -u
abbr -a gb git branch -v
abbr -a gc git commit
abbr -a gca git commit -a
abbr -a gcm git commit -m
abbr -a gcam git commit -am
abbr -a gl git pull
abbr -a gp git push
abbr -a gpa git push --all
abbr -a glg git log --graph --oneline
abbr -a glga glg --all
abbr -a glgn glg '(git describe --tags --abbrev=0 @^)..@'

# kubernetes
abbr -a kx kubectx
abbr -a kn kubens
abbr -a k kubectl
abbr -a ka kubectl apply
abbr -a kaf kubectl apply -f
abbr -a kd kubectl describe
abbr -a kdel kubectl delete
abbr -a kg kubectl get
abbr -a kgp kubectl get pods
abbr -a kga kubectl get -A
abbr -a kex kubectl exec -it

# flux
mkdir -p ~/.config/fish/completions
if type -q flux
  flux completion fish > ~/.config/fish/completions/flux.fish
end

# internet ip address
alias -s myip "dog --short myip.opendns.com @resolver1.opendns.com"

# ripgrep
set -Ux RIPGREP_CONFIG_PATH ~/.config/ripgrep
abbr -a grep rg

# fzf
set -Ux FZF_DEFAULT_OPTS \
    "--color fg:#$theme_brwhite,bg:#$theme_black,hl:#$theme_bryellow" \
    "--color fg+:#$theme_brwhite,bg+:#$theme_bg1,hl+:#$theme_bryellow" \
    "--color info:#$theme_brblue,prompt:#$theme_fg3,spinner:#$theme_bryellow" \
    "--color pointer:#$theme_brblue,marker:#$theme_brorange,header:#$theme_bg3"

# fisher
curl -sfL https://git.io/fisher | source && fisher update

# vi mode
function fish_user_key_bindings
    if ! set -q NVIM_LISTEN_ADDRESS
        fish_vi_key_bindings
    end
    bind -M insert \b  backward-kill-word
    bind -M insert \cf accept-autosuggestion
    bind -M insert \ch backward-kill-word
    bind -M insert \ck history-search-backward
    bind -M insert \cj history-search-forward
    bind -M insert \cl forward-word
end
funcsave fish_user_key_bindings

# thefuck
thefuck --alias | source
funcsave fuck

# dotfiles
alias -s dotfiles "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
