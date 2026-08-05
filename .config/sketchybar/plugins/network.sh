#!/bin/bash
# Wired / wireless / offline.
#
# The link that matters is whichever one carries the default route, so ask the
# routing table rather than walking every interface. Telling wired from wireless
# is then just "does this interface have an SSID": one ipconfig call, ~4ms, and
# it needs no privileged framework (the airport binary is gone since Sonoma).

source "$CONFIG_DIR/colors.sh"

interface=$(route -n get default 2>/dev/null | awk '/interface:/ { print $2 }')

if [[ -z $interface ]]; then
  sketchybar --set "$NAME" \
    icon=󰖪 \
    icon.color="$RED" \
    label="offline" \
    label.color="$RED" \
    label.drawing=on
  exit 0
fi

if ipconfig getsummary "$interface" 2>/dev/null | grep -qE '^[[:space:]]+SSID'; then
  icon=󰖩
else
  icon=󰈀
fi

# the interface name is the useful detail when something is odd, but it is noise
# the other 99% of the time, so the icon carries the state on its own
sketchybar --set "$NAME" \
  icon="$icon" \
  icon.color="$GOLD" \
  label.drawing=off
