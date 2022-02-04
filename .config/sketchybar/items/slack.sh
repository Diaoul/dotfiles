#!/bin/bash

sketchybar --add item slack right \
           --set slack \
             update_freq=60 \
             icon= \
             script="$PLUGIN_DIR/slack.sh" \
             icon.color="$BACKGROUND" \
             label.color="$BACKGROUND" \
             background.color="$RED"
