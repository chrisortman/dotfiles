#! /usr/bin/env bash

#MISE description="Install some basic required system tools"
#MISE depends=["system-update"]
#
# Contains a lot of the linxu tools available as packages
#
sudo apt install -y stow ripgrep bat eza zoxide btop apache2-utils fd-find tldr tmux cloc

# Ubuntu has a really old fzf so we install it using mise instead. the biggest
# difference compatability wise is that presence of a command for shell integration
# `fzf --zsh` which is not present in the version that ships with ubuntu
mise use -g fzf

mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
ln -sf $(which fdfind) ~/.local/bin/fd
