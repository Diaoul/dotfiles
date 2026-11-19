function pass --wraps pass --description 'pass, with clipboard copies kept out of clipboard history'
    set -lx PATH ~/.local/lib/pass $PATH
    command pass $argv
end
