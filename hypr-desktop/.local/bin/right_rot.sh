#!/bin/bash
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
