#!/bin/bash

# Glyph as a UTF-8 byte escape: U+F00F0, md-calendar-clock.
CAL_ICON=$(printf '\xf3\xb0\x83\xb0')

# 15s rather than 60s: an unaligned 60s tick leaves the minute up to 59s stale
sketchybar --add item datetime right \
           --set datetime \
             update_freq=15 \
             icon="$CAL_ICON" \
             icon.color="$PINE" \
             label.color="$PINE" \
             background.drawing=on \
             script="$PLUGIN_DIR/datetime.sh"
