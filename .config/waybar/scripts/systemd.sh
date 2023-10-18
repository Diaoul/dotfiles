#!/usr/bin/env bash
set -euo pipefail

failed_user=($(systemctl --user --failed --plain --no-legend | awk '{ print $1 }'))
failed_system=($(systemctl --failed --plain --no-legend | awk '{ print $1 }'))


failures=$((${#failed_user[@]} + ${#failed_system[@]}))
if [ $failures -eq 0 ]; then
    echo '{"text": ""}'
else
    tooltip=""
    if [ ${#failed_user[@]} -gt 0 ]; then
        tooltip="${tooltip}Failed user services:"
        for failure in ${failed_user[@]}; do
            tooltip="$tooltip\n- $failure"
        done
    fi
    if [ ${#failed_system[@]} -gt 0 ]; then
        if [ ${#failed_user[@]} -gt 0 ]; then
            tooltip="${tooltip}\n\n"
        fi
        tooltip="${tooltip}Failed system services:"
        for failure in ${failed_system[@]}; do
            tooltip="$tooltip\n- $failure"
        done
    fi

    echo "{\"text\": \" $failures\", \"tooltip\": \"$tooltip\" }"
fi
