-- Hyprland configuration.
-- Docs: https://wiki.hypr.land/Configuring/Start/
-- API stubs for editor completion: /usr/share/hypr/stubs/hl.meta.lua
--
-- `variables` must come first; the other modules read the globals it defines.

require("config.variables")
require("config.environment")
require("config.monitors")
require("config.autostart")
require("config.decorations")
require("config.animations")
require("config.inputs")
require("config.binds")
require("config.misc")
require("config.windowrules")
require("config.workspaces")
