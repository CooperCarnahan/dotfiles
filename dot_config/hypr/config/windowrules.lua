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
