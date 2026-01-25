#!/usr/bin/env bash

# timetrap.sh
# This script updates a SketchyBar item with the current Timetrap sheet status.
# Add to your SketchyBar config:
# sketchybar --add item timetrap center \
#            --set timetrap update_freq=60 \
#                          script="$PATH_TO_THIS_SCRIPT/timetrap_status.sh"

running=$(t now)

if [ -z "$running" ]; then
  label="No Timesheet Running"
else
  sheet=$(echo "$running" | cut -d':' -f1 | tr -d '*')
  running_time=$(echo "$running" | cut -d':' -f2- | cut -d'(' -f1 | xargs)
  total_time=$(t display "$sheet" | tail -1 | awk '{print $NF}')
  label="$sheet, Running: $running_time, Total: $total_time"
fi

sketchybar --set "$NAME" label="$label"
