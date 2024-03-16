#!/usr/bin/env sh

PREFIX="<span color='#b4db81'>"
SUFFIX="</span>"
active_monitor=$(hyprctl activeworkspace | head -1 | sed 's/.*monitor //; s/://;')
is_fullscreen=$(hyprctl activeworkspace | grep -o "hasfullscreen" | sed 's/.*: //')
if [ "$active_monitor" = "$1" ]; then
    if [ "$is_fullscreen" = 1 ]; then
        echo "$PREFIX [] $SUFFIX"
        notify-send "Fullscreen detected" "You are currently in fullscreen mode"
    else
        echo "$PREFIX  $SUFFIX"
    fi
else
    echo ""
fi
