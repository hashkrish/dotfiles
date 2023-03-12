#!/bin/env bash

export PATH=/home/krishnan/.nvm/versions/node/v14.15.0/bin/pyright-langserver:$PATH
export LANG=en_US.UTF-8
picom &
xscreensaver &
# conky &
xrandr --output eDP-1 --mode 1920x1080 --rate 60 --output HDMI-1 --mode 1366x768 --rate 60 --above eDP-1
sleep 2 && feh --bg-fill /home/krishnan/Pictures/earth1.jpg 
env > /tmp/env-on-init-qtile
dropbox start &
guake &
