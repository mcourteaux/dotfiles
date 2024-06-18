#!/bin/sh
xrandr \
  --output DP-0 --mode 2560x1440 --pos 0x0 --rotate normal --panning 3840x2160+0+0 \
  --output DP-1 --off \
  --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 \
  --output DP-3 --off \
  --output HDMI-0 --off \
  --output DP-4 --off \
  --output DP-5 --off
