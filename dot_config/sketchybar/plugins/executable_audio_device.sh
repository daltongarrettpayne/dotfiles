#!/bin/bash

CURRENT_OUTPUT=$(SwitchAudioSource -c -t output)
CURRENT_INPUT=$(SwitchAudioSource -c -t input)

shorten_name() {
    local name="$1"
    case "$name" in
        *"AirPods"*) echo "AirPods" ;;
        *"MacBook Pro Speakers"*) echo "MacBook Spk" ;;
        *"MacBook Pro Microphone"*) echo "MacBook Mic" ;;
        *"BenQ"*) echo "BenQ" ;;
        *"Headphones"*) echo "Headphones" ;;
        *"Bluetooth"*) echo "BT" ;;
        *) echo "$name" ;;
    esac
}

if [ "$SENDER" = "audio_device_click" ]; then
    # Clear any existing popup items
    sketchybar --remove '/^audio_popup\./'

    # Output devices
    i=0
    while IFS= read -r device; do
        short=$(shorten_name "$device")
        color=0xffffffff
        [ "$device" = "$CURRENT_OUTPUT" ] && color=0xff89b4fa
        sketchybar --add item "audio_popup.out$i" popup.audio_device \
                   --set "audio_popup.out$i" \
                         icon="󰓃" \
                         label="$short" \
                         label.color=$color \
                         click_script="SwitchAudioSource -s \"$device\" -t output; sketchybar --set audio_device popup.drawing=off"
        i=$((i + 1))
    done < <(SwitchAudioSource -a -t output)

    # Separator
    sketchybar --add item audio_popup.sep popup.audio_device \
               --set audio_popup.sep \
                     label="· · · · · · · · · ·" \
                     label.color=0xff444444 \
                     background.drawing=off \
                     click_script=""

    # Input devices
    i=0
    while IFS= read -r device; do
        short=$(shorten_name "$device")
        color=0xffffffff
        [ "$device" = "$CURRENT_INPUT" ] && color=0xff89b4fa
        sketchybar --add item "audio_popup.in$i" popup.audio_device \
                   --set "audio_popup.in$i" \
                         icon="" \
                         label="$short" \
                         label.color=$color \
                         click_script="SwitchAudioSource -s \"$device\" -t input; sketchybar --set audio_device popup.drawing=off"
        i=$((i + 1))
    done < <(SwitchAudioSource -a -t input)

    sketchybar --set audio_device popup.drawing=toggle
    exit 0
fi

# Label: show both if different, one if same device
OUTPUT_LABEL=$(shorten_name "$CURRENT_OUTPUT")
INPUT_LABEL=$(shorten_name "$CURRENT_INPUT")
if [ "$CURRENT_OUTPUT" = "$CURRENT_INPUT" ]; then
    LABEL="$OUTPUT_LABEL"
else
    LABEL="$OUTPUT_LABEL  $INPUT_LABEL"
fi

sketchybar --set "$NAME" \
    icon="" \
    label="$LABEL" \
    popup.background.color=0xdd000000 \
    popup.background.border_width=1 \
    popup.background.border_color=0xff333333 \
    popup.background.corner_radius=8 \
    click_script="SENDER=audio_device_click NAME=audio_device bash ~/.config/sketchybar/plugins/audio_device.sh"
