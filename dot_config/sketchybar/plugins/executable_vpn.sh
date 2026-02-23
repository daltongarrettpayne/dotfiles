#!/bin/bash

# Check for OpenVPN Connect connections
OPENVPN_RUNNING=$(pgrep -x "OpenVPN Connect" > /dev/null && echo "yes" || echo "no")
OPENVPN_CONNECTED=$(ifconfig | grep -A 1 "utun" | grep "inet " | grep -v "inet6" | head -n 1)

# Check for native macOS VPN connections
NATIVE_VPN=$(scutil --nc list | grep Connected)

if [[ -n "$OPENVPN_CONNECTED" && "$OPENVPN_RUNNING" == "yes" ]]; then
  # OpenVPN is connected
  VPN_IP=$(echo "$OPENVPN_CONNECTED" | awk '{print $2}')
  ICON="󰦝"  # VPN connected icon
  LABEL="OpenVPN"
elif [[ -n "$NATIVE_VPN" ]]; then
  # Native VPN is connected
  VPN_NAME=$(echo "$NATIVE_VPN" | sed -E 's/.*"(.*)".*/\1/')
  ICON="󰦝"  # VPN connected icon
  LABEL="$VPN_NAME"
else
  # No VPN connected
  ICON="󰦜"  # VPN disconnected icon
  LABEL=""
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
