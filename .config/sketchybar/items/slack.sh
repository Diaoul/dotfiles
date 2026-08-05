#!/bin/bash

# The same overlay pill as every other widget, with love glyphs and a love
# border. An inverted love fill was the loudest thing on the bar by a distance;
# the border draws the eye without turning the whole pill into a warning light.
#
# The glyph is a UTF-8 byte escape, not a literal: private-use characters get
# stripped on their way into these files, which is how the original icon here and
# in battery.sh were lost. U+F198 is nf-fa-slack.
SLACK_ICON=$(printf '\xef\x86\x98')

sketchybar --add item slack right \
           --set slack \
             update_freq=60 \
             icon="$SLACK_ICON" \
             icon.color="$LOVE" \
             label.color="$LOVE" \
             background.color="$OVERLAY" \
             background.border_color="$LOVE" \
             background.border_width=2 \
             background.drawing=on \
             script="$PLUGIN_DIR/slack.sh"
