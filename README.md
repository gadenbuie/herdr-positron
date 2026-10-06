# herdr-positron

A small [Herdr](https://herdr.dev) plugin that opens a Space's directory in
[Positron](https://positron.posit.co), the IDE based on VS Code.

Herdr workspaces don't carry a path themselves, so the plugin resolves the
directory from the Space's panes: it takes the focused pane's `cwd`, falling
back to the first pane in the Space. It then launches `positron <dir>`
detached, so the action returns immediately instead of blocking the UI.

## Files

- `herdr-plugin.toml` — plugin manifest. Declares one action, `open`, with
  `contexts = ["workspace"]`, declaring it as a workspace-level action.
- `open-positron.sh` — the action script.

## Install

Link the plugin from a local checkout:

```bash
herdr plugin link /path/to/herdr-positron
herdr plugin action list --plugin positron
```

## Usage

- Press `prefix+p` (see keybinding below), or
- invoke it from the CLI:

  ```bash
  herdr plugin action invoke positron.open
  ```

> **Note:** Right-click context menus don't show plugin actions yet. The
> manifest's `contexts = ["workspace"]` declares where the action belongs,
> but Herdr's right-click menus are still a fixed builtin list
> (tracked in [herdrdev/herdr#1722](https://github.com/ogulcancelik/herdr/discussions/1722)).
> Once that lands, the action should appear automatically — no manifest
> change needed.

## Keybinding

Add to `~/.config/herdr/config.toml`:

```toml
[[keys.command]]
key = "prefix+p"
type = "plugin_action"
command = "positron.open"
description = "open space in Positron"
```

## Configuration

Set `POSITRON_CMD` to override the editor command (defaults to `positron` on
your `PATH`).

## Troubleshooting

Plugin logs are available with:

```bash
herdr plugin log list --plugin positron
```
