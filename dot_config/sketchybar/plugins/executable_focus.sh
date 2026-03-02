#!/usr/bin/env bash

SESSION_FILE="$HOME/.local/share/focus/session"

if [ ! -f "$SESSION_FILE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

task=$(sed -n '1p' "$SESSION_FILE")
start=$(sed -n '2p' "$SESSION_FILE")
end=$(sed -n '3p' "$SESSION_FILE")
now=$(date +%s)

elapsed=$((now - start))
remaining=$((end - now))
elapsed_fmt=$(printf '%02d:%02d' $((elapsed / 60)) $((elapsed % 60)))

if [ "$remaining" -le 0 ]; then
  overtime=$((-remaining))
  overtime_fmt=$(printf '%02d:%02d' $((overtime / 60)) $((overtime % 60)))
  label="$task  $elapsed_fmt elapsed  +$overtime_fmt over"
  sketchybar --set "$NAME" drawing=on label="$label" icon.color=0xffff5555
else
  remaining_fmt=$(printf '%02d:%02d' $((remaining / 60)) $((remaining % 60)))
  label="$task  $elapsed_fmt elapsed  $remaining_fmt left"
  sketchybar --set "$NAME" drawing=on label="$label" icon.color=0xffffffff
fi
