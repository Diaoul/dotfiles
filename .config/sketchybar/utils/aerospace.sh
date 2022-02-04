#!/bin/bash

get_focused_workspace() {
  if [[ -z ${_FOCUSED_WORKSPACE_LOADED:-} ]]; then
    declare -g FOCUSED_WORKSPACE
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused --format "%{workspace}")
    _FOCUSED_WORKSPACE_LOADED=1
  fi
}

get_workspace_to_monitor_id() {
  declare -A monitor_map
  monitor_map[1]=1
  monitor_map[2]=2
  monitor_map[3]=3
  if [[ -z ${_WORKSPACE_TO_MONITOR_LOADED:-} ]]; then
    declare -gA WORKSPACE_TO_MONITOR_ID
    while IFS=$'\t' read -r workspace monitor; do
      WORKSPACE_TO_MONITOR_ID["$workspace"]="${monitor_map[$monitor]}"
    done < <(aerospace list-workspaces --all --json --format "%{workspace}%{monitor-appkit-nsscreen-screens-id}" | jq -r '.[] | [.workspace, ."monitor-appkit-nsscreen-screens-id"] | @tsv')
    _WORKSPACE_TO_MONITOR_LOADED=1
  fi
}

workspace_app_icons() {
  local sid=$1
  local icons=""
  local app

  IFS=$'\n'
  for app in $(aerospace list-windows --workspace "$sid" --json --format "%{app-name}" | jq -r "map ( .\"app-name\" ) | .[]"); do
    icons+=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app")
    icons+="  "
  done
  echo "$icons"
}

focus_workspace() {
  local sid=$1

  refresh_icons "$sid"
  sketchybar --set space."$sid" \
               label.color="$BACKGROUND" \
               icon.color="$BACKGROUND" \
               background.color="$ACCENT_COLOR"

}

unfocus_workspace() {
  local sid=$1

  refresh_icons "$sid"
  sketchybar --set space."$sid" \
               label.color="$ACCENT_COLOR" \
               icon.color="$ACCENT_COLOR" \
               background.color="$BACKGROUND_LIGHT"

}

refresh_icons() {
  local sid=$1
  local icons

  icons=$(workspace_app_icons "$sid")

  # show workspaces without window
  local label_drawing="off"
  if [[ -n $icons ]]; then
    label_drawing="on"
  fi

  sketchybar --set space."$sid" \
               label="$icons" \
               label.drawing="$label_drawing"

}

create_workspace() {
  local sid=$1
  local is_focused=false
  local icons
  local monitor_id

  # build up the cache
  get_workspace_to_monitor_id
  get_focused_workspace

  monitor_id=${WORKSPACE_TO_MONITOR_ID[$sid]}
  if [[ "$sid" == "$FOCUSED_WORKSPACE" ]]; then
    is_focused=true
  fi

  echo "Creating workspace $sid on monitor $monitor_id" >> /tmp/sketchybar.log

  sketchybar --add item space."$sid" left \
    --set space."$sid" \
      display="$monitor_id" \
      icon="$sid" \
      icon.padding_left=6 \
      icon.padding_right=8 \
      label.font="sketchybar-app-font:Regular:16.0" \
      label.padding_left=6 \
      label.padding_right=8 \
      label.y_offset=-1 \
      click_script="aerospace workspace $sid"

  refresh_icons "$sid"

  if $is_focused; then
    focus_workspace "$sid"
  else
    unfocus_workspace "$sid"
  fi
}
