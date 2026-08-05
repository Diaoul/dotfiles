#!/bin/bash

# Icon-only, so icon.padding_right has to act as the pill's right edge: the
# inherited value is the glyph-to-label gap, which leaves the pill lopsided.
sketchybar --add item network right \
           --set network \
             update_freq=30 \
             icon.padding_right=11 \
             background.drawing=on \
             script="$PLUGIN_DIR/network.sh" \
           --subscribe network wifi_change system_woke
