hl.config({
    -- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
    dwindle = {
        preserve_split = true,
    },

    -- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
    master = {
        new_status = "master",
    },

    ecosystem = {
        no_update_news   = true,
        no_donation_nag  = true,
    },

    misc = {
        force_default_wallpaper = 1,    -- hyprpaper draws the real wallpaper anyway
        disable_hyprland_logo   = true,

        middle_click_paste = false,

        -- Hide the terminal that spawned a graphical child until it exits
        enable_swallow = true,
        swallow_regex  = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",

        vrr = 3,
    },

    render = {
        direct_scanout = 2,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})
