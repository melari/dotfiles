-- Monitors: https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Run `hyprctl monitors` to find output names and descriptions.
-- Anything not listed here falls back to Hyprland's preferred/auto defaults.

-- Laptop built-in display
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.2,
})

-- LG desk monitor
hl.monitor({
    output   = "DP-3",
    mode     = "2560x1440@60",
    position = "auto",
    scale    = 1.0,
})

-- Living room Samsung TV
hl.monitor({
    output   = "desc:Samsung Electric Company SAMSUNG 0x01000600",
    mode     = "preferred",
    position = "auto",
    scale    = 1.0,
})
