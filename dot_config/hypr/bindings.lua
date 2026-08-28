-- Personal keybinding overrides.
--
-- Omarchy's hyprland.lua require()s this file AFTER its own defaults, so
-- anything here wins. Scope is deliberately narrow: hjkl focus, plus a shorter
-- chord for 1Password.

-- Omarchy already binds SUPER + J/K/L, so each must be unbound before it can be
-- rebound.
hl.unbind("SUPER + H") -- just in case
hl.unbind("SUPER + K") -- was: Keybindings menu (bindings/utilities.lua:10)
hl.unbind("SUPER + J") -- was: Toggle window split (bindings/tiling.lua:4)
hl.unbind("SUPER + L") -- was: Toggle workspace layout (bindings/tiling.lua:13)

-- Direction values are SINGLE LETTERS. Omarchy's own arrow-key bindings use
-- hl.dsp.focus({ direction = "l"/"r"/"u"/"d" }) at bindings/tiling.lua:16-19;
-- "left"/"right" are not accepted.
for _, f in ipairs({
	{ key = "H", dir = "l", label = "left" },
	{ key = "J", dir = "d", label = "down" },
	{ key = "K", dir = "u", label = "up" },
	{ key = "L", dir = "r", label = "right" },
}) do
	o.bind("SUPER + " .. f.key, "Focus " .. f.label, hl.dsp.focus({ direction = f.dir }))
end

-- 1Password on a shorter chord. SUPER + P is NOT free -- Omarchy binds it to
-- "Pseudo window" (bindings/tiling.lua:5) -- so it must be unbound first.
hl.unbind("SUPER + P") -- was: Pseudo window (bindings/tiling.lua:5)
o.bind("SUPER + P", "Passwords", { omarchy = "1password" })
