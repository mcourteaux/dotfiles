#!/usr/bin/env bash

while true; do
    read pct name < <(top -l 8 -n 1 -F -o cpu -stats cpu,command | tail -1)
    if (( ${pct%.*} >= 40 )); then
        /usr/local/bin/terminal-notifier -sound purr -title "High CPU usage" -message "$name ($pct%)" -execute "open -a 'Activity Monitor'"
    fi
    sleep 5
done

