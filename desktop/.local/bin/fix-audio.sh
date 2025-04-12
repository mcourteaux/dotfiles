#!/bin/bash



CARD=$(pactl list short cards | xargs | cut -d\  -f 2)
echo "CARD: $CARD"
PROFILE=$(pactl get-default-sink | sed -E 's/.*\.(.*)/\1/')
echo "PROFILE: $PROFILE"

set -x

pactl set-card-profile $CARD output:hdmi-stereo
pactl set-card-profile $CARD output:$PROFILE


