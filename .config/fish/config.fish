#!/usr/bin/fish

# key bindings
function fish_user_key_bindings
  fish_default_key_bindings -M insert

  if ! set -q NVIM_LISTEN_ADDRESS
    fish_vi_key_bindings --no-erase insert
  end
end

# cursor
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

# GPG
set -gx GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

# pyenv
if type -q pyenv
  pyenv init --path | source
end

# direnv
direnv hook fish | source

# mise-en-place
mise activate fish | source

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
abbr -a --set-cursor gc 'git commit -m "%"'
abbr -a gca git commit -a
abbr -a gcam git commit -am
abbr -a gl git pull
abbr -a gp git push
abbr -a gpa git push --all
abbr -a glg git log --graph --oneline
abbr -a glga glg --all
abbr -a glgn glg '(git describe --tags --abbrev=0 @^)..@'

# kubernetes
abbr -a k kubectl
abbr -a kx kubectx
abbr -a kn kubens
abbr -a ka kubectl apply
abbr -a kaf kubectl apply -f
abbr -a kd kubectl describe
abbr -a kdel kubectl delete
abbr -a kg kubectl get
abbr -a kgp kubectl get pods
abbr -a kgn kubectl get nodes
abbr -a kga kubectl get -A
abbr -a kex kubectl exec -it

# docker
abbr -a d docker
