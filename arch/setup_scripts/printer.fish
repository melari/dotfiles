#!/usr/bin/env fish

sudo pacman -Syu --needed --noconfirm cups cups-pdf avahi
sudo systemctl enable avahi-daemon.socket
sudo systemctl enable cups.socket
