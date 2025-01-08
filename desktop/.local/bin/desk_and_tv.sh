#!/bin/bash

# Figure out wayland or X11
if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
  # Figure out Hyprland or Sway
  if [[ ! -z "${SWAYSOCK}" ]]; then
    # Sway
    echo "
    output DP-3 pos 0 0 res 3440x1440
    output DP-1 pos 3440 0 res 2560x1440 transform 90
    output DP-2 pos $((3440+1440)) 0 res 1920x1080
    workspace 9 output DP-2
    " > ~/.config/sway/config.d/20-monitors.conf
    killall waybar && swaymsg reload
  else
    # Hyprland
    echo "
    monitor = DP-3, 3440x1440, 0x0      , 1
    monitor = DP-1, 2560x1440, 3440x-200, 1, transform, 3
    monitor = DP-2, 3840x2160, $((3440+1440))x0  , 2
    " > $HOME/.config/hypr/monitors.conf
  fi
else
  # X11 TODO
  xrandr \
    --output DP-0 --off \
    --output DP-1 --off \
    --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --panning 1920x1080+0+0
    --output DP-3 --off \
    --output DP-4 --off
fi
