-- Autostart: https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Make the session environment visible to systemd/dbus activated services.
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")

    -- Bar, wallpaper, notifications
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("mako")

    -- Authentication agent, tray applets, removable media
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("udiskie")

    -- Suspend when idle, then lock so the screen is locked on resume.
    hl.exec_cmd(string.format(
        "swayidle -w timeout %d 'systemctl suspend' timeout %d '%s'",
        IDLE_SUSPEND_SECONDS, IDLE_SUSPEND_SECONDS + 1, SCREEN_LOCK
    ))
end)
