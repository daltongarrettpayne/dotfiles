#!/bin/bash

IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)

if [[ $IP_ADDRESS != "" ]]; then
  ICON="󰖩"  # Connected icon (Nerd Font)
  LABEL=""
else
  ICON="󰖪"  # Disconnected icon (Nerd Font)
  LABEL="OFFLINE"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
