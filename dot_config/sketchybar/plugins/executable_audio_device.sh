#!/bin/bash

update_label() {
  DEVICE=$(SwitchAudioSource -c -t output 2>/dev/null)
  case "$DEVICE" in
    *"AirPods Max"*) ICON="󰋎" ;;
    *"AirPods"*)     ICON="󰋋" ;;
    *"Headphone"*|*"headphone"*) ICON="󰋋" ;;
    *"HDMI"*|*"Display"*) ICON="󰡁" ;;
    *"Bluetooth"*)   ICON="󰂰" ;;
    *)               ICON="󰕾" ;;
  esac
  sketchybar --set "$NAME" icon="$ICON" label="$DEVICE"
}

device_icon() {
  case "$1" in
    *"AirPods Max"*) echo "󰋎" ;;
    *"AirPods"*)     echo "󰋋" ;;
    *"Headphone"*|*"headphone"*) echo "󰋋" ;;
    *"HDMI"*|*"Display"*) echo "󰡁" ;;
    *"Bluetooth"*)   echo "󰂰" ;;
    *)               echo "󰕾" ;;
  esac
}

open_popup() {
  CURRENT_OUT=$(SwitchAudioSource -c -t output 2>/dev/null)
  CURRENT_IN=$(SwitchAudioSource -c -t input 2>/dev/null)

  # Remove all previous popup children
  sketchybar --remove "/audio_device\..+/"

  # OUTPUT header
  sketchybar --add item audio_device.header.out popup.audio_device \
             --set audio_device.header.out \
               label="OUTPUT" \
               label.font="Hack Nerd Font:Bold:11.0" \
               label.color=0xff888888 \
               icon.drawing=off \
               padding_left=8 \
               padding_right=8 \
               background.height=20

  # Output devices
  INDEX=0
  while IFS= read -r DEVICE; do
    [ -z "$DEVICE" ] && continue
    ITEM="audio_device.out.$INDEX"
    ICON=$(device_icon "$DEVICE")
    sketchybar --add item "$ITEM" popup.audio_device \
               --set "$ITEM" \
                 icon="$ICON" \
                 icon.font="Hack Nerd Font:Bold:14.0" \
                 label="$DEVICE" \
                 label.font="Hack Nerd Font:Bold:13.0" \
                 label.color=0xffffffff \
                 icon.color=0xffffffff \
                 padding_left=5 \
                 padding_right=5 \
                 click_script="SwitchAudioSource -s '$DEVICE' -t output 2>/dev/null; sketchybar --set audio_device popup.drawing=off"
    if [ "$DEVICE" = "$CURRENT_OUT" ]; then
      sketchybar --set "$ITEM" label.color=0xffa6e3a1 icon.color=0xffa6e3a1
    fi
    INDEX=$((INDEX + 1))
  done < <(SwitchAudioSource -a -t output 2>/dev/null)

  # INPUT header
  sketchybar --add item audio_device.header.in popup.audio_device \
             --set audio_device.header.in \
               label="INPUT" \
               label.font="Hack Nerd Font:Bold:11.0" \
               label.color=0xff888888 \
               icon.drawing=off \
               padding_left=8 \
               padding_right=8 \
               background.height=20

  # Input devices
  INDEX=0
  while IFS= read -r DEVICE; do
    [ -z "$DEVICE" ] && continue
    ITEM="audio_device.in.$INDEX"
    ICON=$(device_icon "$DEVICE")
    sketchybar --add item "$ITEM" popup.audio_device \
               --set "$ITEM" \
                 icon="$ICON" \
                 icon.font="Hack Nerd Font:Bold:14.0" \
                 label="$DEVICE" \
                 label.font="Hack Nerd Font:Bold:13.0" \
                 label.color=0xffffffff \
                 icon.color=0xffffffff \
                 padding_left=5 \
                 padding_right=5 \
                 click_script="SwitchAudioSource -s '$DEVICE' -t input 2>/dev/null; sketchybar --set audio_device popup.drawing=off"
    if [ "$DEVICE" = "$CURRENT_IN" ]; then
      sketchybar --set "$ITEM" label.color=0xff89b4fa icon.color=0xff89b4fa
    fi
    INDEX=$((INDEX + 1))
  done < <(SwitchAudioSource -a -t input 2>/dev/null)

  sketchybar --set audio_device popup.drawing=toggle
}

case "$SENDER" in
  "mouse.clicked")
    open_popup
    ;;
  "mouse.exited.global")
    sketchybar --set audio_device popup.drawing=off
    ;;
  *)
    update_label
    ;;
esac
