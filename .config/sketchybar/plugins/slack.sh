#!/bin/bash

label=$(lsappinfo info -only StatusLabel Slack | sed -n 's/.*"label"="\(.*\)".*/\1/p')

# The badge is usually a mention count, but Slack also sets it to a bullet for
# unread-without-mention. A string comparison keeps both working; the previous
# `-gt 0` test made bash abort with "integer expression expected" on a bullet.
if [[ -n $label && $label != "0" ]]; then
  sketchybar --set "$NAME" \
    drawing=on \
    label="$label"
else
  sketchybar --set "$NAME" \
    drawing=off
fi
