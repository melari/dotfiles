-- Input
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        -- 2 = focus follows mouse, but clicking is still required to raise
        follow_mouse = 2,

        sensitivity   = 0, -- -1.0 - 1.0, 0 means no modification
        accel_profile = "adaptive",

        touchpad = {
            natural_scroll = false,
            scroll_factor  = 0.15,
        },
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Gestures/
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
