#!/bin/bash

#MISE description="Installs helix editor https://helix-editor.com/"
#MISE depends=["linux:system-update"]

sudo add-apt-repository ppa:maveonair/helix-editor
sudo apt update
sudo apt -y install helix
