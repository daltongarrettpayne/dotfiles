# Desktop Environment — Implementation Plan

Reference: `desktop-environment.md` for philosophy and success criteria.

Tools: AeroSpace (window manager), Karabiner-Elements (keyboard layer),
shell scripts (pull/send/clear/back logic).


## Phase 1 — Space Restructure

**Goal:** Aerospace config reflects the three-space model.

Tasks:
- Rename workspaces: `01-dev`, `02-bench`, `03-hold`
- Update `on-window-detected` rules:
  - WezTerm → `01-dev`
  - Everything else → `03-hold` (including browser, Slack, Mail, Calendar, music)
  - Floating utilities (Finder, CleanShot) → float in current workspace, no move
- Remove the catch-all move-to-workspace rule that routes unknowns to float
- Set default layout for each workspace (tiled for dev, tiled for bench, anything for hold)

**Done when:** Opening any app routes it to the correct space automatically.
No app lands in dev or bench without being explicitly pulled there.


## Phase 2 — Go-To Bindings

**Goal:** Every regularly-used app is reachable in 2 keystrokes from anywhere.

Tasks:
- Map Caps Lock → Hyper key (Cmd+Ctrl+Opt+Shift) via Karabiner-Elements
- Define flat Hyper+letter bindings for each app (initially via `open -a`):
  - Hyper+T → WezTerm (terminal)
  - Hyper+S → Slack
  - Hyper+M → Mail
  - Hyper+B → Browser (Arc)
  - Hyper+C → Calendar
  - Hyper+N → Notion
  - Hyper+F → Finder (floating, in current space)
  - Add others as needed
- Test: from each workspace, verify every binding reaches its target

**Done when:** You can reach any app from any workspace without thinking about
where it lives.

Open question: `open -a` focuses the app if running. If the app has multiple
windows, it focuses the most recent. Verify this is acceptable for each app,
or replace with `aerospace focus --app-id` for more precise control.


## Phase 3 — Pull / Send / Clear Bench

**Goal:** You can assemble and disassemble multi-app layouts on Bench fluidly.

### Scripts needed

**`pull-app.sh <app-bundle-id>`**
Finds the window for the given app and moves it to the currently focused
workspace. Focuses the window after moving.

```
aerospace list-windows --all → find window ID by app ID
aerospace move-node-to-workspace --window-id <id> $(aerospace list-workspaces --focused)
aerospace focus --window-id <id>
```

**`send-app.sh <app-bundle-id>`**
Moves the window for the given app to `03-hold`.

```
aerospace list-windows --all → find window ID by app ID
aerospace move-node-to-workspace --window-id <id> 03-hold
```

**`clear-bench.sh`**
Moves all windows currently on `02-bench` to `03-hold`.

```
aerospace list-windows --workspace 02-bench → get all window IDs
for each: aerospace move-node-to-workspace --window-id <id> 03-hold
```

### Bindings

Pull and Send bindings need a separate modifier or mode to distinguish from
Go-To. Options (decide before implementing):

- **Option A — Hyper+Shift+letter for Pull, Hyper+Ctrl+letter for Send.**
  Simple. No modes. Slightly finger-intensive.

- **Option B — Aerospace service mode.** Enter a pull/send mode with a binding,
  then press the app letter. Cleaner namespacing but adds a mode to remember.

- **Option C — Pull only, no per-app Send.** You only need Pull to bring an app
  in. When done, use Clear Bench for everything. Never need per-app Send.
  Simpler. Works if you always clear at task end rather than sending individual
  apps back mid-task.

Clear Bench: single binding, no ambiguity. Assign one Hyper+key (e.g. Hyper+0
or a dedicated key).

**Done when:** You can go to Bench, pull in Slack and browser, work, and clear
with one binding — in under 10 seconds total, no mouse.


## Phase 4 — Navigation History (Back)

**Goal:** A single binding returns you to your previous location after any
context switch.

### Mechanism

Aerospace fires `exec-on-workspace-change` on every workspace switch. Use this
hook to append to a history file. A "Back" binding reads and pops the file.

**`record-history.sh`** (called by `exec-on-workspace-change`)
```
PREV=$AEROSPACE_PREV_WORKSPACE
HISTORY_FILE=~/.cache/aerospace-history

# Append previous workspace to history stack
echo "$PREV" >> "$HISTORY_FILE"

# Cap history at 20 entries
tail -20 "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
```

**`go-back.sh`**
```
HISTORY_FILE=~/.cache/aerospace-history

# Get last entry, remove it from stack
LAST=$(tail -1 "$HISTORY_FILE")
head -n -1 "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

# Switch to that workspace
aerospace workspace "$LAST"
```

Hook into aerospace config:
```toml
exec-on-workspace-change = ['/bin/bash', '-c',
  '~/.config/aerospace/record-history.sh'
]
```

Bind `go-back.sh` to a Karabiner binding (e.g. Hyper+Backspace or a dedicated
key).

**Caveat:** This tracks workspace history only, not app-level focus history.
It answers "where was I?" in terms of workspace, not "which specific window
was focused." This covers the described use case (context-switched, lost your
workspace) but not sub-workspace history within a workspace.

**Done when:** After jumping to any app via go-to (which may switch workspace),
a single Back binding returns you to the workspace you came from. Works across
multiple hops.


## Implementation Order

1. Phase 1 first — restructure without changing any bindings. Verify apps land
   in the right spaces. Use this for a day before adding new bindings.
2. Phase 2 — add go-to bindings. Use for several days. This is the highest
   value change.
3. Phase 4 — add Back before adding Pull/Send. Back is simpler and immediately
   useful.
4. Phase 3 last — Pull/Send/Clear adds complexity. Only needed once you've
   confirmed the three-space model works for you.


## Open Questions (decide before implementing each phase)

- Phase 2: Should Go-To bindings use Karabiner exclusively, or should some be
  in Aerospace directly via `exec-and-forget open -a`? (Karabiner is more
  flexible; Aerospace-only is simpler.)

- Phase 3: Which Pull/Send binding option (A, B, or C above)?

- Phase 3: What is the exact app bundle ID for each app you want pull/send
  bindings for? (Run `aerospace list-windows --all` to find them.)

- Phase 4: Does workspace-level Back satisfy the use case, or do you need
  app-level focus history too?
