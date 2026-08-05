#!/usr/bin/env bash
# display_change handler.
#
# sketchybar fires display_change both when the monitor arrangement changes
# (dock, undock, projector, resolution change) and when merely the *active*
# display changes — which happens on every `move-node-to-monitor
# --focus-follows-window`. Only the first case invalidates anything: workspace
# items are pinned to a sketchybar display index when they are created, so their
# indexes go stale and the items must be rebuilt.
#
# Rebuilding means a full `sketchybar --reload`, which visibly flashes the bar,
# so compare the arrangement fingerprint first and do nothing on a plain
# active-display change.

source "$CONFIG_DIR/utils/aerospace.sh"

[[ $SENDER == "display_change" ]] || exit 0

if [[ $(display_fingerprint) == "$(cat "$DISPLAY_FINGERPRINT_FILE" 2>/dev/null)" ]]; then
  sb_log "active display changed, arrangement unchanged, nothing to do"
  exit 0
fi

# macOS emits a burst of display_change events while the displays settle;
# the first one takes the lock and waits it out, the rest drop.
lock=/tmp/sketchybar-display-change.lock

if ! mkdir "$lock" 2>/dev/null; then
  # The EXIT trap below releases the lock on a normal or signalled exit, but not
  # on SIGKILL. A leftover lock would drop every later arrangement change
  # silently, so reclaim one that has outlived any plausible run.
  [[ -n $(find "$lock" -maxdepth 0 -mmin +1 2>/dev/null) ]] || exit 0
  sb_log "reclaiming stale display-change lock"
  rmdir "$lock" 2>/dev/null
  mkdir "$lock" 2>/dev/null || exit 0
fi
trap 'rmdir "$lock" 2>/dev/null' EXIT
sleep 2

sb_log "display arrangement changed, redistributing workspaces"

"$HOME/.config/aerospace/scripts/workspaces.sh"

# record the settled arrangement, not the one that triggered this run
save_display_fingerprint
sketchybar --reload
