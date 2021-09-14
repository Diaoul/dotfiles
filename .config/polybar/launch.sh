#!/bin/bash

# logs
LOG_DIR=$HOME/.cache/polybar
mkdir -p $LOG_DIR
echo '---' | tee -a $LOG_DIR/main.log $LOG_DIR/secondary.log > /dev/null

# kill
killall -q polybar

# start main polybar on primary monitor
MONITOR=$(polybar -m | grep primary | sed -e 's/:.*$//g') \
    polybar main &>> $LOG_DIR/main.log & \
    disown

# start secondary polybar on other monitors
for monitor in $(polybar -m | grep -v primary | sed -e 's/:.*$//g'); do
    MONITOR=$monitor \
        polybar secondary 2>&1 | \
        sed "s/^/$monitor: /" >> $LOG_DIR/secondary.log &
        disown
done
