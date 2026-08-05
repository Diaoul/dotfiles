#!/bin/bash

# mouse.clicked / mouse.scrolled are handled in the plugin rather than through
# click_script, so all the volume logic lives in one place.
sketchybar --add item volume right \
           --set volume \
             icon.color="$IRIS" \
             label.color="$IRIS" \
             background.drawing=on \
             script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change mouse.clicked mouse.scrolled
