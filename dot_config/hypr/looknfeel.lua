-- Personal look'n'feel overrides and window rules.

-- Per-machine window rules: untracked, absent on machines that never create
-- it. See .chezmoiignore.
require("default.hypr.require_optional").module("hypr.local-looknfeel")

-- Toolkit scaling. Loaded after hypr/monitors.lua, so this wins over the
-- GDK_SCALE that Omarchy's monitors.lua template sets.
--
-- GDK_SCALE is a single global integer with no per-monitor form, and it cannot
-- express a fractional scale. Omarchy derives it by rounding the monitor scale
-- (omarchy-hyprland-monitor-scaling: `int(scale + 0.5)`), so a 1.5x display
-- gets 2 -- a 33% error that made 1Password render 2x inside a 1.5x window.
-- At 1, GTK4/Qt6/Chromium/Electron negotiate exact per-output scale with the
-- compositor via wp_fractional_scale_v1 instead, which is per-monitor and
-- fraction-aware. Leaving it unforced is the standard setup on Wayland.
--
-- Tracked in chezmoi so it survives `omarchy refresh hyprland`, which rewrites
-- every file in ~/.config/hypr from Omarchy's defaults.
hl.env("GDK_SCALE", "1")
