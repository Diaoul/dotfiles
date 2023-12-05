#!/usr/bin/env bash
set -euo pipefail

swayidle -w \
  timeout 300 'swaylock -f' \
  timeout 600 'hyprctl dispatch dpms off' \
  timeout 900 'systemctl suspend' \
  resume 'hyprctl dispatch dpms on' \
  before-sleep 'swaylock -f' \
  lock 'swaylock -f'
