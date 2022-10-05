#!/bin/env bash

compton &
xscreensaver &
conky &
xrandr --output eDP-1 --mode 1920x1080 --rate 60 --output HDMI-1 --mode 1366x768 --rate 60 --above eDP-1
sleep 2 && feh --bg-fill /home/krishnan/Pictures/earth1.jpg 
