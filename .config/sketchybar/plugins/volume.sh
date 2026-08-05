#!/bin/bash
#
# Interactions: scroll over the pill to nudge the volume, click to toggle mute.
#
# Neither interaction draws anything itself: both `set volume` and toggling mute
# make macOS emit volume_change, and that branch does all the rendering. Writing
# the pill from the interaction branches as well made it visibly flicker through
# two states per click.
#
# Glyphs are UTF-8 byte escapes rather than literals, since private-use
# characters do not survive every editing path.
VOL_HIGH=$(printf '\xf3\xb0\x95\xbe')  # U+F057E
VOL_MED=$(printf '\xf3\xb0\x96\x80')   # U+F0580
VOL_LOW=$(printf '\xf3\xb0\x95\xbf')   # U+F057F
VOL_OFF=$(printf '\xf3\xb0\x96\x81')   # U+F0581

# Records what a scroll event actually carried, so a misbehaving direction can be
# diagnosed from the payload instead of guessed at. Off unless the daemon was
# started with SKETCHYBAR_DEBUG set.
sb_scroll_log() {
  [[ -n ${SKETCHYBAR_DEBUG:-} ]] || return 0
  echo "$(date '+%H:%M:%S') volume scroll $*" >> "${SKETCHYBAR_LOG:-/tmp/sketchybar.log}"
}

render() {
  VOLUME=$1

  case "$VOLUME" in
    [6-9][0-9]|100) ICON=$VOL_HIGH
    ;;
    [3-5][0-9]) ICON=$VOL_MED
    ;;
    [1-9]|[1-2][0-9]) ICON=$VOL_LOW
    ;;
    *) ICON=$VOL_OFF
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
}

case "$SENDER" in
  volume_change)
    # adjusting the volume by any route unmutes on macOS, so no mute check here
    render "$INFO"
    ;;

  mouse.clicked)
    # muting emits volume_change with INFO=0, which renders as 0% and the
    # level-0 glyph, so there is nothing to draw here
    osascript -e 'set volume output muted not (output muted of (get volume settings))'
    ;;

  mouse.scrolled)
    # The delta arrives as SCROLL_DELTA on some sketchybar versions and as INFO on
    # others, so accept either.
    delta=${SCROLL_DELTA:-${INFO:-}}
    sb_scroll_log "delta=[$delta] INFO=[${INFO:-}] SCROLL_DELTA=[${SCROLL_DELTA:-}]"

    # Ignore a delta that is numerically zero, whatever it is spelled as: strip
    # the sign, then the dots and zeros, and see whether any digit is left.
    # Pattern-matching the text instead would swallow "0.9", which is a real
    # scroll, not a still mouse.
    magnitude=${delta#[-+]}
    magnitude=${magnitude//[.0]/}
    [[ -z $magnitude ]] && exit 0

    # Direction comes from the *string*, not from a rounded integer: a trackpad
    # emits small fractional deltas, and `printf '%.0f' -0.4` gives "-0", which
    # is not arithmetically less than zero, so every gentle scroll down used to
    # read as a scroll up.
    if [[ $delta == -* ]]; then
      step=-5
    else
      step=5
    fi

    current=$(osascript -e 'output volume of (get volume settings)')
    next=$(( current + step ))
    (( next > 100 )) && next=100
    (( next < 0 )) && next=0
    osascript -e "set volume output volume $next"
    ;;
esac
