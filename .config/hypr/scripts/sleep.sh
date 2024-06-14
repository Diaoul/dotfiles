#!/usr/bin/env bash
set -euo pipefail

swayidle -w \
  lock 'swaylock -f' \
  timeout 180 'swaylock -f' \
  timeout 120 '[ "$(cat /sys/class/power_supply/AC/online)" = "0" ] && brightnessctl -d intel_backlight -c backlight -s && brightnessctl -d intel_backlight -c backlight set 5%' \
  resume 'brightnessctl -d intel_backlight -c backlight -r' \
  timeout 300 '[ "$(cat /sys/class/power_supply/AC/online)" = "0" ] && hyprctl dispatch dpms off' \
  resume 'hyprctl dispatch dpms on' \
  timeout 600 '[ "$(cat /sys/class/power_supply/AC/online)" = "0" ] && systemctl suspend' \
  resume 'hyprctl dispatch dpms on' \
  timeout 600 '[ "$(cat /sys/class/power_supply/AC/online)" = "1" ] && hyprctl dispatch dpms off' \
  resume 'hyprctl dispatch dpms on' \
  timeout 1200 '[ "$(cat /sys/class/power_supply/AC/online)" = "1" ] && systemctl suspend' \
  resume 'hyprctl dispatch dpms on' \
  before-sleep 'swaylock -f'
