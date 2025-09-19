#!/usr/bin/env bash

#MISE description="Configures term info for ghostty, needed for older ncurses versions"

#!/bin/bash

# Get ncurses version from dpkg
current_version=$(dpkg-query -W -f='${Version}' libncurses6 2>/dev/null | cut -d'-' -f1)

# If libncurses6 not found, try libncurses5
if [[ -z "$current_version" ]]; then
    current_version=$(dpkg-query -W -f='${Version}' libncurses5 2>/dev/null | cut -d'-' -f1)
fi

# Check if we found a version
if [[ -z "$current_version" ]]; then
    echo "ncurses not found"
    exit 2
fi

# Compare with 6.5 using version sort
if printf '%s\n6.5\n' "$current_version" | sort -V | head -1 | grep -q "^6\.5$"; then
    echo "ncurses $current_version is newer than 6.5"
    echo "ghostty term info should be up to date"
    exit 0
else
    echo "ncurses $current_version is not newer than 6.5"
    echo "install ghostty term info"
    tic -x ../../files/xterm-ghostty
    exit 0
fi
