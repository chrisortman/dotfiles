#!/usr/bin/env bash

#MISE description="Installs zshell and makes it the default and sets up antidote for plugins"
#MISE depends=["linux:system-update"]

sudo apt install -y zsh

# Sometimes get a password prompt in orb so need to do this
# as root
sudo chsh -s $(which zsh) $(whoami)
