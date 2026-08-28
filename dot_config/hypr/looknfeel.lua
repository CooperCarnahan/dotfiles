-- Personal look'n'feel overrides and window rules.
--
-- Omarchy's require list has no `windowrules` entry -- hyprland.lua loads only
-- monitors / input / bindings / looknfeel / autostart -- so ported window rules
-- live here.
--
-- Call shape verified against /usr/share/omarchy/default/hypr/windows.lua and
-- default/hypr/apps/*.lua: it is `o.window(match, rules)`, where match is either
-- a string regex or a table of match keys, and rules is a table. The
-- pre-Omarchy `hl.window_rule({ name = ..., match = ..., ... })` form is not
-- used by Omarchy.

-- Quake-style dropdown terminal: ghostty launched with --title=quake-terminal
-- is pinned to the special:quake workspace, floats, and uses the popin
-- animation. In Lua "\\." is a literal backslash-dot, i.e. a regex-escaped dot.
local quake_terminal = {
	class = "^(com\\.mitchellh\\.ghostty)$",
	title = "^(quake-terminal)$",
}

o.window(quake_terminal, { workspace = "special:quake silent", float = true })
o.window(quake_terminal, { animation = "popin" })

-- Teams for Linux is launched via flatpak. An exec-time
-- `{ workspace = "special:teams silent" }` hint is PID-tracked and misses on a
-- cold start, because flatpak spawns the real process under a separate tree, so
-- the first launch lands on the active workspace. This persistent class rule
-- pins the window regardless of launch timing -- and, unlike the quake rules
-- above, it does not depend on any particular binding having launched it.
o.window({ class = "^(com\\.github\\.IsmaelMartinez\\.teams_for_linux)$" }, {
	workspace = "special:teams silent",
})

-- Nothing from the pre-Omarchy config/appearance.lua is ported, deliberately:
--
--   * every colour in it came from config/colors.lua, a hardcoded CachyOS
--     palette. Omarchy themes borders, groupbars and the splash centrally and
--     restyles them on `omarchy theme set`, so pinning colours here would
--     freeze one theme and desync the rest of the desktop.
--   * gaps / border_size / rounding / blur / animation curves are Omarchy
--     look'n'feel defaults with no complaint recorded against them.
--   * xwayland.force_zero_scaling existed for winboat's FreeRDP windows;
--     winboat-bin is cut (C3) and was never installed.
--   * misc.font_family = "Fira Sans" fights `omarchy font set`, which is the
--     sanctioned surface for fonts and keeps the terminal, shell and GTK apps
--     in sync.
--
-- The commented examples in Omarchy's shipped looknfeel.lua stub show the
-- supported call shapes if any of this is ever wanted back.
