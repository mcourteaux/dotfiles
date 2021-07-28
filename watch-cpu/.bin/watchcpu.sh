#!/usr/bin/env bash

read pct name < <(top -l 4 -n 1 -F -o cpu -stats cpu,command | tail -1)
if (( ${pct%.*} >= 30 )); then
  terminal-notifier -sound purr -title "High CPU usage" -message "$name ($pct%)" -execute "open -a 'Activity Monitor'"
fi

