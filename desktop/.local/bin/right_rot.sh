
# Figure out wayland or X11
if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
  # Figure out Hyprland or Sway
  if [[ ! -z "${SWAYSOCK}" ]]; then
    # Sway
    echo "
    output DP-3 pos 0 0 res 3440x1440
    output DP-1 pos 3440 0 res 2560x1440 transform 90
    output DP-2 disable

    workspace 1 output DP-1
    workspace 2 output DP-1
    workspace 3 output DP-1
    workspace 4 output DP-3
    workspace 5 output DP-3
    workspace 6 output DP-3
    workspace 7 output DP-3
    workspace 8 output DP-3
    workspace 9 output DP-3
    " > ~/.config/sway/config.d/20-monitors.conf
    killall waybar && swaymsg reload
  else
    # Hyprland
    echo "
    monitor = DP-3, 3440x1440, 0x0      , 1
    monitor = DP-1, 2560x1440, 3440x-200, 1, transform, 3
    monitor = DP-2, disabled

    workspace = 1, monitor:DP-1
    workspace = 2, monitor:DP-1
    workspace = 3, monitor:DP-1
    workspace = 4, monitor:DP-3
    workspace = 5, monitor:DP-3
    workspace = 6, monitor:DP-3
    workspace = 7, monitor:DP-3
    workspace = 8, monitor:DP-3
    workspace = 9, monitor:DP-3
    " > $HOME/.config/hypr/monitors.conf
  fi
else
  # X11
  xrandr \
    --output DP-0 --mode 2560x1440 --pos 3440x0 --rotate right --panning 1440x2560+3440+0 \
    --output DP-1 --off --output DP-2 --off \
    --output DP-3 --off --output HDMI-0 --off \
    --output DP-4 --primary --mode 3440x1440 --pos 0x560 --rotate normal --panning 3440x1440+0+560 \
    --output DP-5 --off

  # Fix audio
  pactl set-card-profile alsa_card.pci-0000_09_00.1 output:hdmi-stereo

  move() {
    sleep 0.02
    i3-msg workspace "$1"
    sleep 0.02
    i3-msg move workspace to output "$2"
  }

  move "0:Misc" DP-0
  move "1:Mail" DP-0
  move "2:Web"  DP-0
  move 3        DP-0

  move 4            DP-4
  move 5            DP-4
  move 6            DP-4
  move 7            DP-4
  move 8            DP-4
  move 9            DP-4
  move 10           DP-4
  move "11:Discord" DP-4

fi
