# Helper: build sorted pipe-separated rows for all non-main worktrees.
# Output line: bucket|name|branch|pr_num|pr_state|ci|dirty|reuse|age
# Buckets (lower = better reuse target):
#   0=best-clean  1=ready  2=free  3=best-dirty  4=stale  5=active  6=other-dirty
function __ws_rows --argument-names base_dir
    set -l worktrees (git -C $base_dir worktree list --porcelain | string match 'worktree *' | string replace 'worktree ' '')
    set -l prs_json (gh pr list --state all --author @me --json number,headRefName,state,isDraft --limit 200 2>/dev/null)

    for wt in $worktrees
        set -l name (basename $wt)
        if test "$name" = "main" -o "$name" = ".bare"
            continue
        end
        set -l branch (git -C $wt branch --show-current 2>/dev/null)
        test -z "$branch"; and continue

        set -l dirty_count (git -C $wt status --porcelain | wc -l | string trim)
        set -l dirty clean
        test "$dirty_count" != "0"; and set dirty "dirty($dirty_count)"

        set -l age (git -C $wt log -1 --format=%cr 2>/dev/null | string replace ' ago' '')
        test -z "$age"; and set age "-"

        set -l pr_num "-"
        set -l pr_state "no-PR"
        set -l ci "-"
        set -l reuse "✅ free"
        set -l bucket 2

        if string match -q 'ws-ready/*' $branch
            set reuse "✅ ready"
            set bucket 1
        end

        set -l pr (echo $prs_json | jq -r --arg b "$branch" '.[] | select(.headRefName == $b) | "\(.number)|\(.state)|\(.isDraft)"' | head -1)

        if test -n "$pr"
            set -l parts (string split '|' $pr)
            set pr_num "#$parts[1]"
            switch $parts[2]
                case OPEN
                    if test "$parts[3]" = "true"
                        set pr_state "OPEN draft"
                    else
                        set pr_state OPEN
                    end
                    set reuse "❌ active"
                    set bucket 5
                case MERGED
                    set pr_state MERGED
                    if test "$dirty_count" = "0"
                        set reuse "✅ best"
                        set bucket 0
                    else
                        set reuse "⚠️ best-dirty"
                        set bucket 3
                    end
                case CLOSED
                    set pr_state CLOSED
                    set reuse "⚠️ stale"
                    set bucket 4
            end
            set -l ci_parts (gh pr view $parts[1] --json statusCheckRollup --jq '
                (.statusCheckRollup // []) as $r |
                ($r | map(select(.conclusion == "FAILURE" or .conclusion == "TIMED_OUT" or .conclusion == "CANCELLED")) | length) as $failed |
                ($r | map(select(.status != "COMPLETED" and .status != null)) | length) as $running |
                "\($failed)|\($running)|\($r | length)"
            ' 2>/dev/null | string split '|')
            if test (count $ci_parts) -eq 3
                set -l failed $ci_parts[1]
                set -l running $ci_parts[2]
                set -l total $ci_parts[3]
                if test "$total" = "0"
                    set ci "-"
                else if test "$failed" != "0"
                    set ci "❌ $failed"
                else if test "$running" != "0"
                    set ci "🟡 $running"
                else
                    set ci "✅"
                end
            end
        end

        # Dirty without a MERGED PR → demote below best-dirty (still useful info, just not reusable)
        if test "$dirty_count" != "0"; and test $bucket -lt 3
            set bucket 6
        end

        echo "$bucket|$name|$branch|$pr_num|$pr_state|$ci|$dirty|$reuse|$age"
    end | sort -t'|' -k1,1n -k2,2
end

# Helper: pick first reusable slot from rows, or fall back to unallocated NATO name.
# Prints slot name on stdout, returns 1 if no slot available.
function __ws_pick_slot --argument-names base_dir
    set -l rows (__ws_rows $base_dir)
    for row in $rows
        set -l p (string split '|' $row)
        if test "$p[1]" -le 2; and test "$p[7]" = "clean"
            echo $p[2]
            return 0
        end
    end
    set -l nato alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu
    set -l existing (git -C $base_dir worktree list --porcelain | string match 'worktree *' | string replace 'worktree ' '' | xargs -n1 basename)
    for n in $nato
        if not contains $n $existing
            echo $n
            return 0
        end
    end
    return 1
end

function ws --description "Create worktree + tmux session"
    set -l base_dir ~/Projects/alan-apps-worktrees
    set -l main_dir $base_dir/main

    # Strip --no-tmux flag (skips tmux session creation + claude auto-start).
    # Useful when spawning worktrees from a non-interactive shell or for agents.
    set -l no_tmux 0
    if contains -- --no-tmux $argv
        set no_tmux 1
        set argv (string match -v -- --no-tmux $argv)
    end

    if test (count $argv) -eq 0
        set -l sessions (tmux list-sessions -F '#{session_name}#{?session_attached, (attached),}' 2>/dev/null)
        for line in $sessions
            set -l name (string split ' ' -- $line)[1]
            set -l suffix (string replace -- $name '' $line)
            set -l worktree_path $base_dir/$name
            set -l branch ""
            if test -d $worktree_path
                set branch (git -C $worktree_path branch --show-current 2>/dev/null)
            end
            if test -n "$branch"
                echo "$name: $branch$suffix"
            else
                echo "$name:$suffix"
            end
        end
        return
    end

    # Delete worktree: ws -d <name> [--force]. Intercepted early so the leading
    # dash never leaks into the `string match`/`test` dispatch chains below.
    if string match -q -- -d $argv[1]
        if test (count $argv) -lt 2
            echo "Usage: ws -d <name> [--force]"
            return 1
        end
        set -l name $argv[2]
        set -l force 0
        if contains -- --force $argv
            set force 1
        end
        set -l session_name (string replace -ra '[^a-zA-Z0-9_-]' '_' $name)
        set -l worktree_path $base_dir/$name

        # Kill tmux session
        if tmux has-session -t $session_name 2>/dev/null
            tmux kill-session -t $session_name
            echo "Killed tmux session '$session_name'"
        end

        # Remove worktree and branch
        if test -d $worktree_path
            set -l branch (git -C $worktree_path branch --show-current)
            if test $force -eq 1
                git -C $base_dir worktree remove --force $name
            else if not git -C $base_dir worktree remove $name 2>/dev/null
                echo "Worktree '$name' has changes. Use --force to delete anyway:"
                echo "  ws -d $name --force"
                return 1
            end
            echo "Removed worktree '$name'"
            if test -n "$branch" -a "$branch" != "main" -a "$branch" != "master"
                git -C $base_dir branch -D $branch 2>/dev/null
                echo "Deleted branch '$branch'"
            end
        end
        return
    end

    # Bootstrap the whole fleet from nothing: bare clone + remotes + main worktree
    if test "$argv[1]" = "setup"
        if test -d $base_dir/.bare
            echo "Fleet already set up at $base_dir"
        else
            mkdir -p $base_dir
            echo "Cloning alan-eu/alan-apps (bare)..."
            git clone --bare https://github.com/alan-eu/alan-apps.git $base_dir/.bare
            or return 1
            echo "gitdir: ./.bare" >$base_dir/.git
        end

        # fetch over https, push over ssh
        git -C $base_dir remote set-url origin https://github.com/alan-eu/alan-apps.git
        git -C $base_dir remote set-url --push origin git@github.com:alan-eu/alan-apps.git
        git -C $base_dir config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
        git -C $base_dir config fetch.prune true
        git -C $base_dir config fetch.prunetags true

        # private repo: https fetch needs gh as credential helper
        if gh auth status >/dev/null 2>&1
            gh auth setup-git 2>/dev/null
        else
            echo "Warning: gh not authenticated. Run 'gh auth login' then 'ws setup' again."
            return 1
        end

        echo "Fetching origin..."
        git -C $base_dir fetch origin
        or return 1

        # main worktree: symlink source for per-worktree local config
        if not test -d $main_dir
            git -C $base_dir worktree add $main_dir main
        end

        if not test -d $base_dir/.config
            echo "Warning: $base_dir/.config is missing - copy it from the previous machine"
            echo "(.custom_init_envrc + backend pytest.ini/pyrightconfig.json/custom_envrc/vscode launch.json)"
        end

        echo "Fleet ready. Try: ws --new"
        return
    end

    # Single letter shortcut: ws a → switch to alpha, ws b → switch to bravo, etc.
    if string match -qr -- '^[a-z]$' $argv[1]
        set -l nato_map a alpha b bravo c charlie d delta e echo f foxtrot g golf h hotel i india j juliet k kilo l lima m mike n november o oscar p papa q quebec r romeo s sierra t tango u uniform v victor w whiskey x xray y yankee z zulu
        set -l letter $argv[1]
        set -l idx (contains -i $letter $nato_map)
        if test -n "$idx"
            set -l name $nato_map[(math $idx + 1)]
            if tmux has-session -t $name 2>/dev/null
                if set -q TMUX
                    tmux switch-client -t $name
                else
                    tmux attach -t $name
                end
            else
                echo "No session '$name'"
                return 1
            end
        end
        return
    end

    # Create new worktree with next available NATO name
    if test "$argv[1]" = "--new"
        set -l nato alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu
        set -l existing (git -C $base_dir worktree list --porcelain | string match 'worktree *' | string replace 'worktree ' '' | xargs -n1 basename)
        for name in $nato
            if not contains $name $existing
                echo "Creating worktree '$name'..."
                ws $name
                return
            end
        end
        echo "All 26 NATO names are in use!"
        return 1
    end

    # Restore sessions for all existing worktrees
    if test "$argv[1]" = "restore"
        for wt in (git -C $base_dir worktree list --porcelain | string match 'worktree *' | string replace 'worktree ' '')
            set -l name (basename $wt)
            if test "$name" = "main"
                continue
            end
            echo "Restoring $name..."
            ws $name
        end
        return
    end

    # ws next / ws free → print best reuse slot to stdout (pipeable)
    if test "$argv[1]" = "next" -o "$argv[1]" = "free"
        set -l slot (__ws_pick_slot $base_dir)
        if test -z "$slot"
            echo "No reusable or free slot available." >&2
            return 1
        end
        echo $slot
        return
    end

    # ws find <branch|pr-number|pr-url>
    if test "$argv[1]" = "find"
        if test (count $argv) -lt 2
            echo "Usage: ws find <branch|pr-number|pr-url>" >&2
            return 1
        end
        set -l target $argv[2]
        # PR URL → number
        if string match -qr 'github\.com/.+/pull/\d+' $target
            set target (string replace -r '.*pull/(\d+).*' '$1' $target)
        end
        # Numeric → branch
        set -l branch
        if string match -qr '^\d+$' $target
            set branch (gh pr view $target --repo alan-eu/alan-apps --json headRefName --jq .headRefName 2>/dev/null)
            if test -z "$branch"
                echo "PR #$target not found" >&2
                return 1
            end
        else
            set branch $target
        end
        set -l rows (__ws_rows $base_dir)
        for row in $rows
            set -l p (string split '|' $row)
            if test "$p[3]" = "$branch"
                echo "Worktree: $p[2]"
                echo "  branch:  $p[3]"
                echo "  PR:      $p[4] $p[5]"
                echo "  CI:      $p[6]"
                echo "  dirty:   $p[7]"
                echo "  reuse:   $p[8]"
                echo "  age:     $p[9]"
                return
            end
        end
        echo "Branch '$branch' not checked out in any worktree."
        set -l slot (__ws_pick_slot $base_dir)
        if test -n "$slot"
            echo "Suggest:  ws $slot $branch"
            return
        end
        return 1
    end

    # List worktrees + PR status (+ filters, + JSON)
    if test "$argv[1]" = "status" -o "$argv[1]" = "-s"
        set -l filter ""
        set -l json 0
        if test (count $argv) -ge 2
            for a in $argv[2..]
                switch $a
                    case --reusable
                        set filter reusable
                    case --dirty
                        set filter dirty
                    case --mine-open
                        set filter mine-open
                    case --json
                        set json 1
                end
            end
        end

        set -l rows (__ws_rows $base_dir)

        set -l filtered
        for row in $rows
            set -l p (string split '|' $row)
            switch $filter
                case reusable
                    if test "$p[1]" -le 2; and test "$p[7]" = "clean"
                        set -a filtered $row
                    end
                case dirty
                    if test "$p[7]" != "clean"
                        set -a filtered $row
                    end
                case mine-open
                    if test "$p[5]" = OPEN -o "$p[5]" = "OPEN draft"
                        set -a filtered $row
                    end
                case '*'
                    set -a filtered $row
            end
        end

        if test $json -eq 1
            for row in $filtered
                set -l p (string split '|' $row)
                jq -n \
                    --arg name   "$p[2]" \
                    --arg branch "$p[3]" \
                    --arg pr     "$p[4]" \
                    --arg state  "$p[5]" \
                    --arg ci     "$p[6]" \
                    --arg dirty  "$p[7]" \
                    --arg reuse  "$p[8]" \
                    --arg age    "$p[9]" \
                    '{name:$name, branch:$branch, pr:$pr, state:$state, ci:$ci, dirty:$dirty, reuse:$reuse, age:$age}'
            end | jq -s .
            return
        end

        printf "%-10s %-50s %-7s %-12s %-8s %-10s %-16s %s\n" NAME BRANCH PR STATE CI DIRTY REUSE AGE
        printf "%-10s %-50s %-7s %-12s %-8s %-10s %-16s %s\n" ---- ------ -- ----- -- ----- ----- ---
        for row in $filtered
            set -l p (string split '|' $row)
            printf "%-10s %-50s %-7s %-12s %-8s %-10s %-16s %s\n" $p[2] $p[3] $p[4] $p[5] $p[6] $p[7] $p[8] $p[9]
        end
        return
    end

    # Delete session: ws -d <name> [--force]
    # Mark current worktree as ready: park on origin/main via ws-ready/<slot>
    if test "$argv[1]" = "ready"
        set -l cwd (pwd)
        set -l name (basename $cwd)
        set -l worktree_path $base_dir/$name
        if test "$cwd" != "$worktree_path"
            echo "Run `ws ready` from inside a worktree under $base_dir"
            return 1
        end
        if test "$name" = "main" -o "$name" = ".bare"
            echo "Refusing to mark '$name' as ready"
            return 1
        end
        set -l dirty_count (git -C $worktree_path status --porcelain | wc -l | string trim)
        if test "$dirty_count" != "0"
            echo "Worktree '$name' is dirty ($dirty_count files). Commit, stash, or discard first."
            return 1
        end
        echo "Fetching origin/main..."
        git -C $worktree_path fetch origin main
        git -C $worktree_path checkout -B ws-ready/$name origin/main
        echo "Worktree '$name' parked on ws-ready/$name (origin/main)"
        return
    end

    # ws <branch-name>: switch to existing worktree on this branch, or
    # allocate a free NATO slot and check it out there.
    set -l nato_names alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu
    if test (count $argv) -eq 1; and string match -q '*-*' $argv[1]; and not contains $argv[1] $nato_names
        # 1) Existing worktree already on this branch?
        for wt in (git -C $base_dir worktree list --porcelain | string match 'worktree *' | string replace 'worktree ' '')
            set -l wt_name (basename $wt)
            if test "$wt_name" = "main" -o "$wt_name" = ".bare"
                continue
            end
            set -l wt_branch (git -C $wt branch --show-current 2>/dev/null)
            if test "$wt_branch" = "$argv[1]"
                if tmux has-session -t $wt_name 2>/dev/null
                    if set -q TMUX
                        tmux switch-client -t $wt_name
                    else
                        tmux attach -t $wt_name
                    end
                    return
                else
                    echo "Worktree '$wt_name' has branch '$argv[1]' but no tmux session. Start it with: ws $wt_name"
                    return 1
                end
            end
        end

        # 2) No worktree has it — allocate a free NATO slot and check it out.
        set -l existing (git -C $base_dir worktree list --porcelain | string match 'worktree *' | string replace 'worktree ' '' | xargs -n1 basename)
        for slot in $nato_names
            if not contains $slot $existing
                echo "No worktree has branch '$argv[1]'. Allocating worktree '$slot'..."
                ws $slot $argv[1]
                return
            end
        end
        echo "Branch '$argv[1]' has no worktree and all NATO names are taken."
        return 1
    end

    set -l name $argv[1]
    set -l branch
    if test (count $argv) -ge 2
        set branch $argv[2]
    else
        set branch "abe-"(date +'%m%d')"-$name"
    end
    set -l session_name (string replace -ra '[^a-zA-Z0-9_-]' '_' $name)
    set -l worktree_path $base_dir/$name

    # Already exists: just switch (skip when --no-tmux)
    if test $no_tmux -eq 0; and tmux has-session -t $session_name 2>/dev/null
        if set -q TMUX
            tmux switch-client -t $session_name
        else
            tmux attach -t $session_name
        end
        return
    end

    # Create worktree if needed
    if not test -d $worktree_path
        echo "Creating worktree '$name' (branch: $branch)..."

        # Check whether branch already exists, pick the right `worktree add` form
        if git -C $base_dir show-ref --verify --quiet refs/heads/$branch
            # Local branch exists — check it out as-is
            git -C $base_dir worktree add $worktree_path $branch
        else if git -C $base_dir fetch origin $branch 2>/dev/null; and git -C $base_dir show-ref --verify --quiet refs/remotes/origin/$branch
            # Remote-only branch — create local tracking branch
            git -C $base_dir worktree add -b $branch $worktree_path origin/$branch
        else
            # Brand new branch off main
            git -C $base_dir worktree add -b $branch $name origin/main
        end

        # Shared envrc
        ln -sf ../.config/.custom_init_envrc $worktree_path/.custom_init_envrc

        # Claude/vscode/IDE symlinks
        mkdir -p $worktree_path/.claude $worktree_path/.vscode
        test -e $main_dir/.claude/settings.local.json && ln -sf $main_dir/.claude/settings.local.json $worktree_path/.claude/settings.local.json
        test -e $main_dir/CLAUDE.local.md && ln -sf $main_dir/CLAUDE.local.md $worktree_path/CLAUDE.local.md
        test -e $main_dir/backend/.env.aws && ln -sf $main_dir/backend/.env.aws $worktree_path/backend/.env.aws
        test -e $main_dir/.vscode/settings.json && ln -sf $main_dir/.vscode/settings.json $worktree_path/.vscode/settings.json
        test -e $main_dir/.vscode/launch.json && ln -sf $main_dir/.vscode/launch.json $worktree_path/.vscode/launch.json
        test -d $main_dir/.idea && ln -sfn $main_dir/.idea $worktree_path/.idea
        test -d $main_dir/backend/.idea && ln -sfn $main_dir/backend/.idea $worktree_path/backend/.idea
        test -d $main_dir/frontend/.idea && ln -sfn $main_dir/frontend/.idea $worktree_path/frontend/.idea

        # Backend config
        mkdir -p $worktree_path/backend/.vscode
        ln -sf $base_dir/.config/backend/vscode/launch.json $worktree_path/backend/.vscode/launch.json
        ln -sf $base_dir/.config/backend/pytest.ini $worktree_path/backend/pytest.ini
        ln -sf $base_dir/.config/backend/pyrightconfig.json $worktree_path/backend/pyrightconfig.json
        ln -sf $base_dir/.config/backend/custom_envrc $worktree_path/backend/.custom_envrc

        # Direnv: allow and pre-load environment (devbox + dependencies)
        direnv allow $worktree_path
        direnv allow $worktree_path/backend
        echo "Loading environment (devbox + dependencies)..."
        direnv exec $worktree_path true
    end

    # --no-tmux: worktree is ready, skip session creation and attach
    if test $no_tmux -eq 1
        echo "Worktree '$name' ready at $worktree_path (--no-tmux)"
        return
    end

    # Create tmux session with 4 windows
    echo "Creating tmux session '$session_name'..."
    tmux new-session -d -s $session_name -c $worktree_path -n nvim
    tmux send-keys -t $session_name:nvim 'nvim' Enter

    tmux new-window -t $session_name -c $worktree_path -n claude
    tmux send-keys -t $session_name:claude 'claude' Enter

    tmux new-window -t $session_name -c $worktree_path -n lazygit
    tmux send-keys -t $session_name:lazygit 'lazygit' Enter

    tmux new-window -t $session_name -c $worktree_path -n shell

    tmux select-window -t $session_name:claude

    # Notify and switch
    osascript -e 'display notification "Session '$session_name' ready" with title "ws" sound name "Glass"'

    if set -q TMUX
        tmux switch-client -t $session_name
    else
        tmux attach -t $session_name
    end
end
