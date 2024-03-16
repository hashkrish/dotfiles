#!/bin/env bash

MOVE_DIRECTION=$1
MOVE_AMOUNT=${2:-50}

MOVE_X=0
MOVE_Y=0

case "$MOVE_DIRECTION" in
  u)
    MOVE_Y=-"$MOVE_AMOUNT"
    ;;
  d)
    MOVE_Y="$MOVE_AMOUNT"
    ;;
  l)
    MOVE_X=-"$MOVE_AMOUNT"
    ;;
  r)
    MOVE_X="$MOVE_AMOUNT"
    ;;
esac

if [ "$(hyprctl activewindow | grep floating | grep -vE -e '^Window' -e '^[[:space:]]+title:' | awk '{print $2}')" = 1 ]; then
  hyprctl dispatch moveactive "$MOVE_X" "$MOVE_Y"
else
  hyprctl dispatch hy3:movewindow "$MOVE_DIRECTION"
fi
