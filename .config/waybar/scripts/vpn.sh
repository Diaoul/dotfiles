#!/usr/bin/env bash
set -euo pipefail

interface="wg0"
if [ ! -d /sys/class/net/$interface ] || [ "$(cat /sys/class/net/$interface/operstate)" == "down" ]; then
    echo "{\"alt\": \"disconnected\", \"class\": \"disconnected\", \"tooltip\": \"VPN off\"}"
else
    network=$(~/.config/waybar/scripts/network.sh | jq -r '.class')
    if [ "$network" == "disconnected" ]; then
        echo "{\"alt\": \"nonetwork\", \"class\": \"nonetwork\", \"tooltip\": \"No network\"}"
    else
        ip_address=$(ip -4 addr show dev $interface  | awk '/inet / {print $2}')
        if [ -z "$ip_address" ]; then
            echo "{\"alt\": \"noip\", \"class\": \"noip\", \"tooltip\": \"No ip address\"}"
        else
            echo "{\"alt\": \"connected\", \"class\": \"connected\", \"tooltip\": \"$ip_address\"}"
        fi
    fi
fi
