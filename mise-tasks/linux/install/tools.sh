#! /usr/bin/env bash

#MISE description="Install some basic required system tools"
#MISE depends=["linux:system-update"]

# Contains a lot of the linxu tools available as packages
sudo apt install -y stow ripgrep bat eza zoxide btop apache2-utils fd-find tldr tmux cloc man

mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
ln -sf $(which fdfind) ~/.local/bin/fd
