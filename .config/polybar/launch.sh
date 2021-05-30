#!/bin/bash

killall -q polybar

MONITOR=$(polybar -m | grep primary | sed -e 's/:.*$//g') polybar -q main &
for monitor in $(polybar -m | grep -v primary | sed -e 's/:.*$//g'); do
    MONITOR=$monitor polybar -q secondary &
done
