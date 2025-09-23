#!/usr/bin/env bash

set -o e

mise trust .
mise run stow
mise install

