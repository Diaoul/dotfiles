#!/usr/bin/env bash
set -euo pipefail

socket="${XDG_RUNTIME_DIR:-/run/user/$UID}/yubikey-touch-detector.socket"

while true; do
    touch_reasons=()

    if [ ! -e "$socket" ]; then
        echo '{"text": "Waiting for YubiKey socket"}'
        while [ ! -e "$socket" ]; do sleep 1; done
    fi
    echo '{"text": ""}'

    nc -U "$socket" | while read -n5 cmd; do
        reason="${cmd:0:3}"

        if [ "${cmd:4:1}" = "1" ]; then
            touch_reasons+=("$reason")
        else
            for i in "${!touch_reasons[@]}"; do
                if [ "${touch_reasons[i]}" = "$reason" ]; then
                    unset 'touch_reasons[i]'
                    break
                fi
            done
        fi

        if [ "${#touch_reasons[@]}" -eq 0 ]; then
            echo '{"text": ""}'
        else
            tooltip="YubiKey is waiting for a touch, reasons: ${touch_reasons[@]}"
            echo "{\"text\": \"󰌆\", \"tooltip\": \"$tooltip\"}"
        fi
    done

    sleep 1
done
