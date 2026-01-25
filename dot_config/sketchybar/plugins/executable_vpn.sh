#!/bin/bash

# Check for active VPN connections
VPN_STATUS=$(scutil --nc list | grep Connected)

if [[ -n "$VPN_STATUS" ]]; then
  # Extract VPN name
  VPN_NAME=$(echo "$VPN_STATUS" | sed -E 's/.*"(.*)".*/\1/')
  ICON="󰦝"  # VPN connected icon
  LABEL="$VPN_NAME"
else
  ICON="󰦜"  # VPN disconnected icon
  LABEL=""
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
