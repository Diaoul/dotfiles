#!/bin/bash

monitor_count=$(bspc query -M | wc -l)
if [[ "$monitor_count" == 1 ]]; then
    bspc monitor -d 1 2 3 4 5 6 7 8 9 10
elif [[ "$monitor_count" == 2 ]]; then
    bspc monitor $(bspc query -M | sed -n 1p) -d 1 2 3 4 5
    bspc monitor $(bspc query -M | sed -n 2p) -d 6 7 8 9 10
elif [[ "$monitor_count" == 3 ]]; then
    bspc monitor $(bspc query -M | sed -n 1p) -d 1 2 3
    bspc monitor $(bspc query -M | sed -n 2p) -d 4 5 6 7
    bspc monitor $(bspc query -M | sed -n 3p) -d 8 9 10
elif [[ "$monitor_count" == 4 ]]; then
    bspc monitor $(bspc query -M | sed -n 1p) -d 1 2
    bspc monitor $(bspc query -M | sed -n 2p) -d 3 4 5
    bspc monitor $(bspc query -M | sed -n 3p) -d 6 7 8
    bspc monitor $(bspc query -M | sed -n 4p) -d 9 10
elif [[ "$monitor_count" == 5 ]]; then
    bspc monitor $(bspc query -M | sed -n 1p) -d 1 2
    bspc monitor $(bspc query -M | sed -n 2p) -d 3 4
    bspc monitor $(bspc query -M | sed -n 3p) -d 5 6
    bspc monitor $(bspc query -M | sed -n 4p) -d 7 8
    bspc monitor $(bspc query -M | sed -n 5p) -d 9 10
else
    i=0
    for monitor in $(bscp query -M); do
        bspc monitor $monitor -n $i -d $i-{1,2}
        ((i++))
    done
fi
