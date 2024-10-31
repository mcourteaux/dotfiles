

# Figure out wayland or X11
if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
  # Figure out Hyprland or Sway
  if [[ ! -z "${SWAYSOCK}" ]]; then
    # Sway
    echo "
    output DP-3 disable
    output DP-1 disable
    output DP-2 pos -1920 0 res 1920x1080
    " > ~/.config/sway/config.d/20-monitors.conf
    killall waybar && swaymsg reload
  else
    # Hyprland
    echo "
    monitor = DP-3, disabled
    monitor = DP-1, disabled
    monitor = DP-2, 1920x1080, 0x0  , 1
    " > $HOME/.config/hypr/monitors.conf
  fi
else
  # X11
  xrandr \
    --output DP-0 --off \
    --output DP-1 --off \
    --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --panning 1920x1080+0+0
    --output DP-3 --off \
    --output DP-4 --off
fi
