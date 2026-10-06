#!/usr/bin/env bash
# Herdr plugin action: open the current Space's directory in Positron.
#
# Context: runs with the plugin directory as cwd; Herdr injects
# HERDR_WORKSPACE_ID (the Space the action was invoked on) and
# HERDR_PLUGIN_CONTEXT_JSON.
set -euo pipefail

herdr_bin="${HERDR_BIN_PATH:-herdr}"
workspace="${HERDR_WORKSPACE_ID:-}"
editor_cmd="${POSITRON_CMD:-positron}"

# Fall back to the invocation context JSON if the env var is missing.
if [[ -z "$workspace" && -n "${HERDR_PLUGIN_CONTEXT_JSON:-}" ]]; then
  workspace=$(printf '%s' "$HERDR_PLUGIN_CONTEXT_JSON" |
    jq -r '.workspace.workspace_id // .workspace_id // empty')
fi

if [[ -z "$workspace" ]]; then
  echo "open-positron: no workspace in invocation context" >&2
  exit 1
fi

# Resolve the Space's directory: prefer the focused pane's cwd, then any pane.
dir=$("$herdr_bin" pane list --workspace "$workspace" |
  jq -r '.result.panes
    | (map(select(.focused)) | first) // first
    | .cwd // empty')

if [[ -z "$dir" || ! -d "$dir" ]]; then
  echo "open-positron: could not resolve a directory for workspace $workspace" >&2
  exit 1
fi

# Detach so the action returns immediately instead of blocking the UI.
nohup "$editor_cmd" "$dir" >/dev/null 2>&1 &
