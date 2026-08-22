-- Keybindings
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"
local launch  = LAUNCH_PREFIX

---------------------
---- APPLICATIONS ---
---------------------

hl.bind(mainMod .. " + Q",          hl.dsp.exec_cmd(launch .. TERMINAL))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launch .. FILE_MANAGER))
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launch .. BROWSER))
hl.bind(mainMod .. " + R",          hl.dsp.exec_cmd(launch .. MENU))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(launch .. MENU))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launch .. TERMINAL .. " -e btop"))

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

hl.bind(mainMod .. " + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())
hl.bind("ALT + Tab",            hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprctl kill")) -- click a window to force-kill it

-- Session
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(SCREEN_LOCK))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

-- Move focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))

-- Move the active window within the layout
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "d" }))

-- Move & resize with the mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Zoom the whole screen
local function zoom_by(delta)
    local current = hl.get_config("cursor:zoom_factor")
    local target  = math.max(1.0, math.min(3.0, current + delta))
    hl.config({ cursor = { zoom_factor = target } })
end

-- Binds match the unshifted keysym, so zoom in is SHIFT + Minus rather than
-- Plus: `Plus` never matches on a us layout (that key reports `equal`), and
-- SUPER + SHIFT + Equal is the laptop panel's "turn back on" below.
-- hl.bind takes keysyms only; a "code:82" style key silently binds nothing.
hl.bind(mainMod .. " + Minus",         function() zoom_by(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + SHIFT + Minus", function() zoom_by(0.3)  end, { repeating = true })
hl.bind(mainMod .. " + KP_Subtract",   function() zoom_by(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + KP_Add",        function() zoom_by(0.3)  end, { repeating = true })

------------------------------
---- WORKSPACES & MONITORS ---
------------------------------

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Turn the laptop panel off/on, e.g. when docked.
-- `hyprctl keyword` is a no-op under the Lua parser, so drive hl.monitor
-- directly. Specs merge into the monitor's current state, which means
-- `disabled` has to be set explicitly in both directions.
local function set_laptop_panel(disabled)
    local spec = {}

    for key, value in pairs(LAPTOP_PANEL) do
        spec[key] = value
    end

    spec.disabled = disabled
    hl.monitor(spec)
end

local function laptop_panel_is_on()
    return hl.get_monitor(LAPTOP_PANEL.output) ~= nil
end

hl.bind(mainMod .. " + Equal",         function() set_laptop_panel(laptop_panel_is_on()) end)
hl.bind(mainMod .. " + SHIFT + Equal", function() set_laptop_panel(false) end) -- always back on

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-------------------
---- UTILITIES ----
-------------------

-- Pick a colour from anywhere on screen into the clipboard
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a -n"))
