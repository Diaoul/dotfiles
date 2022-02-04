#!/bin/bash

sketchybar --add item datetime right \
           --set datetime update_freq=60 icon=󰃰 script="$PLUGIN_DIR/datetime.sh"
