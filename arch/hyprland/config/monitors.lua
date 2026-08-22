-- Monitors: https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Run `hyprctl monitors` to find output names and descriptions.
-- Anything not listed here falls back to Hyprland's preferred/auto defaults.

-- Laptop built-in display (spec lives in variables.lua; binds.lua toggles it)
hl.monitor(LAPTOP_PANEL)

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
