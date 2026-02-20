# Tmux Configuration

A minimal, vim-friendly tmux configuration with smart aerospace window manager integration.

## Key Features

### 🎨 Visual Design
- **Active/Inactive Pane Distinction**: Active panes are bright (`#1a1b26`), inactive are dimmed (`#0f0f14`)
- **Minimal Borders**: Only shows colored command name at top of each pane (green for active, gray for inactive)
- **Minimalist Status Bar**: Shows only session name `[session]` and window info
- **Tokyo Night Colors**: Matches overall terminal color scheme

### ⚡ Performance
- **Zero ESC Delay**: `escape-time 0` ensures instant response in vim/nvim
- **Smart Window Numbering**: Starts at 1, automatically renumbers when windows close
- **Mouse Support**: Scroll and select with mouse

### 🚀 Aerospace Integration
- **Unified Navigation**: Alt+hjkl navigates seamlessly across tmux, nvim, and aerospace windows
- **Smart Detection**: Automatically detects if you're in nvim and routes commands appropriately
- **No Conflicts**: C-hjkl bindings disabled to prevent interference with aerospace

### 📋 Copy Mode
- **Vi Keybindings**: Navigate with hjkl, visual mode with `v`, yank with `y`
- **Smart Yanking**: `y` copies and stays in copy mode, `Enter` copies and exits
- **System Clipboard**: Automatically copies to macOS clipboard via `pbcopy`
- **Pane Navigation**: C-hjkl works in copy mode to switch panes while selecting

## Installation

### Prerequisites
```bash
# Install tmux
brew install tmux

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Setup
```bash
# Apply the configuration
chezmoi apply ~/.tmux.conf

# Start tmux
tmux

# Install plugins: Press prefix + I (default: Ctrl-b then I)
```

## Keybindings

### Session Management (No Prefix)
| Key | Action |
|-----|--------|
| `Alt + s` | Show session list |
| `Alt + Shift + N` | Create new session |
| `Alt + Shift + X` | Kill current session |

### Window Splits
| Key | Action |
|-----|--------|
| `prefix + \|` | Vertical split (with prefix) |
| `prefix + -` | Horizontal split (with prefix) |
| `Alt + Shift + \|` | Vertical split (no prefix) |
| `Alt + Shift + _` | Horizontal split (no prefix) |

### Pane Navigation
| Key | Action |
|-----|--------|
| `Alt + h/j/k/l` | Navigate panes (via aerospace) |
| `C-h/j/k/l` | Navigate in copy mode |

### Pane Resizing (Repeatable)
| Key | Action |
|-----|--------|
| `prefix + Alt + ↑/↓/←/→` | Resize pane by 10 units |

### Copy Mode
| Key | Action |
|-----|--------|
| `Alt + [` | Enter copy mode (or nvim normal mode if in nvim) |
| `v` | Start visual selection (in copy mode) |
| `y` | Yank to clipboard, stay in copy mode |
| `Enter` | Yank to clipboard and exit copy mode |
| `q` | Exit copy mode |

### Plugin Management
| Key | Action |
|-----|--------|
| `prefix + I` | Install plugins |
| `prefix + U` | Update plugins |
| `prefix + alt + u` | Uninstall plugins not in config |

## Plugins

### TPM (Tmux Plugin Manager)
Plugin manager for tmux. Handles installation and updates.

### tmux-which-key
Shows available keybindings in a popup. Press `prefix + ?` to see all bindings.

### tmux-yank
Enhanced copying and yanking. Configured to stay in copy mode after yanking with `y`.

## Configuration Structure

The configuration is organized into clear sections:

1. **Core Settings**: Performance, terminal settings, vi mode
2. **Prefix Key**: Prefix configuration (currently `C-b`)
3. **Visual Styling**: Colors, borders, status bar
4. **Keybindings - Prefix Mode**: Traditional tmux bindings requiring prefix
5. **Keybindings - Root Mode**: Alt-key bindings that work without prefix
6. **Pane Navigation**: Aerospace integration notes
7. **Copy Mode Keybindings**: Vi-style selection and yanking
8. **Plugins**: Plugin declarations and configuration

## Workflow Tips

### Creating Sessions
```bash
# Create named session
tmux new -s myproject

# Or from within tmux: Alt + Shift + N
```

### Managing Windows
```bash
# Create new window
prefix + c

# Navigate windows
prefix + n  # next
prefix + p  # previous
prefix + 0-9  # jump to window number
```

### Copy Mode Workflow
1. Enter copy mode: `Alt + [`
2. Navigate with vi keys: `h j k l`
3. Start selection: `v`
4. Extend selection with vi motions
5. Yank: `y` (stays in copy mode) or `Enter` (exits)
6. Exit: `q`

### Integration with Aerospace
This configuration is designed to work seamlessly with [aerospace window manager](https://github.com/nikitabobko/AeroSpace):

- Use `Alt + h/j/k/l` to navigate between aerospace windows, tmux panes, and nvim splits
- The `navigate.sh` script handles routing the navigation commands appropriately
- No need to think about whether you're in tmux or aerospace—navigation just works

## Customization

### Change Prefix Key
Uncomment and modify in the config:
```tmux
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix
```

### Add Custom Colors
Modify the color hex values in the "Visual Styling" section:
```tmux
set -g window-style 'fg=#565f89,bg=#0f0f14'          # Inactive panes
set -g window-active-style 'fg=#c0caf5,bg=#1a1b26'   # Active pane
```

### Add More Keybindings
Add custom bindings under the appropriate section. Use:
- `bind key command` for prefix bindings
- `bind -n key command` for root (no prefix) bindings

## Troubleshooting

### Colors Not Working
Ensure your terminal supports 256 colors and true color:
```bash
echo $TERM  # should show xterm-256color or similar
```

### Plugins Not Loading
1. Make sure TPM is installed: `~/.tmux/plugins/tpm`
2. Press `prefix + I` to install plugins
3. Restart tmux: `tmux kill-server && tmux`

### ESC Key Delay
The configuration sets `escape-time 0` to eliminate delay. If you still experience delay, check if your terminal or shell is adding extra delay.

### Clipboard Not Working
On macOS, ensure `pbcopy` is available:
```bash
which pbcopy  # should return /usr/bin/pbcopy
```

## Resources

- [Tmux Manual](https://man7.org/linux/man-pages/man1/tmux.1.html)
- [TPM Repository](https://github.com/tmux-plugins/tpm)
- [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key)
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank)
