#!/bin/bash

# Check if ifstat is installed
if ! command -v ifstat &> /dev/null; then
  sketchybar --set "$NAME" icon="󰛳" label="ifstat not installed"
  exit 0
fi

# Get network interface (en0 is typically WiFi, adjust if needed)
INTERFACE="en0"

# Get upload and download speeds (0.1 second sample, 1 count)
UPDOWN=$(ifstat -i "$INTERFACE" -b 0.1 1 | tail -n1)
DOWN=$(echo "$UPDOWN" | awk "{ print \$1 }" | cut -f1 -d ".")
UP=$(echo "$UPDOWN" | awk "{ print \$2 }" | cut -f1 -d ".")

# Format download speed
DOWN_FORMAT=""
if [ "$DOWN" -gt "999" ]; then
  DOWN_FORMAT=$(echo "$DOWN" | awk '{ printf "%.1f Mbps", $1 / 1000}')
else
  DOWN_FORMAT=$(echo "$DOWN" | awk '{ printf "%d kbps", $1}')
fi

# Format upload speed
UP_FORMAT=""
if [ "$UP" -gt "999" ]; then
  UP_FORMAT=$(echo "$UP" | awk '{ printf "%.1f Mbps", $1 / 1000}')
else
  UP_FORMAT=$(echo "$UP" | awk '{ printf "%d kbps", $1}')
fi

# Set icon based on activity
if [ "$DOWN" -gt "0" ] || [ "$UP" -gt "0" ]; then
  ICON="󰓅"  # Active network icon
else
  ICON="󰛳"  # Idle network icon
fi

sketchybar --set "$NAME" icon="$ICON" label="󰁅 $DOWN_FORMAT 󰁝 $UP_FORMAT"
