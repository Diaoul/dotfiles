#!/usr/bin/env bash

source "$CONFIG_DIR/utils/aerospace.sh"

sketchybar --add event aerospace_workspace_change

# One window query and one sketchybar call for all workspaces. list-workspaces
# --all is sorted, so items still land left-to-right in order on each display.
build_workspace_states
build_workspace_icons

while IFS= read -r sid; do
  create_workspace "$sid"
done < <(aerospace list-workspaces --all)

sb_flush

# Invisible single instance that owns the workspace event handling, so the work
# happens once per event rather than once per workspace item.
sketchybar --add item workspace_events left \
           --set workspace_events \
             drawing=off \
             script="$PLUGIN_DIR/aerospace.sh" \
           --subscribe workspace_events \
             space_windows_change \
             aerospace_workspace_change

# Invisible item that rebuilds the workspace strip when monitors come or go:
# each workspace item is pinned to a display index when it is created, so those
# indexes go stale on dock/undock and nothing else would recreate them.
# Recording the arrangement the items were just built against keeps the first
# display_change after startup from triggering a needless rebuild — except when
# display_change.sh has just failed to redistribute and left the old arrangement
# recorded on purpose, so that the next event retries.
save_display_fingerprint_unless_retry

sketchybar --add item display_events left \
           --set display_events \
             drawing=off \
             script="$PLUGIN_DIR/display_change.sh" \
           --subscribe display_events display_change
