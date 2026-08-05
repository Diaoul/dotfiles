#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Material Design battery glyphs, spelled as UTF-8 byte escapes rather than
# pasted in as literals: private-use characters do not survive every editing
# path, and this file has already lost its icons once that way, leaving `ICON=""`
# empty and the battery drawing no glyph at all.
BAT_FULL=$(printf '\xf3\xb0\x81\xb9')    # U+F0079
BAT_90=$(printf '\xf3\xb0\x82\x82')      # U+F0082
BAT_70=$(printf '\xf3\xb0\x82\x80')      # U+F0080
BAT_50=$(printf '\xf3\xb0\x81\xbe')      # U+F007E
BAT_30=$(printf '\xf3\xb0\x81\xbc')      # U+F007C
BAT_10=$(printf '\xf3\xb0\x81\xba')      # U+F007A
BAT_ALERT=$(printf '\xf3\xb0\x82\x83')   # U+F0083
BAT_CHARGE=$(printf '\xf3\xb0\x82\x84')  # U+F0084

# one pmset call, not two: it is the slowest thing in this script
BATT="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT" | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(echo "$BATT" | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if   (( PERCENTAGE >= 95 )); then ICON=$BAT_FULL
elif (( PERCENTAGE >= 85 )); then ICON=$BAT_90
elif (( PERCENTAGE >= 70 )); then ICON=$BAT_70
elif (( PERCENTAGE >= 50 )); then ICON=$BAT_50
elif (( PERCENTAGE >= 30 )); then ICON=$BAT_30
elif (( PERCENTAGE >= 10 )); then ICON=$BAT_10
else                              ICON=$BAT_ALERT
fi

# colour carries the urgency, so a low battery is noticeable without a glance
if   (( PERCENTAGE <= 15 )); then COLOR="$LOVE"
elif (( PERCENTAGE <= 30 )); then COLOR="$GOLD"
else                              COLOR="$WHITE"
fi

if [[ -n "$CHARGING" ]]; then
  ICON=$BAT_CHARGE
  COLOR="$FOAM"
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR" \
  label="${PERCENTAGE}%" \
  label.color="$COLOR"
