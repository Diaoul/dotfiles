#!/usr/bin/env bash
set -uo pipefail

CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css $HOME/.config/waybar/default-modules"

# kill waybar on exit
trap "killall waybar" EXIT

while true; do
    # start waybar if not running already
    pgrep waybar || waybar &

    # wait for config file changes
    # shellcheck disable=SC2086
    inotifywait -e create,modify $CONFIG_FILES

    # reload waybar
    killall -SIGUSR2 waybar
done
