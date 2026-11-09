#!/usr/bin/env bash
# Toggle forced transparency on the focused window.
# "on":  opacity is forced to $1 (default 0.95), overriding window rules.
# "off": opacity is forced to 1 (fully opaque), overriding window rules.
# Hyprland does not report per-window opacity, so a state file tracks each window.

OPACITY=${1:-0.95}

WINDOW=$(hyprctl activewindow -j)
ADDR=$(jq -r '.address' <<< "$WINDOW")
if [ -z "$ADDR" ] || [ "$ADDR" = "null" ]; then
  exit 0
fi

# Leave fullscreen windows alone: they should stay fully opaque.
if [ "$(jq -r '.fullscreen' <<< "$WINDOW")" != "0" ]; then
  exit 0
fi

STATE="${XDG_RUNTIME_DIR:-/tmp}/hypr-opacity-${ADDR#0x}"

set_opacity() {
  # Same "active override inactive override" form as window rules, so the value wins over them.
  hyprctl dispatch "hl.dsp.window.set_prop({prop=\"opacity\", value=\"$1 override $1 override\"})" >/dev/null
}

if [ "$(cat "$STATE" 2>/dev/null)" = "on" ]; then
  # On -> off: force fully opaque (overrides window rules too).
  set_opacity 1
  echo off > "$STATE"
else
  # Off (or no state yet) -> on: force the requested opacity.
  set_opacity "$OPACITY"
  echo on > "$STATE"
fi
