-- Personal look'n'feel overrides and window rules.
--
-- Omarchy's require list has no `windowrules` entry -- hyprland.lua loads only
-- monitors / input / bindings / looknfeel / autostart -- so window rules live
-- here.

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
