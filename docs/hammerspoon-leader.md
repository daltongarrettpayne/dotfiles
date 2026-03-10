# Hammerspoon Leader Key System

Reference for `dot_hammerspoon/init.lua.tmpl`.

## How it works

Right Command on the external keyboard is remapped to F17 via Karabiner-Elements.
F17 has two behaviors depending on how it's used:

**Hold F17** — modifier-style. While held, 1/2/3 switch workspaces instantly.
No sequence, no timeout. Release without pressing anything = tap path.

**Tap F17** — sequential leader mode. A 2-second timeout window opens.
Press a key to trigger a direct action, or press a category prefix then an action key.
Timeout sends Escape to cancel any in-progress menu/prompt.

## Karabiner rule

`dot_config/private_karabiner/private_karabiner.json`

- External keyboard: Right Command → F17
- Built-in keyboard: Caps Lock → Escape, modifier remaps (Cmd↔Opt↔Ctrl)
- Condition: `device_unless is_built_in_keyboard` scopes the F17 rule to the Keychron only

## Bindings

### Hold F17

| Keys | Action |
|------|--------|
| `1` / `2` / `3` | switch to 01-dev / 02-bench / 03-hold |
| `⇧1` / `⇧2` / `⇧3` | move focused window to workspace |

### Tap F17 — direct (single key)

| Key | Action |
|-----|--------|
| `o` | back to previous workspace |
| `b` | Arc |
| `m` | TIDAL |
| `1` / `2` / `3` | switch workspace |
| `⇧1` / `⇧2` / `⇧3` | move window to workspace |
| `?` | toggle cheat sheet overlay |

### Tap F17 — category sequences

| Sequence | Action |
|----------|--------|
| `c → s` | Slack |
| `c → m` | Mail |
| `c → c` | Calendar (personal) / Notion Calendar (work) |
| `c → n` | Notion (work only) |
| `c → g` | Granola (work only) |
| `d → t` | WezTerm |
| `d → p` | Postico 2 |
| `s → f` | Finder |
| `s → s` | System Settings |
| `s → v` | OpenVPN Connect |
| `w → f` | fullscreen toggle |
| `w → m` | minimize focused window |
| `r → h` | reload Hammerspoon |
| `r → s` | reload Sketchybar |
| `r → a` | reload Aerospace config |

**Shift + app key = pull into current workspace.**
Example: `c → ⇧s` moves Slack's window to the focused workspace instead of jumping to it.
Pull only works for app entries (not `w` or `r` commands).

## Category map

| Prefix | Group |
|--------|-------|
| `c` | comms |
| `d` | dev tools |
| `s` | system |
| `w` | window management |
| `r` | reload/restart |

`b` and `m` are direct bindings (no category) until a natural group emerges.

## Adding a new app

1. Get the bundle ID: `osascript -e 'id of app "App Name"'`
2. Add to the appropriate category in `apps` table in `init.lua.tmpl`
3. Add comment to the header block
4. Add row to the cheat sheet HTML
5. `chezmoi apply ~/.hammerspoon/init.lua` then reload Hammerspoon

## Adding a new command (non-app)

Use the `cmd` key instead of `name`/`id`:
```lua
w = {
  x = { cmd = function() -- do something end },
}
```
The keyWatcher checks for `entry.cmd` first — if present, calls it directly
instead of launching an app. Pull (shift) is ignored for `cmd` entries.

## Workspace model

See `desktop-environment.md` for philosophy. Short version:
- `01-dev` — permanent terminal, stable layout
- `02-bench` — temporary assembly, clear when done
- `03-hold` — parking lot, everything idle lives here

`prevWorkspace` is tracked in Lua state on every switch made via the leader key.
`leader → o` jumps back to it. Only tracks leader-initiated switches.

## Files

| Source | Deployed |
|--------|----------|
| `dot_hammerspoon/init.lua.tmpl` | `~/.hammerspoon/init.lua` |
| `dot_config/private_karabiner/private_karabiner.json` | `~/.config/karabiner/karabiner.json` |
| `dot_config/aerospace/aerospace.toml.tmpl` | `~/.config/aerospace/aerospace.toml` |
| `dot_config/sketchybar/items/aerospace_compact.sh.tmpl` | `~/.config/sketchybar/items/aerospace_compact.sh` |
