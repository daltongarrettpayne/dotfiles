#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all | sort -r); do
    num=$(echo "$sid" | sed 's/^0*\([0-9]*\)-.*/\1/')
    sketchybar --add item space_compact."$sid" right \
        --subscribe space_compact."$sid" aerospace_workspace_change \
        --set space_compact."$sid" \
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label.font.size=14.0 \
        icon.drawing=off \
        label="$num" \
        click_script="aerospace workspace $sid" \
        script="$HOME/.config/sketchybar/plugins/aerospacer.sh $sid"
done
