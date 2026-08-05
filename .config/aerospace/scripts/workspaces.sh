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

set -u

# callers are GUI processes with a bare launchd PATH, which has no Homebrew prefix
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

WORKSPACES=(1 2 3 4 5 6 7 8 9 10)

monitor_count=$(aerospace list-monitors --format '%{monitor-id}' | grep -c .)

# workspaces per monitor, left to right; must sum to ${#WORKSPACES[@]}
case "$monitor_count" in
  0)
    exit 0
    ;;
  1)
    # aerospace already keeps everything on the only monitor
    exit 0
    ;;
  2)
    split=(5 5)
    ;;
  3)
    split=(3 4 3)
    ;;
  *)
    # even split, remainder to the leftmost monitors
    split=()
    base=$(( ${#WORKSPACES[@]} / monitor_count ))
    extra=$(( ${#WORKSPACES[@]} % monitor_count ))
    for (( m = 0; m < monitor_count; m++ )); do
      if (( m < extra )); then
        split+=( $(( base + 1 )) )
      else
        split+=( "$base" )
      fi
    done
    ;;
esac

# move-workspace-to-monitor pulls focus along with the workspace it moves, which
# would leave you on an arbitrary workspace after every dock or undock
focused=$(aerospace list-workspaces --focused --format '%{workspace}')

index=0
for (( m = 0; m < monitor_count; m++ )); do
  for (( i = 0; i < ${split[m]}; i++ )); do
    aerospace move-workspace-to-monitor \
      --workspace "${WORKSPACES[index]}" "$(( m + 1 ))"
    index=$(( index + 1 ))
  done
done

# prints an "already focused" tip on stderr when the focus never moved, which is
# the common case: not an error, so drop both streams
aerospace workspace "$focused" > /dev/null 2>&1
