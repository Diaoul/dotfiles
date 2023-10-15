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
set -Ux FZF_DEFAULT_OPTS \
    "--color fg:#$theme_fg1,bg:#$theme_bg0,hl:#$theme_bryellow" \
    "--color fg+:#$theme_fg0,bg+:#$theme_bg1,hl+:#$theme_brorange" \
    "--color info:#$theme_brblue,prompt:#$theme_fg3,spinner:#$theme_bryellow" \
    "--color pointer:#$theme_brblue,marker:#$theme_red,header:#$theme_magenta" \
    "--cycle --border --height=90% --preview-window=wrap --marker=\">\""

# ls_colors
set -Ux LS_COLORS (vivid -m 8-bit generate gruvbox-dark)

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

