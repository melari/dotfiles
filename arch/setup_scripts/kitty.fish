#!/usr/bin/env fish

sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd; or exit $status
lib/safelink.fish kitty/kitty.conf ~/.config/kitty/kitty.conf; or exit $status
