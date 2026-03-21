#!/usr/bin/env fish

if command -v yay >/dev/null
    echo "✅ yay is available"
    exit 0
end

sudo pacman -Syu --needed base-devel git

mkdir -p ~/src
cd ~/src

if not test -d yay
    git clone https://aur.archlinux.org/yay.git
end

cd yay

makepkg -si
