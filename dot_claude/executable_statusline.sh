#!/bin/bash
input=$(cat)

# Parse fields
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Git info — cached in /tmp keyed by dir, TTL 30s
branch=""
repo=""
if [ -n "$dir" ]; then
  cache_key=$(echo "$dir" | shasum | cut -c1-8)
  cache_file="/tmp/claude_sl_git_${cache_key}"
  now=$(date +%s)
  if [ -f "$cache_file" ] && [ $(( now - $(stat -f %m "$cache_file" 2>/dev/null || echo 0) )) -lt 30 ]; then
    branch=$(sed -n '1p' "$cache_file")
    repo=$(sed -n '2p' "$cache_file")
  else
    if cd "$dir" 2>/dev/null; then
      branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
      toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
      repo=$([ -n "$toplevel" ] && basename "$toplevel" || basename "$dir")
    else
      repo=$(basename "$dir")
    fi
    printf '%s\n%s\n' "$branch" "$repo" > "$cache_file"
  fi
fi
[ -z "$repo" ] && repo=$(basename "$dir")

# Conversation subject — cached per transcript file (content doesn't change after first message)
subject=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  subj_cache="/tmp/claude_sl_subj_$(echo "$transcript" | shasum | cut -c1-8)"
  if [ -f "$subj_cache" ]; then
    subject=$(cat "$subj_cache")
  else
    subject=$(jq -r 'select(.type == "user") | .message.content | if type == "array" then (.[0].text // "") else . end' "$transcript" 2>/dev/null | head -1 | cut -c1-70)
    [ -n "$subject" ] && echo "$subject" > "$subj_cache"
  fi
fi

# Context bar (10 blocks)
ctx_bar=""
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  filled=$(( used_int / 10 ))
  [ $filled -gt 10 ] && filled=10
  empty=$(( 10 - filled ))
  ctx_bar="["
  for i in $(seq 1 $filled); do ctx_bar="${ctx_bar}█"; done
  for i in $(seq 1 $empty); do ctx_bar="${ctx_bar}░"; done
  ctx_bar="${ctx_bar}]"
fi

# Colors
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
RED='\033[31m'

# Context color based on remaining
ctx_color=$GREEN
rem_int=""
if [ -n "$remaining" ]; then
  rem_int=$(printf '%.0f' "$remaining")
  if [ "$rem_int" -lt 10 ]; then
    ctx_color=$RED
  elif [ "$rem_int" -lt 25 ]; then
    ctx_color=$YELLOW
  fi
fi

# --- Line 1: repo(branch) | model | ctx: XX% [bar] | $cost ---
printf "${BOLD}${CYAN}%s${RESET}" "$repo"
[ -n "$branch" ] && printf "${DIM}(${RESET}${GREEN}%s${RESET}${DIM})${RESET}" "$branch"
printf " ${DIM}|${RESET} ${BLUE}%s${RESET}" "$model"
if [ -n "$rem_int" ]; then
  printf " ${DIM}|${RESET} ${ctx_color}ctx: %s%%${RESET}" "$rem_int"
  [ -n "$ctx_bar" ] && printf " ${ctx_color}%s${RESET}" "$ctx_bar"
fi
[ -n "$cost" ] && printf " ${DIM}| \$%.4f${RESET}" "$cost"
printf '\n'

# --- Line 2: conversation subject ---
if [ -n "$subject" ]; then
  printf "${DIM}> %s${RESET}\n" "$subject"
fi
