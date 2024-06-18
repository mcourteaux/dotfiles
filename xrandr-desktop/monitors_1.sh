#!/bin/sh
xrandr \
  --output DP-0 --off \
  --output DP-1 --off --output DP-2 --off \
  --output DP-3 --off --output HDMI-0 --off \
  --output DP-4 --primary --mode 3440x1440 --pos 0x0 --rotate normal --panning 3440x1440+0+0 \
  --output DP-5 --off
