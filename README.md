# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Targets macOS with a tiling WM setup built around Neovim.

## Setup

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply daltongarrettpayne
```

Then install packages:

```sh
brew bundle --file ~/.Brewfile
```

Install third-party plugins (not tracked in this repo):

```sh
# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# then open tmux and press prefix + I to install plugins

# yazi tokyo-night flavor
cd ~/.config/yazi && ya pack -a dangooddd/tokyo-night
```

## What's included

| Config | Tool | Notes |
|--------|------|-------|
| `.zshrc` | Zsh | Minimal config with autosuggestions, syntax highlighting, zsh-vi-mode |
| `.gitconfig` | Git | Rebase-on-pull, credential manager |
| `.Brewfile` | Homebrew | Machine-type conditional installs (`personal` vs `work`) |
| `.config/nvim/` | Neovim | Kickstart-based config with custom plugins |
| `.config/aerospace/` | AeroSpace | Tiling WM with sketchybar integration |
| `.config/sketchybar/` | Sketchybar | macOS status bar |
| `.config/wezterm/` | WezTerm | Terminal emulator |
| `.config/yazi/` | Yazi | Terminal file manager |
| `.config/starship/` | Starship | Shell prompt |
| `.tmux.conf` | tmux | With TPM plugin manager |

## Machine types

Chezmoi templates branch on `.machineType` (`personal` or `work`):

- **personal** — full toolchain including Azure CLI, Databricks, Snowflake, media tools, Obsidian, etc.
- **work** — minimal base set only

Set on init:

```sh
chezmoi init --apply daltongarrettpayne
# chezmoi will prompt for machineType
```

Or edit `~/.config/chezmoi/chezmoi.toml` directly:

```toml
[data]
  machineType = "personal"
```

## Key tools

- **Editor**: Neovim (kickstart.nvim base)
- **Terminal**: WezTerm
- **Multiplexer**: tmux + TPM
- **Shell**: Zsh + Starship prompt
- **WM**: AeroSpace (tiling)
- **Status bar**: Sketchybar
- **File manager**: Yazi
- **Git TUI**: Lazygit
- **AI**: Claude Code

## Updating

```sh
chezmoi update          # pull latest and apply
chezmoi add <file>      # track a new or modified file
chezmoi diff            # preview pending changes
chezmoi apply           # apply source state to home dir
```
