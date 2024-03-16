#!/usr/bin/env sh

PREFIX="<span color='#b4db81'>"
SUFFIX="</span>"
active_monitor=$(hyprctl activeworkspace | head -1 | sed 's/.*monitor //; s/://;')
if [ "$active_monitor" = "$1" ]; then
    echo "$PREFIX  $SUFFIX"
else
    echo ""
fi
