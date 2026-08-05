#!/bin/bash
# Now playing, from Spotify.
#
# nowplaying-cli is not installed and sketchybar's own media_change event rides
# on MediaRemote, which recent macOS releases no longer expose to third parties.
# Talking to Spotify directly is the route that actually works. The pgrep guard
# matters: querying a stopped app would launch it.

source "$CONFIG_DIR/colors.sh"

if ! pgrep -x Spotify > /dev/null; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# one osascript round trip, not one per field
info=$(osascript 2>/dev/null <<'APPLESCRIPT'
tell application "Spotify"
  if player state is playing then
    return artist of current track & " – " & name of current track
  end if
end tell
APPLESCRIPT
)

if [[ -z $info ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

sketchybar --set "$NAME" \
  drawing=on \
  icon=󰝙 \
  icon.color="$ROSE" \
  label="$info" \
  label.color="$ROSE"
