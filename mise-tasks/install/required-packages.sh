#! /usr/bin/env bash

#MISE description="Installs some required packages for us to do anything"
#MISE depends=["system-update"]

sudo apt install -y wget curl git unzip software-properties-common
