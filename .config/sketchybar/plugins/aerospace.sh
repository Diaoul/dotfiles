#!/bin/bash
# this script manages the workspace event handling

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/aerospace.sh"

if [ "$SENDER" == "aerospace_workspace_change" ]; then
  echo "Focusing $FOCUSED_WORKSPACE from $PREV_WORKSPACE" >> /tmp/sketchybar.log

  focus_workspace "$FOCUSED_WORKSPACE"
  unfocus_workspace "$PREV_WORKSPACE"
elif [ "$SENDER" == "space_windows_change" ]; then
  sid=$(aerospace list-workspaces --focused --format "%{workspace}")
  echo "Refreshing icons on $sid" >> /tmp/sketchybar.log

  refresh_icons "$sid"
else
  echo "Unknown event $SENDER" >> /tmp/sketchybar.log
fi

