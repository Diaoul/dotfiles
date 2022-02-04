#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=300 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
