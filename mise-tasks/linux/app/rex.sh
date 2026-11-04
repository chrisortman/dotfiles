#!/usr/bin/env bash

#MISE description="Installs the rex multiplexer and pins it so Debian's unrelated rex package can't replace it"

set -euo pipefail

# The superlogical installer adds the apt source, signing key and repo credentials.
# It needs REX_PACKAGE_TOKEN, which mise loads from ~/.secrets
if [ ! -f /etc/apt/sources.list.d/rex.sources ]; then
  if [ -z "${REX_PACKAGE_TOKEN:-}" ]; then
    echo "REX_PACKAGE_TOKEN is not set. Add it to ~/.secrets and re-run." >&2
    exit 1
  fi
  curl -fsSL -u "rex:$REX_PACKAGE_TOKEN" https://pkgs.superlogical.com/rex/install.sh | sh
fi

# Debian ships an unrelated Perl tool also named rex with a higher version number.
# Prefer our repo, and never allow Ubuntu's package even if our repo index is
# missing during an upgrade (that is how it got swapped on 2026-10-31)
sudo tee /etc/apt/preferences.d/rex >/dev/null <<'EOF'
Package: rex
Pin: origin pkgs.superlogical.com
Pin-Priority: 1001

Package: rex
Pin: release o=Ubuntu
Pin-Priority: -1
EOF

sudo apt-get update
sudo apt-get install -y --allow-downgrades rex

# A running server keeps the old binary until restarted, which ends its sessions
installed=$(dpkg-query -W -f='${Version}' rex)
running=$(rex server status --autostart=false 2>/dev/null | awk '/^version:/ {print $2}' || true)
if [ -n "$running" ] && [ "$running" != "$installed" ]; then
  echo "rex server is running $running but $installed is installed."
  echo "Close your sessions, then restart it:"
  echo "  rex server stop && rex server start --extra-listen :7297 --allow-anonymous && rex server tailscale on"
fi
