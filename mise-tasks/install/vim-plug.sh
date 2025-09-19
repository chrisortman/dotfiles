#!/usr/bin/env bash

#MISE description="Installs vim plugin manager Plug"
#MISE depends=["install::required-packages"]

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
