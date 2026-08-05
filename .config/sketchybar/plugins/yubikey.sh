#!/bin/bash

# Driven by the yubikey_touch event, which yubikey-touch-detector.sh triggers on
# every state change. The state file is the source of truth rather than the event
# carrying a payload, so a bar reload mid-touch still draws the right thing.
if [ -f /tmp/yubikey-touch.state ]; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
