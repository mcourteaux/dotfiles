#!/bin/bash

current=$(setxkbmap -query | grep layout | xargs | cut -d\  -f 2)

if [[ $current == "mk" ]]; then
  setxkbmap -layout us
else
  setxkbmap -layout mk
fi
