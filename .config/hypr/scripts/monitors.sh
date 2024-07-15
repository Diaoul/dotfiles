#!/usr/bin/env bash
set -euo pipefail

declare -i last_called=0
declare -i throttle_by=4

@throttle() {
  # shellcheck disable=SC2155
  local -i now=$(date +%s)
  if ((now - last_called > throttle_by))
  then
    # delay execution
    sleep $throttle_by
    # execute
    "$@"
  fi
  last_called=$(date +%s)
}

function move_workspace() {
    workspaces_json="$1"
    id=$2
    monitor=$3

    # configure workspace
    workspace_json=$(echo "$workspaces_json" | jq -r ".[] | select(.id == $id)")
    current_monitor=$(echo "$workspaces_json" | jq -r ".[] | select(.id == $id).monitor")
    if [ -z "$workspace_json" ] || [ "$current_monitor" != "$monitor" ]; then
        echo "Setting workspace $id to monitor $monitor"
        hyprctl keyword workspace "$id, monitor:$monitor,persistent:true" > /dev/null
        hyprctl dispatch moveworkspacetomonitor $i "$monitor" > /dev/null

        if [ -z "$workspace_json" ]; then
            echo "Workspace $id does not exist, creating it"
            hyprctl dispatch workspace "$id" > /dev/null
        fi
    fi
}

function arrange_workspaces() {
    # Maintain 10 persistent workspaces across multiple monitors
    # This script assumes that the monitors are in horizontal layout and already
    # correctly setup
    monitors_json=$(hyprctl monitors -j)
    workspaces_json=$(hyprctl workspaces -j)

    mapfile -t monitors < <(echo "$monitors_json" | jq -r '. | sort_by(.x) | .[].name')
    workspace_count=$(echo "$workspaces_json" | jq -r '. | length')

    echo "Detected ${#monitors[@]} monitors with $workspace_count workspaces"

    # assign and move workspaces
    if [[ "${#monitors[@]}" == 1 ]]; then
        for ((i = 10; i >= 1; i--)); do
            move_workspace "$workspaces_json" $i "${monitors[0]}"
        done
    elif [[ "${#monitors[@]}" == 2 ]]; then
        for ((i = 10; i >= 6; i--)); do
            move_workspace "$workspaces_json" $i "${monitors[1]}"
        done
        for ((i = 5; i >= 1; i--)); do
            move_workspace "$workspaces_json" $i "${monitors[0]}"
        done
    elif [[ "${#monitors[@]}" == 3 ]]; then
        for ((i = 10; i >= 8; i--)); do
            move_workspace "$workspaces_json" $i "${monitors[2]}"
        done
        for ((i = 7; i >= 4; i--)); do
            move_workspace "$workspaces_json" $i "${monitors[1]}"
        done
        for ((i = 3; i >= 1; i--)); do
            move_workspace "$workspaces_json" $i "${monitors[0]}"
        done
    else  # more than 3 monitors...
        echo "Too many monitors"
    fi

    # activate first workspace of monitor if out of bounds
    mapfile -t monitors < <(hyprctl monitors -j | jq -r '. | sort_by(.x) | .[].name')
    for name in "${monitors[@]}"; do
        active_workspace=$(echo "$monitors_json" | jq -r ".[] | select(.name == \"$name\") | .activeWorkspace.id")
        if [[ $active_workspace -gt 10 ]]; then
            first_workspace=$(echo "$workspaces_json" | jq -r "map(select(.monitor == \"$name\")) | min_by(.id) | .id")
            echo "Activating workspace $first_workspace on monitor $name"
            hyprctl dispatch workspace "$first_workspace" > /dev/null
        fi
    done

}

function configure_monitors() {
    # rely an kanshi for profile detection and output configuration
    # see https://todo.sr.ht/~emersion/kanshi/54#event-235509
    echo "Configuring monitors..."
    kanshi > /dev/null 2>&1 &
    sleep 1
    killall kanshi

    # arrange workspaces to match the new configuration
    echo "Configuring workspaces..."
    arrange_workspaces
}

function handle_event() {
    if [[ ${1:0:12} == "monitoradded" ]]; then
        echo "Event detected: monitor added"
        @throttle configure_monitors
    elif [[ ${1:0:14} == "monitorremoved" ]]; then
        echo "Event detected: monitor removed"
        @throttle configure_monitors
    fi
}

cli_help() {
  cli_name=${0##*/}
  echo "
$cli_name
Hyprland monitors control
Usage: $cli_name [command]
Commands:
  configure_monitors    Configure monitors using kanshi
  arrange_workspaces    Arrange workspaces on monitors
  listen    Listen for hypr monitor events and arrange workspaces automatically
  help      Help
"
}


case "$1" in
    configure_monitors)
        configure_monitors
        ;;
    arrange_workspaces)
        arrange_workspaces
        ;;
    listen)
        echo "Listening to monitor events..."
        socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle_event "$line"; done
        ;;
    help)
        cli_help
        ;;
    *)
        echo "Invalid command $1"
        cli_help
        exit 1
        ;;
esac
