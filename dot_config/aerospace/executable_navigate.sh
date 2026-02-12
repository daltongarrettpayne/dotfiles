#!/bin/bash
# navigate.sh - Unified navigation: Neovim splits → tmux panes → Aerospace windows
# Called by Aerospace exec-and-forget on Alt+hjkl
# Usage: navigate.sh left|down|up|right

AEROSPACE="/opt/homebrew/bin/aerospace"
TMUX="/opt/homebrew/bin/tmux"

DIRECTION="$1"

case "$DIRECTION" in
    left)  TMUX_DIR="-L"; TMUX_EDGE="pane_at_left";   VIM_KEY="M-h" ;;
    down)  TMUX_DIR="-D"; TMUX_EDGE="pane_at_bottom";  VIM_KEY="M-j" ;;
    up)    TMUX_DIR="-U"; TMUX_EDGE="pane_at_top";     VIM_KEY="M-k" ;;
    right) TMUX_DIR="-R"; TMUX_EDGE="pane_at_right";   VIM_KEY="M-l" ;;
    *)     exit 1 ;;
esac

# Check if focused window is WezTerm
FOCUSED_APP=$($AEROSPACE list-windows --focused --format '%{app-bundle-id}' 2>/dev/null)
if [ "$FOCUSED_APP" != "com.github.wez.wezterm" ]; then
    $AEROSPACE focus --boundaries-action wrap-around-the-workspace "$DIRECTION"
    exit 0
fi

# Check if tmux has an attached session
if ! $TMUX list-sessions -F '#{session_attached}' 2>/dev/null | grep -q '1'; then
    $AEROSPACE focus --boundaries-action wrap-around-the-workspace "$DIRECTION"
    exit 0
fi

# Check if active tmux pane is running vim/neovim (set by smart-splits.nvim)
PANE_IS_VIM=$($TMUX display-message -p '#{@pane-is-vim}' 2>/dev/null)

if [ "$PANE_IS_VIM" = "1" ]; then
    # Vim is running — send C-hjkl directly to the pane.
    # smart-splits.nvim handles the full chain: nvim edge → tmux pane → aerospace
    $TMUX send-keys "$VIM_KEY"
    exit 0
fi

# Not vim — check if tmux pane is at the edge
AT_EDGE=$($TMUX display-message -p "#{$TMUX_EDGE}" 2>/dev/null)

if [ "$AT_EDGE" = "1" ]; then
    $AEROSPACE focus --boundaries-action wrap-around-the-workspace "$DIRECTION"
else
    $TMUX select-pane "$TMUX_DIR"
fi
