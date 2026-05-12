hl.config({
    cursor = {
        no_hardware_cursors = true,
    },

    input = {
        follow_mouse                = 2,
        float_switch_override_focus = 2,
        kb_options                  = "ctrl:nocaps",
        touchpad = {
            natural_scroll = true,
        },
    },

    gestures = {
        workspace_swipe_distance           = 250,
        workspace_swipe_min_speed_to_force = 15,
        workspace_swipe_create_new         = false,
    },

    binds = {
        allow_workspace_cycles            = true,
        workspace_back_and_forth          = true,
        workspace_center_on               = true,
        movefocus_cycles_fullscreen       = true,
        window_direction_monitor_fallback = true,
    },
})

-- 3-finger gestures (formerly gestures.conf).
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up",   action = "fullscreen" })
