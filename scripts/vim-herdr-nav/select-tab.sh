#!/usr/bin/env bash
set -euo pipefail

HERDR="${HERDR_BIN_PATH:-herdr}"

TAB_NUM=$1 #1,2,3,4
echo "TAB NUM: $TAB_NUM"

WORKSPACE_ID="${HERDR_ACTIVE_WORKSPACE_ID:-$("$HERDR" workspace list | mise exec ruby@3.4.6 -- jrf -o tsv '_["result"]["workspaces"] >> flat >> select(_["focused"] == true) >> _["workspace_id"]')}"
TAB_ID=$("$HERDR" tab list --workspace $WORKSPACE_ID | mise exec ruby@3.4.6 -- jrf -o tsv '_["result"]["tabs"] >> flat >> sort(_["number"]) >> select(_["number"] == '"$TAB_NUM"') >> _["tab_id"]')

echo "WORKSPACE: ${WORKSPACE_ID}"
echo "TAB_ID: ${TAB_ID}"

"$HERDR" tab focus $TAB_ID
