#!/usr/bin/env bash
set -euo pipefail

state="disconnected"
if [ "$(cat /sys/class/net/bond0/operstate)" == "up" ]; then
    ip_address=$(ip -4 addr show dev bond0  | awk '/inet / {print $2}')
    if [ -z "$ip_address" ]; then
        echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"No ip address\"}"
    elif [ -d /sys/class/net/enp60s0u2u4 ] && [ "$(cat /sys/class/net/enp60s0u2u4/operstate)" == "up" ]; then
        state="ethernet"
        echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"$ip_address\"}"
    elif [ "$(cat /sys/class/net/wlan0/operstate)" == "up" ]; then
        state="wifi"
        ssid=$(iw dev wlan0 link | grep SSID | cut -d' ' -f2-)
        signal=$(iw dev wlan0 link | awk '/signal/{print $2$3}')
        echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"$ip_address\n$ssid ($signal)\"}"
    else
        echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"Disconnected\"}"
    fi
else
    echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"Disconnected\"}"
fi
