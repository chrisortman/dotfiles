#!/usr/bin/env bash

#MISE description="Installs zshell and makes it the default and sets up antidote for plugins"
#MISE depends=["system-update"]

sudo apt install -y zsh

# Install the antidote plugin manager
git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote

# Sometimes get a password prompt in orb so need to do this
# as root
sudo chsh -s $(which zsh) $(whoami)
