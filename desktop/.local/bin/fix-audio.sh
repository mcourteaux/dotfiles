#!/bin/bash -eux


## Below selects the first card, instead of the current one:
#CARD=$(pactl list short cards | xargs | cut -d\  -f 2)
#echo "CARD: $CARD"
#PROFILE=$(pactl get-default-sink | sed -E 's/.*\.(.*)/\1/')
#echo "PROFILE: $PROFILE"

CARD=$(pactl info | grep -i "default sink" | sed -E 's/.*: (.*)\.(.*?)/\1/')


set -x

pactl set-card-profile $CARD output:hdmi-stereo
#pactl set-card-profile $CARD output:hdmi-stereo-extra2
pactl set-card-profile $CARD output:$PROFILE
