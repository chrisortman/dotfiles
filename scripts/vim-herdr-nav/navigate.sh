#!/usr/bin/env bash
set -euo pipefail

DIRECTION=$1  # left/right/up/down
KEY=$2        # ctrl+h/j/k/l

# HERDR_PANE_ID is injected by herdr when a keybinding triggers this action
HERDR="${HERDR_BIN_PATH:-herdr}"

INFO=$("$HERDR" pane process-info --pane "$HERDR_PANE_ID")

# Check if vim or neovim is the foreground process
if echo "$INFO" | grep -qiE '"name":"n?vim"'; then
    "$HERDR" pane send-keys "$HERDR_PANE_ID" "$KEY"
else
    "$HERDR" pane focus --direction "$DIRECTION" --pane "$HERDR_PANE_ID"
fi
