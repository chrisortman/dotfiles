#!/usr/bin/env bash
set -euo pipefail

TAB_NUM=$1 #1,2,3,4
echo "TAB NUM: $TAB_NUM"

WORKSPACE_ID=$(herdr workspace list | jrf -o tsv '_["result"]["workspaces"] >> flat >> select(_["focused"] == true) >> _["workspace_id"]')
TAB_ID=$(herdr tab list --workspace $WORKSPACE_ID | jrf -o tsv '_["result"]["tabs"] >> flat >> sort(_["number"]) >> select(_["number"] == '"$TAB_NUM"') >> _["tab_id"]')

echo "WORKSPACE: ${WORKSPACE_ID}"
echo "TAB_ID: ${TAB_ID}"

herdr tab focus $TAB_ID
