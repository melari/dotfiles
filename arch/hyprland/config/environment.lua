-- Environment variables
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
--
-- Under uwsm these can also live in ~/.config/uwsm/env, but setting them here
-- keeps the config self-contained and works either way. Hyprland applies these
-- to its own process, so they win over ~/.config/uwsm/env.

-- Cursor theme. Adwaita is the upstream default, resolved via the
-- default-cursors package (/usr/share/icons/default -> Inherits=Adwaita).
-- CachyOS shipped Bibata-Modern-Ice on top of it; arch/setup_scripts/cursor.fish
-- undoes that and points GTK/Qt at whatever is set here.
--
-- Adwaita is XCursor-only (no hyprcursors/ directory), so hyprcursor cannot
-- honour HYPRCURSOR_THEME. It does NOT fall back to XCursor on its own: at
-- startup Hyprland builds its CHyprcursorManager with allowDefaultFallback
-- left at its default of true, and libhyprcursor then retries the lookup with
-- the theme name stripped, which returns the first theme with a manifest.hl
-- under ~/.local/share/icons or ~/.icons -- i.e. the Bibata-Modern-Ice copy
-- CachyOS vendored there. That load succeeds, so XCURSOR_THEME is ignored and
-- the compositor draws Bibata until something calls `hyprctl setcursor` (which
-- passes allowDefaultFallback = false, so it fails honestly and uses XCursor).
--
-- Turning hyprcursor off makes the XCursor path the one taken at startup, so
-- the theme below survives a reboot without a login-time `hyprctl setcursor`.
-- Drop this once the chosen theme ships hyprcursors/ of its own.
hl.config({
    cursor = {
        enable_hyprcursor = false,
    },
})

-- Both cursor vars are set anyway so that swapping in a theme that ships both
-- XCursor and hyprcursor data is a one-line change here plus one in
-- arch/setup_scripts/cursor.fish.
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")
