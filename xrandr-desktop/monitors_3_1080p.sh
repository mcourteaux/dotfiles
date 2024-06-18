#!/bin/sh -eux
xrandr \
  --output DP-4 --primary --mode 3440x1440 \
  --output DP-0 --mode 2560x1440 --rotate normal --left-of DP-4 \
  --output DP-2 --mode 1920x1080 --rotate normal --left-of DP-0 \
  --output DP-1 --off \
  --output DP-3 --off \
  --output HDMI-0 --off \
  --output DP-5 --off

#xrandr \
#  --output DP-0 --mode 2560x1440 --pos 1920x0 --rotate normal --panning 1920x1080+1920+0 \
#  --output DP-1 --off \
#  --output DP-2 --mode 1920x1080 --pos 0x0 --rotate normal --panning 1920x1080+0+0 \
#  --output DP-3 --off \
#  --output HDMI-0 --off \
#  --output DP-4 --primary --mode 3440x1440 --pos $((1920+2560))x0 --rotate normal --panning 3440x1440+$((1920+2560))+0 \
#  --output DP-5 --off
