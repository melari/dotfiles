#!/usr/bin/env fish

sudo pacman -Syu --needed --noconfirm udisks2 udiskie ntfs-3g exfatprogs dosfstools
sudo systemctl enable --now udisks2.service
