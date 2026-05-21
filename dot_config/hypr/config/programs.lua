return {
	terminal = "ghostty",
	browser = "zen-browser",
	filemanager = "yazi",
	-- Trialing noctalia launcher (2026-05-15). Revert to `vicinae toggle` if it doesn't fit.
	applauncher = "qs -c noctalia-shell ipc call launcher toggle",
	idlehandler = "systemctl --user restart hypridle.service",

	shot_region = "hyprshot -m region --clipboard-only",
	shot_window = "hyprshot -m window --clipboard-only",
	shot_screen = "hyprshot -m output --clipboard-only",
}
