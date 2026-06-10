-- Quake-style dropdown terminal: ghostty launched with --title=quake-terminal
-- is pinned to the special:quake workspace, floats, and uses the popin
-- animation when it appears.
local quakeMatch = {
	class = "^(com\\.mitchellh\\.ghostty)$",
	title = "^(quake-terminal)$",
}

hl.window_rule({
	name = "quake-workspace",
	match = quakeMatch,
	workspace = "special:quake silent",
})

hl.window_rule({
	name = "quake-float",
	match = quakeMatch,
	float = true,
})

hl.window_rule({
	name = "quake-animation",
	match = quakeMatch,
	animation = "popin",
})

-- Teams for Linux is launched via flatpak from the mod+T binding. The exec-time
-- `{ workspace = "special:teams silent" }` hint is PID-tracked and misses on a
-- cold start (flatpak spawns the real process under a separate tree), so the
-- first launch lands on the active workspace. This persistent class rule pins
-- the window regardless of launch timing.
hl.window_rule({
	name = "teams-workspace",
	match = { class = "^(com\\.github\\.IsmaelMartinez\\.teams_for_linux)$" },
	workspace = "special:teams silent",
})
