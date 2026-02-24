#!/bin/bash

# Toggle popup on click, close on mouse exit
if [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set volume popup.drawing=off
  exit 0
fi

CURRENT=$(SwitchAudioSource -c 2>/dev/null)

# Remove old device items
sketchybar --remove '/audio_device\.*/'

# Build popup items for each output device
INDEX=0
while IFS= read -r DEVICE; do
  [ -z "$DEVICE" ] && continue

  ITEM="audio_device.$INDEX"

  case "$DEVICE" in
    *"AirPods Max"*) ICON="󰋎" ;;
    *"AirPods"*)     ICON="󰋋" ;;
    *"Headphone"*|*"headphone"*) ICON="󰋋" ;;
    *"HDMI"*|*"Display"*) ICON="󰡁" ;;
    *"Bluetooth"*)   ICON="󰂰" ;;
    *)               ICON="󰕾" ;;
  esac

  sketchybar --add item "$ITEM" popup.volume \
             --set "$ITEM" \
               icon="$ICON" \
               icon.font="Hack Nerd Font:Bold:14.0" \
               label="$DEVICE" \
               label.font="Hack Nerd Font:Bold:13.0" \
               label.color=0xffffffff \
               icon.color=0xffffffff \
               padding_left=5 \
               padding_right=5 \
               click_script="SwitchAudioSource -s '$DEVICE' 2>/dev/null; sketchybar --set volume popup.drawing=off"

  # Highlight the currently active device
  if [ "$DEVICE" = "$CURRENT" ]; then
    sketchybar --set "$ITEM" label.color=0xffa6e3a1 icon.color=0xffa6e3a1
  fi

  INDEX=$((INDEX + 1))
done < <(SwitchAudioSource -a -t output 2>/dev/null)

sketchybar --set volume popup.drawing=toggle
