#!/bin/bash

source "$CONFIG_DIR/colors.sh"

label=$(lsappinfo info -only StatusLabel Slack | sed -n 's/.*"label"="\(.*\)".*/\1/p')

if [[ "$label" -gt 0 ]]; then
  sketchybar --set "$NAME" \
    drawing=on \
    label="$label"
else
  sketchybar --set "$NAME" \
    drawing=off
fi
