#!/usr/bin/env fish

# Cursor theme setup.
#
# CachyOS (cachyos-hypr-noctalia) shipped Bibata-Modern-Ice via /etc/skel at
# install time, overriding the upstream default in four places: the cursor env
# vars in ~/.config/uwsm/env, an ~/.icons/default override, a vendored (unowned,
# never-updated) theme copy in ~/.local/share/icons, and the GTK/gsettings keys.
#
# The vendored copy is deliberately left in place -- nothing reads it once the
# theme below is set, and it costs a few MB to keep around as a fallback.
#
# This script makes the dotfiles authoritative instead. To change themes, set
# the two variables below and the matching hl.env calls in
# hyprland/config/environment.lua, then re-run.

set cursor_theme Adwaita
set cursor_size 24

# Package providing the theme. Adwaita ships in adwaita-cursors; default-cursors
# owns /usr/share/icons/default, the tail of the XCursor fallback chain.
set cursor_packages adwaita-cursors default-cursors

sudo pacman -Syu --needed --noconfirm $cursor_packages; or exit $status

# Sets key=value in a GTK settings.ini, creating the file if needed.
function set_ini_key -a file key value
    mkdir -p (dirname $file)

    if not test -f $file
        printf '[Settings]\n' >$file
    end

    if grep -qE "^$key=" $file
        sed -i -E "s,^$key=.*,$key=$value," $file
    else if grep -qF '[Settings]' $file
        sed -i "/^\[Settings\]/a $key=$value" $file
    else
        printf '%s=%s\n' $key $value >>$file
    end
end

# 1. Stop ~/.config/uwsm/env from competing with environment.lua. The rest of
#    that file (BROWSER, QT_QPA_*, ...) is CachyOS's and left untouched.
set uwsm_env ~/.config/uwsm/env
if test -f $uwsm_env; and grep -qE '^export (X|HYPR)CURSOR_' $uwsm_env
    sed -i -E 's,^export ((X|HYPR)CURSOR_[A-Z_]*=.*),# \1  # cursor managed by dotfiles: hyprland/config/environment.lua,' $uwsm_env
    echo "💤 Commented out the cursor exports in $uwsm_env"
end

# 2. XCursor fallback chain, for apps that read neither the env vars nor
#    gsettings. Adwaita is the tail of the chain anyway, but being explicit
#    means a theme swap only touches this script and environment.lua.
mkdir -p ~/.icons/default
printf '[Icon Theme]\nName=Default\nComment=Default Cursor Theme\nInherits=%s\n' $cursor_theme >~/.icons/default/index.theme
echo "🖱️ ~/.icons/default now inherits $cursor_theme"

# 3. GTK and the portal.
gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme
gsettings set org.gnome.desktop.interface cursor-size $cursor_size
set_ini_key ~/.config/gtk-3.0/settings.ini gtk-cursor-theme-name $cursor_theme
set_ini_key ~/.config/gtk-3.0/settings.ini gtk-cursor-theme-size $cursor_size
set_ini_key ~/.config/gtk-4.0/settings.ini gtk-cursor-theme-name $cursor_theme
set_ini_key ~/.config/gtk-4.0/settings.ini gtk-cursor-theme-size $cursor_size

# 4. Apply to the running compositor so a re-login isn't needed.
if type -q hyprctl; and set -q HYPRLAND_INSTANCE_SIGNATURE
    hyprctl setcursor $cursor_theme $cursor_size
end

echo "✅ Cursor set to $cursor_theme @ $cursor_size"
