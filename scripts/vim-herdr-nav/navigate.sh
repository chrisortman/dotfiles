#!/usr/bin/env bash
set -euo pipefail

DIRECTION=$1  # left/right/up/down
KEY=$2        # ctrl+h/j/k/l

# HERDR_PANE_ID is injected by herdr when a keybinding triggers this action
INFO=$(herdr pane process-info --pane "$HERDR_PANE_ID")

# Check if vim or neovim is the foreground process
if echo "$INFO" | grep -qiE '"name":"n?vim"'; then
    herdr pane send-keys "$HERDR_PANE_ID" "$KEY"
else
    herdr pane focus --direction "$DIRECTION"
fi
