local programs = require("config.programs")

local mod = "SUPER"

-- ──────────────────────────────────────────────────────────────────────────
-- Application launching
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(
	mod .. " + RETURN",
	hl.dsp.exec_cmd(programs.terminal),
	{ description = "Opens your preferred terminal emulator" }
)
hl.bind(mod .. " + E", hl.dsp.exec_cmd(programs.filemanager), { description = "Opens your preferred filemanager" })
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd(programs.applauncher), { description = "Runs your application launcher" })

-- ──────────────────────────────────────────────────────────────────────────
-- Window actions (close / float / fullscreen / pin / session exit)
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Closes (not kills) the current window" })
hl.bind(
	mod .. " + SHIFT + M",
	hl.dsp.exec_cmd([[loginctl terminate-user ""]]),
	{ description = "Exits Hyprland by terminating the user session" }
)
hl.bind(
	mod .. " + V",
	hl.dsp.window.float({ action = "toggle" }),
	{ description = "Toggles current window between floating and tiling" }
)
hl.bind(mod .. " + F", hl.dsp.window.fullscreen(), { description = "Toggles current window fullscreen mode" })
hl.bind(mod .. " + Y", hl.dsp.window.pin(), { description = "Pins the current window (shows on all workspaces)" })

-- ──────────────────────────────────────────────────────────────────────────
-- Screenshots
-- ──────────────────────────────────────────────────────────────────────────
hl.bind("Print", hl.dsp.exec_cmd(programs.shot_region), { description = "Creates a screenshot of an area" })
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(programs.shot_region), { description = "Creates a screenshot of an area" })
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd(programs.shot_window),
	{ description = "Creates a screenshot of the active window" }
)
hl.bind(
	"ALT + Print",
	hl.dsp.exec_cmd(programs.shot_screen),
	{ description = "Creates a screenshot of the active display" }
)

-- ──────────────────────────────────────────────────────────────────────────
-- Window grouping
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(
	mod .. " + K",
	hl.dsp.group.toggle(),
	{ description = "Toggles current window group mode (ungroup all related)" }
)
hl.bind(mod .. " + Tab", hl.dsp.group.next(), { description = "Switches to the next window in the group" })

-- ──────────────────────────────────────────────────────────────────────────
-- Gaps toggle
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + G", function()
	hl.config({ general = { gaps_out = 5, gaps_in = 3 } })
end, { description = "Set CachyOS default gaps" })
hl.bind(mod .. " + G", function()
	hl.config({ general = { gaps_out = 0, gaps_in = 0 } })
end, { description = "Remove gaps between windows" })

-- ──────────────────────────────────────────────────────────────────────────
-- Layout toggle (dwindle ↔ scrolling)
-- The non-legacy (Lua) config parser rejects `hyprctl keyword`, so set the
-- value through hl.config from inside the bind callback instead.
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(mod .. " + S", function()
	local current = hl.get_config("general:layout")
	local target = current == "scrolling" and "dwindle" or "scrolling"
	hl.config({ general = { layout = target } })
end, { description = "Toggle layout between dwindle and scrolling" })

-- ──────────────────────────────────────────────────────────────────────────
-- Volume (locked + repeating; routes to the wob FIFO for the OSD)
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(
		[[pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{if($1>100) system("pactl set-sink-volume @DEFAULT_SINK@ 100%")}' && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{print $1}' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(
		[[pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{print $1}' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(
		[[amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob]]
	),
	{ locked = true, repeating = true }
)

-- ──────────────────────────────────────────────────────────────────────────
-- Playback
-- ──────────────────────────────────────────────────────────────────────────
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Toggles play/pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })

-- ──────────────────────────────────────────────────────────────────────────
-- Brightness, lock, waybar reload
-- ──────────────────────────────────────────────────────────────────────────
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true, repeating = true })
hl.bind(
	mod .. " + CTRL + L",
	hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/lock"),
	{ description = "Lock the screen" }
)
hl.bind(mod .. " + CTRL + R", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"), { description = "Reload/restart Waybar" })
hl.bind(mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"), { description = "Toggle notification center" })

-- ──────────────────────────────────────────────────────────────────────────
-- Mouse: drag/resize windows
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ──────────────────────────────────────────────────────────────────────────
-- Focus movement (arrows + hjkl)
-- ──────────────────────────────────────────────────────────────────────────
local focusDirs = {
	{ key = "left", dir = "left", desc = "Move focus to the left" },
	{ key = "right", dir = "right", desc = "Move focus to the right" },
	{ key = "up", dir = "up", desc = "Move focus upwards" },
	{ key = "down", dir = "down", desc = "Move focus downwards" },
	{ key = "h", dir = "left", desc = "Move focus to the left" },
	{ key = "l", dir = "right", desc = "Move focus to the right" },
	{ key = "k", dir = "up", desc = "Move focus upwards" },
	{ key = "j", dir = "down", desc = "Move focus downwards" },
}
for _, f in ipairs(focusDirs) do
	hl.bind(mod .. " + " .. f.key, hl.dsp.focus({ direction = f.dir }), { description = f.desc })
end

-- ──────────────────────────────────────────────────────────────────────────
-- Resize submap (SUPER+R enters, Escape exits)
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(mod .. " + R", hl.dsp.submap("resize"), { description = "Activates window resizing mode" })

hl.define_submap("resize", function()
	local resizes = {
		{ key = "right", x = 15, y = 0, desc = "Resize to the right (resizing mode)" },
		{ key = "left", x = -15, y = 0, desc = "Resize to the left (resizing mode)" },
		{ key = "up", x = 0, y = -15, desc = "Resize upwards (resizing mode)" },
		{ key = "down", x = 0, y = 15, desc = "Resize downwards (resizing mode)" },
		{ key = "l", x = 15, y = 0, desc = "Resize to the right (resizing mode)" },
		{ key = "h", x = -15, y = 0, desc = "Resize to the left (resizing mode)" },
		{ key = "k", x = 0, y = -15, desc = "Resize upwards (resizing mode)" },
		{ key = "j", x = 0, y = 15, desc = "Resize downwards (resizing mode)" },
	}
	for _, r in ipairs(resizes) do
		hl.bind(r.key, hl.dsp.window.resize({ x = r.x, y = r.y, relative = true }), { description = r.desc })
	end
	hl.bind("escape", hl.dsp.submap("reset"), { description = "Ends window resizing mode" })
end)

-- ──────────────────────────────────────────────────────────────────────────
-- Quick keyboard resize (outside the submap; uses SUPER+CTRL+SHIFT to avoid
-- conflict with text-editor word selection on CTRL+SHIFT alone)
-- ──────────────────────────────────────────────────────────────────────────
local quickResizes = {
	{ key = "right", x = 15, y = 0, desc = "Resize to the right" },
	{ key = "left", x = -15, y = 0, desc = "Resize to the left" },
	{ key = "up", x = 0, y = -15, desc = "Resize upwards" },
	{ key = "down", x = 0, y = 15, desc = "Resize downwards" },
	{ key = "l", x = 15, y = 0, desc = "Resize to the right" },
	{ key = "h", x = -15, y = 0, desc = "Resize to the left" },
	{ key = "k", x = 0, y = -15, desc = "Resize upwards" },
	{ key = "j", x = 0, y = 15, desc = "Resize downwards" },
}
for _, r in ipairs(quickResizes) do
	hl.bind(
		mod .. " + CTRL + SHIFT + " .. r.key,
		hl.dsp.window.resize({ x = r.x, y = r.y, relative = true }),
		{ description = r.desc }
	)
end

-- ──────────────────────────────────────────────────────────────────────────
-- Workspace 1..10: switch, move active, move silent
-- ──────────────────────────────────────────────────────────────────────────
for i = 1, 10 do
	local key = i % 10 -- workspace 10 maps to key 0
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
	hl.bind(
		mod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window and switch to workspace " .. i }
	)
	-- "Silent" move: window goes to the workspace without changing focus.
	-- Use hyprctl dispatch directly because hl.dsp.window.move doesn't have a
	-- documented "silent" option in the Lua API.
	hl.bind(
		mod .. " + CTRL + " .. key,
		hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. i),
		{ description = "Move window silently to workspace " .. i }
	)
end

-- ──────────────────────────────────────────────────────────────────────────
-- Move current workspace to neighbouring monitor
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + Left", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l"))
hl.bind(mod .. " + SHIFT + h", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l"))
hl.bind(mod .. " + SHIFT + Right", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r"))
hl.bind(mod .. " + SHIFT + l", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r"))

-- ──────────────────────────────────────────────────────────────────────────
-- Workspace scrolling
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(
	mod .. " + PERIOD",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "Scroll through workspaces incrementally" }
)
hl.bind(
	mod .. " + SHIFT + L",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "Scroll through workspaces incrementally" }
)
hl.bind(
	mod .. " + COMMA",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "Scroll through workspaces decrementally" }
)
hl.bind(
	mod .. " + SHIFT + H",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "Scroll through workspaces decrementally" }
)
hl.bind(
	mod .. " + mouse_down",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "Scroll through workspaces incrementally" }
)
hl.bind(
	mod .. " + mouse_up",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "Scroll through workspaces decrementally" }
)
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "previous" }), { description = "Switch to the previous workspace" })

-- ──────────────────────────────────────────────────────────────────────────
-- Special workspaces (scratchpads / quake / 1Password)
-- ──────────────────────────────────────────────────────────────────────────
hl.bind(
	mod .. " + minus",
	hl.dsp.window.move({ workspace = "special" }),
	{ description = "Move active window to special workspace" }
)
hl.bind(
	mod .. " + equal",
	hl.dsp.workspace.toggle_special("special"),
	{ description = "Toggles the special workspace" }
)
hl.bind(
	mod .. " + F1",
	hl.dsp.workspace.toggle_special("scratchpad"),
	{ description = "Call special workspace scratchpad" }
)
hl.bind(
	mod .. " + ALT + SHIFT + F1",
	hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent special:scratchpad"),
	{ description = "Move active window to special workspace scratchpad" }
)
hl.bind(mod .. " + SLASH", hl.dsp.workspace.toggle_special("quake"), { description = "Toggle Quake Terminal" })

-- 1Password: toggle the special workspace if 1Password is already running,
-- otherwise launch + move it there + toggle.
hl.bind(
	mod .. " + P",
	hl.dsp.exec_cmd(
		[[hyprctl clients | grep -q "class: 1password" && hyprctl dispatch togglespecialworkspace 1password || (1password hyprctl dispatch movetoworkspacesilent special:1password,class:^1password$ && hyprctl dispatch togglespecialworkspace 1password)]]
	)
)
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("1password --quick-access --toggle"))

-- ──────────────────────────────────────────────────────────────────────────
-- Push-to-talk (handy). Press triggers, release triggers again (same signal).
-- ──────────────────────────────────────────────────────────────────────────
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("pkill -USR2 -n handy"), { description = "Start recording via handy" })
hl.bind(
	"ALT + SPACE",
	hl.dsp.exec_cmd("pkill -USR2 -n handy"),
	{ release = true, description = "Stop recording via handy" }
)

hl.bind("F2", hl.dsp.exec_cmd("pkill -USR2 -n handy"), { description = "Start recording via handy" })
hl.bind("F2", hl.dsp.exec_cmd("pkill -USR2 -n handy"), { release = true, description = "Stop recording via handy" })
