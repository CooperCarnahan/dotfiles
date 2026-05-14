local programs = require("config.programs")

-- ──────────────────────────────────────────────────────────────────────────
-- Environment variables (formerly environment.conf)
-- ──────────────────────────────────────────────────────────────────────────
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_CURSOR_SIZE", "24")

-- ──────────────────────────────────────────────────────────────────────────
-- Pin workspace 1 (terminal) to the rightmost active monitor. Re-evaluates
-- on monitor add/remove so dock/undock swaps Just Work.
--
-- Why no monitor.layout_changed subscription: hl.workspace_rule() with
-- persistent=true mutates config, which triggers a reapply, which fires
-- monitor.layout_changed — feedback loop that re-modesets DP-10 dozens of
-- times in a row, spamming hyprdynamicmonitors notifications.
-- ──────────────────────────────────────────────────────────────────────────
local last_pinned_monitor
local function pin_ws1_to_rightmost()
	local rightmost
	for _, m in ipairs(hl.get_monitors() or {}) do
		if not rightmost or (m.x or 0) > (rightmost.x or 0) then
			rightmost = m
		end
	end
	if not rightmost or rightmost.name == last_pinned_monitor then
		return
	end
	last_pinned_monitor = rightmost.name
	hl.workspace_rule({ workspace = "1", monitor = rightmost.name, persistent = true })
	hl.dispatch(hl.dsp.workspace.move({ workspace = 1, monitor = rightmost.name }))
end
hl.on("monitor.added", pin_ws1_to_rightmost)
hl.on("monitor.removed", pin_ws1_to_rightmost)

-- ──────────────────────────────────────────────────────────────────────────
-- Startup commands
-- ──────────────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
	-- vicinae launcher daemon
	hl.exec_cmd("vicinae server")

	-- wallpaper
	hl.exec_cmd([[swaybg -o '*' -i /usr/share/wallpapers/cachyos-wallpapers/Skyscraper.png -m fill]])

	-- input method, notifications, network, polkit
	-- waybar is managed by waybar.service (graphical-session.target)
	hl.exec_cmd("fcitx5 -d &")
	hl.exec_cmd("swaync &")
	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")

	-- volume overlay (wob) FIFO
	hl.exec_cmd(
		[[bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &]]
	)

	pin_ws1_to_rightmost()

	-- workspace-pinned launches (new Lua API: rules table instead of [..] prefix)
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
