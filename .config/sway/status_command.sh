#!/bin/sh

DATE="$(date +'%Y-%m-%d %I:%M:%S %p')"
BATTERY_PERCENTAGE="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep -o ' [0-9]\+%')"

echo "$DATE $BATTERY_PERCENTAGE"
