#!/usr/bin/env bash

# when I don't give a shebang the source command isn't available
# probably it gets invoked with just sh?

set -e

# This is about making sure you get git on the
# machine and then can clone the source files and 
# use them to run the install
# This is what omakub does
sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null


# for now I'm going to keep it, but assume
# I'm already running out of the cloned dotfiles repo
#
echo "Running installer"
source ~/.dotfiles/install.sh
