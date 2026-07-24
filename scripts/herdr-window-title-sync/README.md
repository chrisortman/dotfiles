# Herdr Window Title Sync

> [!Note] Copied / forked from https://github.com/rjyo/herdr-window-title-sync but I don't want it in a separate repo and don't want to use bun. Reimplemented in Zig instead of the original Bun/TypeScript.

Sync the outer terminal window/tab title to the focused Herdr workspace, tab, and agent session.

This is useful for terminals and clients that track the terminal title, similar to tmux `set-titles`.

I made this because I wanted Herdr sessions to show useful titles in [Moshi](https://getmoshi.app). Tmux already updates the terminal title, so resumed sessions are easy to recognize. Herdr did not do that in the same way, and `1` was not enough context.

## Install

```sh
herdr plugin install rjyo/herdr-window-title-sync
```

For local development:

```sh
zig build
herdr plugin link .
```

The plugin invokes the compiled `zig-out/bin/sync-title` binary directly, so
run `zig build` once after installing or pulling changes, and again any time
`src/main.zig` changes.

## What It Shows

The plugin chooses the first available title:

1. Herdr pane metadata title, when an integration reports one.
2. Herdr display agent and custom status.
3. Latest user prompt from local Codex or Claude Code session files.
4. Herdr's detected agent name.
5. The focused tab as a fallback, numbered by its switch order (prefix + N).

The focused workspace name is appended in parentheses. Examples:

```text
codex: Implement title sync (app-ios)
claude (app-ios)
tab 2 (app-ios)
tab 5 / sim (app-ios)
```

## Manual Refresh

```sh
herdr plugin action invoke rjyo.window-title-sync.refresh
```

## Privacy

The plugin runs locally and does not send data over the network. As a fallback, it reads local Codex and Claude Code session JSONL files to find a useful title when Herdr does not expose one directly. That means prompt text may appear in your terminal window/tab title.

## Requirements

- Herdr `0.7.0` or newer
- Zig `0.16.0` (pinned in `mise.toml`) to build the plugin
- macOS or Linux

## License

MIT
