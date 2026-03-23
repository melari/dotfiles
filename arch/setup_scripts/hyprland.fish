#!/usr/bin/env fish

./kitty.fish; or exit $status

sudo pacman -Syu --needed --noconfirm hyprlauncher waybar polkit-gnome mako bluez bluez-utils blueman network-manager-applet; or exit $status

mkdir -p ~/.config/hypr
lib/safelink.fish hyprland/hyprland.conf ~/.config/hypr/hyprland.conf; or exit $status

mkdir -p ~/.config/waybar
lib/safelink.fish waybar/config.jsonc ~/.config/waybar/config.jsonc; or exit $status
lib/safelink.fish waybar/style.css ~/.config/waybar/style.css; or exit $status

mkdir -p ~/.config/mako
lib/safelink.fish mako/config ~/.config/mako/config; or exit $status

echo "⚠️ Hyprland has been configured, but you will need to log out to apply changes"
