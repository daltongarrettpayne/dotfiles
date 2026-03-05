#!/usr/bin/env bash

SESSION_FILE="$HOME/.local/share/focus/session"

if [ ! -f "$SESSION_FILE" ]; then
  sketchybar --set focus drawing=off --set focus_title drawing=off
  exit 0
fi

task=$(sed -n '1p' "$SESSION_FILE")
start=$(sed -n '2p' "$SESSION_FILE")
end=$(sed -n '3p' "$SESSION_FILE")
now=$(date +%s)

elapsed=$((now - start))
elapsed_fmt=$(printf '%02d:%02d' $((elapsed / 60)) $((elapsed % 60)))

task_len=${#task}

if [ -z "$end" ]; then
  label="$elapsed_fmt elapsed"
  # Shorter label (~13 chars): timer half-width ≈ 53px
  title_pad=$(( 53 - task_len * 9 / 2 ))
  [ "$title_pad" -lt 0 ] && title_pad=0
  sketchybar --set focus_title drawing=on label="$task" label.color=0xffffffff label.padding_left="$title_pad" \
             --set focus drawing=on label="$label"
else
  remaining=$((end - now))
  # Longer label (~25 chars): timer half-width ≈ 97px
  title_pad=$(( 92 - task_len * 9 / 2 ))
  [ "$title_pad" -lt 0 ] && title_pad=0
  if [ "$remaining" -le 0 ]; then
    overtime=$((-remaining))
    overtime_fmt=$(printf '%02d:%02d' $((overtime / 60)) $((overtime % 60)))
    label="$elapsed_fmt elapsed  +$overtime_fmt over"
    sketchybar --set focus_title drawing=on label="$task" label.color=0xffff5555 label.padding_left="$title_pad" \
               --set focus drawing=on label="$label"
  else
    remaining_fmt=$(printf '%02d:%02d' $((remaining / 60)) $((remaining % 60)))
    label="$elapsed_fmt elapsed  $remaining_fmt left"
    sketchybar --set focus_title drawing=on label="$task" label.color=0xffffffff label.padding_left="$title_pad" \
               --set focus drawing=on label="$label"
  fi
fi
