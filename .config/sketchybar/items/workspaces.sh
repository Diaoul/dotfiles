#!/bin/bash

source "$CONFIG_DIR/utils/aerospace.sh"

sketchybar --add event aerospace_workspace_change

for monitor in $(aerospace list-monitors | awk '{print $1}'); do
  for sid in $(aerospace list-workspaces --monitor "$monitor"); do

    monitor_id=${WORKSPACE_TO_MONITOR_ID[$sid]}
    echo "Monitor $monitor with space $sid to monitor_id ${WORKSPACE_TO_MONITOR_ID[$sid]}" >> /tmp/sketchybar.log

    create_workspace "$sid"

  done
done

# Render a unique instance of a separator that will handle all the event handling
# and avoid duplication
sketchybar --add item space_separator left \
           --set space_separator \
             display="active" \
             icon="􀆊" \
             icon.color="$ACCENT_COLOR" \
             label.drawing=off \
             background.drawing=off \
             script="$PLUGIN_DIR/aerospace.sh" \
           --subscribe space_separator space_windows_change \
           --subscribe space_separator aerospace_workspace_change
