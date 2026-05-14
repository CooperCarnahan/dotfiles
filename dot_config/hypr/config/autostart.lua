local programs = require("config.programs")

-- ──────────────────────────────────────────────────────────────────────────
-- Environment variables (formerly environment.conf)
-- ──────────────────────────────────────────────────────────────────────────
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_CURSOR_SIZE", "24")

-- ──────────────────────────────────────────────────────────────────────────
-- Startup commands
-- ──────────────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
	-- vicinae launcher daemon
	hl.exec_cmd("vicinae server")

	-- input method, notifications, network, polkit
	-- waybar is managed by waybar.service (graphical-session.target)
	-- wallpaper is managed by hyprpaper.service
	hl.exec_cmd("fcitx5 -d &")
	hl.exec_cmd("swaync &")
	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")

	-- volume overlay (wob) FIFO
	hl.exec_cmd(
		[[bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &]]
	)

	-- workspace-pinned launches (new Lua API: rules table instead of [..] prefix)
	-- workspace_rule() bindings live in hyprdynamicmonitors templates per profile.
	hl.exec_cmd(programs.terminal, { workspace = "1" })
	hl.exec_cmd(programs.browser, { workspace = "2 silent" })
	hl.exec_cmd("ghostty --title=quake-terminal", { workspace = "special:quake silent" })
	hl.exec_cmd("1password --silent", { workspace = "special:1password silent", no_initial_focus = true })

	-- environment propagation for dbus / systemd user services
	hl.exec_cmd("systemctl --user import-environment &")
	hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null &")
	hl.exec_cmd("dbus-update-activation-environment --systemd &")

	-- idle handler
	hl.exec_cmd(programs.idlehandler)
end)
