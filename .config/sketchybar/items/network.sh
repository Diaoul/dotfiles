#!/bin/bash

# Icon-only, so icon.padding_right has to act as the pill's right edge: the
# inherited value is the glyph-to-label gap, which leaves the pill lopsided.
#
# The label starts off because an empty label still takes its insets in the
# layout, which would widen the pill for the one frame between the item being
# added and the plugin's first run. The plugin owns it from then on: off when the
# icon says everything, on to spell out "offline".
sketchybar --add item network right \
           --set network \
             update_freq=30 \
             icon.padding_right=11 \
             label.drawing=off \
             background.drawing=on \
             script="$PLUGIN_DIR/network.sh" \
           --subscribe network wifi_change system_woke
