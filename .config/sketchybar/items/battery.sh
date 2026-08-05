#!/bin/bash

# icon and label colours come from the plugin: they track charge state
sketchybar --add item battery right \
           --set battery \
             update_freq=300 \
             background.drawing=on \
             script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
