#!/bin/sh -eux
xrandr \
  --output DP-0 --mode 2560x1440 --pos 0x0 --rotate normal --rotate left --panning 1440x2560+0+0 \
  --output DP-1 --off --output DP-2 --off \
  --output DP-3 --off --output HDMI-0 --off \
  --output DP-4 --primary --mode 3440x1440 --pos 1440x560 --rotate normal --panning 3440x1440+1440+560 \
  --output DP-5 --off

# Fix audio
pactl set-card-profile alsa_card.pci-0000_09_00.1 output:hdmi-stereo

move() {
  sleep 0.02
  i3-msg workspace "$1"
  sleep 0.02
  i3-msg move workspace to output "$2"
}

move 0:Misc DP-0
move 1:Mail DP-0
move 2:Web  DP-0
move 3      DP-0

move 4            DP-4
move 5            DP-4
move 6            DP-4
move 7            DP-4
move 8            DP-4
move 9            DP-4
move 10           DP-4
move "11:Discord" DP-4

