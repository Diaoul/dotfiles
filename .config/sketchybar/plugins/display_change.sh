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
#
# That same fingerprint is what suppresses every later event, so it is recorded
# only once the workspaces have actually been redistributed *and* the
# arrangement they were redistributed against is still the current one.
# Recording it after a run that raced a half-finished dock would pin the wrong
# layout in place with nothing left to trigger a retry.

source "$CONFIG_DIR/utils/aerospace.sh"

[[ $SENDER == "display_change" ]] || exit 0

if [[ $(display_fingerprint) == "$(cat "$DISPLAY_FINGERPRINT_FILE" 2>/dev/null)" ]]; then
  sb_log "active display changed, arrangement unchanged, nothing to do"
  exit 0
fi

# macOS emits a burst of display_change events while the displays settle; the
# first one takes the lock and handles the whole burst, the rest drop. Waiting
# the burst out is workspaces.sh's job — it polls until aerospace's monitor
# count holds still — so a single run can legitimately last tens of seconds.
lock=/tmp/sketchybar-display-change.lock

if ! mkdir "$lock" 2>/dev/null; then
  # The EXIT trap below releases the lock on a normal or signalled exit, but not
  # on SIGKILL. A leftover lock would drop every later arrangement change
  # silently, so reclaim one that has outlived any plausible run.
  [[ -n $(find "$lock" -maxdepth 0 -mmin +3 2>/dev/null) ]] || exit 0
  sb_log "reclaiming stale display-change lock"
  rmdir "$lock" 2>/dev/null
  mkdir "$lock" 2>/dev/null || exit 0
fi
trap 'rmdir "$lock" 2>/dev/null' EXIT

# Events arriving while the lock is held are dropped, so nothing else is coming
# to correct a pass that the arrangement moved out from under. Redistribute
# against the arrangement seen at the start of a pass and accept the result only
# if that is still the arrangement afterwards.
handled=""

for attempt in 1 2 3; do
  target=$(display_fingerprint)
  sb_log "display arrangement changed, redistributing workspaces (pass $attempt)"

  if WORKSPACES_SH_NO_RELOAD=1 "$HOME/.config/aerospace/scripts/workspaces.sh"; then
    if [[ $(display_fingerprint) == "$target" ]]; then
      handled=$target
      break
    fi
    sb_log "arrangement moved again during pass $attempt"
  else
    sb_log "workspaces.sh did not land the layout on pass $attempt"
  fi

  sleep 1
done

if [[ -n $handled ]]; then
  printf '%s\n' "$handled" > "$DISPLAY_FINGERPRINT_FILE"
  rm -f "$DISPLAY_RETRY_FILE"
else
  # Leave the recorded arrangement stale so the next display_change tries again
  # rather than being dismissed as a no-op. The rebuild below would otherwise
  # overwrite it with the current arrangement; the marker tells it not to.
  sb_log "giving up on this burst; next display_change will retry"
  : > "$DISPLAY_RETRY_FILE"
fi

# The bar is rebuilt either way: the workspace items are pinned to display
# indexes that are stale the moment a monitor comes or goes, whether or not the
# workspaces themselves ended up where they should be.
sketchybar --reload
