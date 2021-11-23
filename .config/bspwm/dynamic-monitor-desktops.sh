#!/bin/bash

# gather monitor and desktop counts
monitor_count=$(bspc query -M | wc -l)
desktop_count=$(bspc query -D | wc -l)

# this maintains 10 desktops accross monitors, rearranging them when adding or
# removing monitor
if [[ "$monitor_count" == 1 ]]; then
    # get monitor ids
    monitor_1=$(bspc query -M -m "^1")
    if [[ "$desktop_count" < 10 ]]; then
        # less than 10 desktops exist, assume the ones we want (1-10) don't
        # exist and create them
        bspc monitor -d 1 2 3 4 5 6 7 8 9 10
    else
        # assume the 10 desktops exist (1-10) and move them to the correct
        # monitor
        bspc desktop 1 -m $monitor_1
        bspc desktop 2 -m $monitor_1
        bspc desktop 3 -m $monitor_1
        bspc desktop 4 -m $monitor_1
        bspc desktop 5 -m $monitor_1
        bspc desktop 6 -m $monitor_1
        bspc desktop 7 -m $monitor_1
        bspc desktop 8 -m $monitor_1
        bspc desktop 9 -m $monitor_1
        bspc desktop 10 -m $monitor_1
        # order them first as -d would rename misplaced ones
        bspc monitor $monitor_1 -o 1 2 3 4 5 6 7 8 9 10
        # remove potential extra desktops
        # note: bspwm creates a default desktop when a monitor is added
        bspc monitor $monitor_1 -d 1 2 3 4 5 6 7 8 9 10
    fi
elif [[ "$monitor_count" == 2 ]]; then
    monitor_1=$(bspc query -M -m "^1")
    monitor_2=$(bspc query -M -m "^2")
    if [[ "$desktop_count" < 10 ]]; then
        bspc monitor $monitor_1 -d 1 2 3 4 5
        bspc monitor $monitor_2 -d 6 7 8 9 10
    else
        bspc desktop 1 -m $monitor_1
        bspc desktop 2 -m $monitor_1
        bspc desktop 3 -m $monitor_1
        bspc desktop 4 -m $monitor_1
        bspc desktop 5 -m $monitor_1
        bspc desktop 6 -m $monitor_2
        bspc desktop 7 -m $monitor_2
        bspc desktop 8 -m $monitor_2
        bspc desktop 9 -m $monitor_2
        bspc desktop 10 -m $monitor_2
        bspc monitor $monitor_1 -o 1 2 3 4 5
        bspc monitor $monitor_1 -d 1 2 3 4 5
        bspc monitor $monitor_2 -o 6 7 8 9 10
        bspc monitor $monitor_2 -d 6 7 8 9 10
    fi
elif [[ "$monitor_count" == 3 ]]; then
    monitor_1=$(bspc query -M -m "^1")
    monitor_2=$(bspc query -M -m "^2")
    monitor_3=$(bspc query -M -m "^3")
    if [[ "$desktop_count" < 10 ]]; then
        bspc monitor $monitor_1 -d 1 2 3
        bspc monitor $monitor_2 -d 4 5 6 7
        bspc monitor $monitor_3 -d 8 9 10
    else
        bspc desktop 1 -m $monitor_1
        bspc desktop 2 -m $monitor_1
        bspc desktop 3 -m $monitor_1
        bspc desktop 4 -m $monitor_2
        bspc desktop 5 -m $monitor_2
        bspc desktop 6 -m $monitor_2
        bspc desktop 7 -m $monitor_2
        bspc desktop 8 -m $monitor_3
        bspc desktop 9 -m $monitor_3
        bspc desktop 10 -m $monitor_3
        bspc monitor $monitor_1 -o 1 2 3
        bspc monitor $monitor_1 -d 1 2 3
        bspc monitor $monitor_2 -o 4 5 6 7
        bspc monitor $monitor_2 -d 4 5 6 7
        bspc monitor $monitor_3 -o 8 9 10
        bspc monitor $monitor_3 -d 8 9 10
    fi
elif [[ "$monitor_count" == 4 ]]; then
    monitor_1=$(bspc query -M -m "^1")
    monitor_2=$(bspc query -M -m "^2")
    monitor_3=$(bspc query -M -m "^3")
    monitor_4=$(bspc query -M -m "^4")
    if [[ "$desktop_count" < 10 ]]; then
        bspc monitor $monitor_1 -d 1 2
        bspc monitor $monitor_2 -d 3 4 5
        bspc monitor $monitor_3 -d 6 7 8
        bspc monitor $monitor_4 -d 9 10
    else
        bspc desktop 1 -m $monitor_1
        bspc desktop 2 -m $monitor_1
        bspc desktop 3 -m $monitor_2
        bspc desktop 4 -m $monitor_2
        bspc desktop 5 -m $monitor_2
        bspc desktop 6 -m $monitor_3
        bspc desktop 7 -m $monitor_3
        bspc desktop 8 -m $monitor_3
        bspc desktop 9 -m $monitor_4
        bspc desktop 10 -m $monitor_4
        bspc monitor $monitor_1 -o 1 2
        bspc monitor $monitor_1 -d 1 2
        bspc monitor $monitor_2 -o 3 4 5
        bspc monitor $monitor_2 -d 3 4 5
        bspc monitor $monitor_3 -o 6 7 8
        bspc monitor $monitor_3 -d 6 7 8
        bspc monitor $monitor_4 -o 9 10
        bspc monitor $monitor_4 -d 9 10
    fi
elif [[ "$monitor_count" == 5 ]]; then
    monitor_1=$(bspc query -M -m "^1")
    monitor_2=$(bspc query -M -m "^2")
    monitor_3=$(bspc query -M -m "^3")
    monitor_4=$(bspc query -M -m "^4")
    monitor_5=$(bspc query -M -m "^5")
    if [[ "$desktop_count" < 10 ]]; then
        bspc monitor $monitor_1 -d 1 2
        bspc monitor $monitor_2 -d 3 4
        bspc monitor $monitor_3 -d 5 6
        bspc monitor $monitor_4 -d 7 8
        bspc monitor $monitor_5 -d 9 10
    else
        bspc desktop 1 -m $monitor_1
        bspc desktop 2 -m $monitor_1
        bspc desktop 3 -m $monitor_2
        bspc desktop 4 -m $monitor_2
        bspc desktop 5 -m $monitor_3
        bspc desktop 6 -m $monitor_3
        bspc desktop 7 -m $monitor_4
        bspc desktop 8 -m $monitor_4
        bspc desktop 9 -m $monitor_5
        bspc desktop 10 -m $monitor_5
        bspc monitor $monitor_1 -o 1 2
        bspc monitor $monitor_1 -d 1 2
        bspc monitor $monitor_2 -o 3 4
        bspc monitor $monitor_2 -d 3 4
        bspc monitor $monitor_3 -o 5 6
        bspc monitor $monitor_3 -d 5 6
        bspc monitor $monitor_4 -o 7 8
        bspc monitor $monitor_4 -d 7 8
        bspc monitor $monitor_5 -o 9 10
        bspc monitor $monitor_5 -d 9 10
    fi
else  # more than 5 monitors...
    # no rearranging for rich people
    i=0
    for monitor in $(bspc query -M); do
        bspc monitor $monitor -n $i -d $i-{1,2}
        ((i++))
    done
fi
