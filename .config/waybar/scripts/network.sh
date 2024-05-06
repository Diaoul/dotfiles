#!/usr/bin/env bash
set -euo pipefail

state="disconnected"
bond_interface="bond0"
wlan_interface="wlan0"

# check the bond interface first
if [ -d /sys/class/net/$bond_interface ] && [ "$(cat /sys/class/net/$bond_interface/operstate)" == "up" ] && [ -n "$(cat /sys/class/net/$bond_interface/bonding/active_slave)" ]; then
    ip_address=$(ip -4 addr show dev $bond_interface  | awk '/inet / {print $2}')
    primary_interface=$(cat /sys/class/net/$bond_interface/bonding/primary)
    active_slave=$(cat /sys/class/net/$bond_interface/bonding/active_slave)
    if [ -z "$ip_address" ]; then
        echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"No IP address\"}"
    elif [ -d /sys/class/net/$primary_interface ] && [ "$active_slave" == "$primary_interface" ]; then
        state="ethernet"
        echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"$ip_address\"}"
    else
        state="wifi"
        ssid=$(iw dev $wlan_interface link | grep SSID | cut -d' ' -f2-)
        signal=$(iw dev $wlan_interface link | awk '/signal/{print $2$3}')
        echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"$ip_address\n$ssid ($signal)\"}"
    fi
elif [ -d /sys/class/net/$wlan_interface ]; then
    ip_address=$(ip -4 addr show dev $wlan_interface  | awk '/inet / {print $2}')
    state="wifi"
    ssid=$(iw dev $wlan_interface link | grep SSID | cut -d' ' -f2-)
    signal=$(iw dev $wlan_interface link | awk '/signal/{print $2$3}')
    echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"$ip_address\n$ssid ($signal)\"}"
else
    echo "{\"alt\": \"$state\", \"class\": \"$state\", \"tooltip\": \"Disconnected\"}"
fi
