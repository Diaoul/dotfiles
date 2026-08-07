#!/bin/bash
# Spread the workspaces over whatever monitors are currently attached.
#
# Deliberately count-based and not [workspace-to-monitor-force-assignment]:
# that table matches on monitor names, so it falls apart on any setup built from
# a different set of screens (office desk, meeting room, projector). Monitor
# indexes here are aerospace's own left-to-right ordering, so they hold for any
# hardware.
#
# Run at login by after-startup-command, and again on every monitor arrangement
# change by sketchybar's display_change handler.
#
# Docking brings the panels up one at a time and aerospace registers them later
# than sketchybar reports them, so the monitor count is read only once it has
# stopped moving, and the placement is checked afterwards instead of being
# assumed. The exit status says whether the layout actually landed: a caller
# that suppresses later runs (display_change.sh does, via its arrangement
# fingerprint) must not record the arrangement as handled unless it did.

set -u

# callers are GUI processes with a bare launchd PATH, which has no Homebrew prefix
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

# The workspaces that get a fixed place. Anything outside this list exists ad hoc
# — a stray move-node-to-workspace, or aerospace inventing one for a monitor that
# would otherwise have none — and is appended to the rightmost monitor rather
# than shifted into the split, so where 1-10 land never depends on whether a
# stray workspace happens to exist at the time.
BASE_WORKSPACES=(1 2 3 4 5 6 7 8 9 10)

SETTLE_INTERVAL=0.5
SETTLE_STABLE_READS=4   # half a second apart, so 2s of no change before trusting it
SETTLE_MAX_POLLS=40     # 20s ceiling; a dock driving two panels can take that long
MAX_ATTEMPTS=3

# Shares sketchybar's log, since that is where the caller's own lines go. Off
# unless SKETCHYBAR_DEBUG is set in the environment of whatever started the
# daemon — see the note in sketchybar's utils/aerospace.sh.
log() {
  [[ -n ${SKETCHYBAR_DEBUG:-} ]] || return 0
  echo "$(date '+%H:%M:%S') workspaces.sh: $*" >> "${SKETCHYBAR_LOG:-/tmp/sketchybar.log}"
}

monitor_count() {
  aerospace list-monitors --format '%{monitor-id}' | grep -c .
}

# Read the monitor count only once it has held still for SETTLE_STABLE_READS in
# a row. Without this the count is whatever the arrangement happened to be
# partway through a dock, and every monitor that had not come up yet gets no
# workspaces at all.
settled_monitor_count() {
  local count last='' stable=0 polls=0
  while (( polls < SETTLE_MAX_POLLS )); do
    count=$(monitor_count)
    if [[ $count == "$last" ]]; then
      stable=$(( stable + 1 ))
      if (( stable >= SETTLE_STABLE_READS )); then
        echo "$count"
        return 0
      fi
    else
      stable=1
      last=$count
    fi
    sleep "$SETTLE_INTERVAL"
    polls=$(( polls + 1 ))
  done
  echo "$last"
  return 1
}

# Workspaces per monitor, left to right. The shape is taste rather than
# arithmetic — the centre screen is the big one and earns the extra workspace —
# so it is only used when it still adds up to the number of base workspaces.
weights_for() {
  case "$1" in
    2) echo "5 5" ;;
    3) echo "3 4 3" ;;
    *) echo "" ;;
  esac
}

# sets `split`
build_split() {
  local monitors=$1
  local w=() sum=0 x base extra m

  read -r -a w <<< "$(weights_for "$monitors")"
  if (( ${#w[@]} == monitors )); then
    for x in "${w[@]}"; do sum=$(( sum + x )); done
    if (( sum == ${#BASE_WORKSPACES[@]} )); then
      split=( "${w[@]}" )
      return 0
    fi
  fi

  # even split, remainder to the leftmost monitors
  split=()
  base=$(( ${#BASE_WORKSPACES[@]} / monitors ))
  extra=$(( ${#BASE_WORKSPACES[@]} % monitors ))
  for (( m = 0; m < monitors; m++ )); do
    if (( m < extra )); then
      split+=( $(( base + 1 )) )
    else
      split+=( "$base" )
    fi
  done
}

# Workspaces holding windows that are not in BASE_WORKSPACES. Empty ad-hoc
# workspaces are skipped on purpose: aerospace drops them the moment they stop
# being visible, so moving one is a no-op that the verify step would then read
# as a failure.
extra_workspaces() {
  local ws
  while IFS= read -r ws; do
    [[ -n $ws ]] || continue
    case " ${BASE_WORKSPACES[*]} " in *" $ws "*) continue ;; esac
    echo "$ws"
  done < <(aerospace list-windows --all --format '%{workspace}' | sort -u)
}

# sets `plan_ws` / `plan_mon`, parallel arrays
build_plan() {
  local monitors=$1
  local index=0 m i ws

  plan_ws=()
  plan_mon=()

  for (( m = 0; m < monitors; m++ )); do
    for (( i = 0; i < ${split[m]}; i++ )); do
      plan_ws+=( "${BASE_WORKSPACES[index]}" )
      plan_mon+=( "$(( m + 1 ))" )
      index=$(( index + 1 ))
    done
  done

  while IFS= read -r ws; do
    plan_ws+=( "$ws" )
    plan_mon+=( "$monitors" )
  done < <(extra_workspaces)
}

# One failed move does not invalidate the rest, so keep going and let the verify
# step decide whether the layout as a whole is usable.
apply_plan() {
  local i out
  for (( i = 0; i < ${#plan_ws[@]}; i++ )); do
    out=$(aerospace move-workspace-to-monitor \
      --workspace "${plan_ws[i]}" "${plan_mon[i]}" 2>&1) ||
      log "moving workspace ${plan_ws[i]} to monitor ${plan_mon[i]} failed: $out"
  done
}

verify_plan() {
  local actual i ws want
  actual=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

  for (( i = 0; i < ${#plan_ws[@]}; i++ )); do
    ws=${plan_ws[i]}
    want=${plan_mon[i]}
    case $'\n'"$actual"$'\n' in
      *$'\n'"$ws|$want"$'\n'*) ;;
      *$'\n'"$ws|"*)
        log "workspace $ws is not on monitor $want"
        return 1
        ;;
      # gone between the move and the check: a workspace whose last window was
      # closed mid-run stops existing, which is not a placement failure
      *) ;;
    esac
  done
}

monitors=$(settled_monitor_count) ||
  log "monitor count never settled, going with $monitors"

# 0 monitors is a machine with the lid shut and nothing attached; 1 needs no
# work, aerospace already keeps everything on the only screen. Both are a
# correct outcome, so they exit 0 and the caller records the arrangement.
if (( monitors < 2 )); then
  exit 0
fi

# move-workspace-to-monitor pulls focus along with the workspace it moves, which
# would leave you on an arbitrary workspace after every dock or undock
focused=$(aerospace list-workspaces --focused --format '%{workspace}')

build_split "$monitors"

rc=1
for (( attempt = 1; attempt <= MAX_ATTEMPTS; attempt++ )); do
  # the arrangement can move again under a run that is already in progress —
  # a second panel waking, or a dock pulled straight back out
  now=$(monitor_count)
  if (( now != monitors )); then
    log "monitor count moved $monitors -> $now, waiting for it to settle again"
    monitors=$(settled_monitor_count) || true
    if (( monitors < 2 )); then
      rc=0
      break
    fi
    build_split "$monitors"
  fi

  build_plan "$monitors"
  apply_plan
  if verify_plan; then
    rc=0
    break
  fi

  log "attempt $attempt did not land the layout"
  sleep 1
done

# prints an "already focused" tip on stderr when the focus never moved, which is
# the common case: not an error, so drop both streams
aerospace workspace "$focused" > /dev/null 2>&1

# Each sketchybar workspace item is pinned to the display index its workspace
# was on when the item was built, and only a rebuild re-pins it. Started from
# aerospace's after-startup-command this script races the bar's first build, so
# those indexes can already be stale by the time it finishes. display_change.sh
# reloads on its own and sets this to say so.
if (( rc == 0 )) && [[ -z ${WORKSPACES_SH_NO_RELOAD:-} ]]; then
  pgrep -x sketchybar > /dev/null && sketchybar --reload
fi

exit "$rc"
