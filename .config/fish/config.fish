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

# eza
alias eza "eza --group-directories-first"
abbr -a l eza -la
abbr -a ls eza
abbr -a la eza -a
abbr -a ll eza -l
abbr -a lt eza -laT

# ripgrep
abbr -a grep rg

# fd
abbr -a find fd

# dog
abbr -a dig dog

# cat
abbr -a cat bat

# nvim
abbr -a v nvim

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

# docker
abbr -a d docker
