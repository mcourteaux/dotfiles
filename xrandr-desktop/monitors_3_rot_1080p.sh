#!/bin/sh
xrandr \
  --output DP-0 --mode 2560x1440 --pos 0x0 --rotate left --panning 1440x2560+1920+0 \
  --output DP-1 --off \
  --output DP-2 --mode 1920x1080 --rotate normal --panning 1920x1080+0+0 \
  --output DP-3 --off \
  --output HDMI-0 --off \
  --output DP-4 --primary --mode 3440x1440 --pos 1440x560 --rotate normal --panning 3440x1440+3360+560 \
  --output DP-5 --off
