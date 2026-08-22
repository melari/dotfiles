-- Programs and shared values referenced by the rest of the config.

-- uwsm puts each launched app in its own systemd scope. On a machine that
-- doesn't use uwsm, set this to "".
LAUNCH_PREFIX = "uwsm app -- "

TERMINAL     = "kitty"
FILE_MANAGER = "dolphin"
BROWSER      = "brave"
MENU         = "hyprlauncher"
SCREEN_LOCK  = "hyprlock"

-- Suspend the machine after this many seconds of inactivity.
IDLE_SUSPEND_SECONDS = 600

-- The built-in laptop panel. monitors.lua applies this spec and binds.lua
-- toggles it off/on, so both stay in sync.
LAPTOP_PANEL = {
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.2,
}
