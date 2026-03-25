#!/usr/bin/env fish

# Required to make sure ~/.local/bin directory exists
# The config.fish also exports ENV to make sure the
# packages are only installed locally for the user
./fish.fish; or exit $status

sudo pacman -S --needed --noconfirm nodejs npm
