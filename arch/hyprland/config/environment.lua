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
-- Adwaita is XCursor-only (no hyprcursors/ directory), so Hyprland's hyprcursor
-- lookup misses and falls back to XCursor. Both vars are set anyway so that
-- swapping in a theme that ships both is a two-line change.
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")
