#!/bin/sh
# Launched by sway (config.d/90-swayidle.conf) and by Sunshine's UNDO command
# via `swaymsg exec`, so swayidle is always a child of sway.
LT=${LT:-300}
ST=${ST:-60}
exec swayidle -w \
    timeout $LT 'swaylock -f' \
    timeout $((LT + ST)) 'swaymsg "output * power off"' \
                  resume 'swaymsg "output * power on"' \
    timeout $ST 'pgrep -xu "$USER" swaylock >/dev/null && swaymsg "output * power off"' \
         resume 'pgrep -xu "$USER" swaylock >/dev/null && swaymsg "output * power on"' \
    before-sleep 'swaylock -f' \
    lock 'swaylock -f' \
    unlock 'pkill -xu "$USER" -SIGUSR1 swaylock'
