#!/bin/bash
# to get the geometry of the windows and select the wallpaper accordingly:
#xdotool getwindowgeometry ${XSCREENSAVER_WINDOW} | rg --only-matching --replace '$1' 'Geometry: (.*)$'
feh --scale-down --zoom fill --window-id="${XSCREENSAVER_WINDOW}" "${XSECURELOCK_SAVER_WALLPAPER}"
