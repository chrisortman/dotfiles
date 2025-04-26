#!/usr/bin/env bash

#MISE description="Installs vim plugin manager Plug"
#MISE depends=["system-update"]

apt install zsh

# Install the antidote plugin manager
git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote

chsh -s $(which zsh)
