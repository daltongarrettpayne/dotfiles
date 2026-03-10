# Keyboard-Centric Desktop Environment

## Philosophy

Navigation should be intention-driven, not spatial. You should never need to
remember *where* something is — only *what* you want. The system's job is to
deliver it instantly.

There are two kinds of navigation:

- **Spatial**: "Slack is in workspace 4, so I go to workspace 4"
- **Intentional**: "I want Slack, so I press the Slack binding"

Spatial navigation fails when you don't remember the layout, when multiple apps
share a space, or when focus landed on the wrong window. Intentional navigation
doesn't fail — you always know what you want.

Workspaces are **containment** tools, not navigation tools. They manage what is
visible and what is out of the way. You navigate to *apps*. You navigate through
*workspaces* only to change your working mode.


## Space Model

### Three spaces

**Dev** (`01`) — primary work surface. Stable, predictable. A single dominant
app lives here permanently. You should be able to hit the dev key with your eyes
closed and know exactly what you'll see. Other apps may be pulled in temporarily
but do not reside here.

**Bench** (`02`) — temporary assembly space. Empty by default. You pull in
whatever combination of apps a specific task requires. When the task is done, you
clear it. It does not accumulate state between tasks.

**Hold** (`03`) — the parking lot. All apps that are not actively in use live
here. You do not navigate here to work. It exists so that idle apps are out of
your visual field without being closed.

### Rules

- An app's *home* is Hold unless it is the permanent resident of Dev.
- Apps visit Dev or Bench; they do not move in.
- Bench is empty at the start of any session. If it is not, clear it.


## Navigation Primitives

**Go-to** — teleports you to a specific app from anywhere, regardless of which
space it currently occupies. This is the primary navigation mechanism. Every
app you use regularly has a go-to binding. You never search, never cycle, never
workspace-hunt.

**Pull** — brings a specific app into your current space alongside what is already
there. Used when you need two apps visible simultaneously for a specific task.

**Send** — returns a specific app to Hold. The complement of Pull.

**Clear bench** — sends everything currently on Bench to Hold in a single action.
The canonical "I'm done with this task" binding.

**Back** — returns you to your previous location. Maintains a history stack across
workspaces and apps, like a browser's back button or vim's `ctrl-o`. Used when
you have jumped to something quickly and need to return without remembering where
you came from.


## What Success Looks Like

The system is working when:

1. **You never open a launcher to find an app.** Every app you use regularly is
   reachable in exactly two keystrokes. If you find yourself searching, the
   binding is missing.

2. **You never spam workspace keys looking for something.** Pressing 1, 2, 3
   repeatedly to locate a window means spatial navigation has crept back in.

3. **You can always get back.** After any context switch — however many hops
   deep — a single Back binding returns you to where you were.

4. **Bench is clear by default.** If Bench has accumulated windows from a
   previous session, it means Clear Bench wasn't used. The bench should feel
   like a clean workbench, not a junk drawer.

5. **Hold is invisible.** You should rarely visit Hold directly. If you find
   yourself going there to find something, that app needs a go-to binding.

6. **Dev is stable.** Its layout does not surprise you. It looks the same every
   time you return to it.


## Non-Goals

- This system is not designed to replace focus discipline. A go-to binding for
  a distracting app still takes you to that app. The architecture reduces
  *mechanical* friction; it does not enforce *behavioral* constraints.

- Workspaces are not project containers. They do not represent feature branches,
  client contexts, or active tickets. They represent modes of work.
