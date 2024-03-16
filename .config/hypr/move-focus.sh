#!/bin/env bash

MOVE_DIRECTION=$1

if [ "$(hyprctl activewindow | grep floating | grep -vE -e '^Window' -e '^[[:space:]]+title:' | awk '{print $2}')" = 1 ]; then

#hyprctl clients -j | jq '[.[]|select(.floating)]'
  hyprctl dispatch moveactive "$MOVE_X" "$MOVE_Y"
else
  hyprctl dispatch movewindow "$MOVE_DIRECTION"
fi
