#!/bin/sh

TOGGLE=$HOME/.config/.toggle-gaps

if [ ! -e $TOGGLE ]; then
	touch $TOGGLE
	hyprctl keyword general:gaps_in 0
	hyprctl keyword general:gaps_out 0
	hyprctl keyword decoration:rounding 0
else
	rm $TOGGLE
	hyprctl keyword general:gaps_in 10
	hyprctl keyword general:gaps_out 20
	hyprctl keyword decoration:rounding 5
fi
