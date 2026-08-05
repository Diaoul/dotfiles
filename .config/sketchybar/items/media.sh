#!/bin/bash

sketchybar --add item media right \
           --set media \
             update_freq=10 \
             label.max_chars=32 \
             icon.color="$ROSE" \
             label.color="$ROSE" \
             background.drawing=on \
             script="$PLUGIN_DIR/media.sh"
