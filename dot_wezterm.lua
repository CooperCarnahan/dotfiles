-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

wezterm.on("switch-to-left", function(window, pane)
	local tab = window:mux_window():active_tab()

	if tab:get_pane_direction("Left") ~= nil then
		window:perform_action(wezterm.action.ActivatePaneDirection("Left"), pane)
	else
		window:perform_action(wezterm.action.ActivateTabRelative(-1), pane)
	end
end)

wezterm.on("switch-to-right", function(window, pane)
	local tab = window:mux_window():active_tab()

	if tab:get_pane_direction("Right") ~= nil then
		window:perform_action(wezterm.action.ActivatePaneDirection("Right"), pane)
	else
		window:perform_action(wezterm.action.ActivateTabRelative(1), pane)
	end
end)

local config = wezterm.config_builder()

config.default_prog = { "nu" }
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "Tokyo Night"
config.tab_bar_at_bottom = true
config.switch_to_last_active_tab_when_closing_tab = true

-- keys
config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}
config.keys = {
	-- CTRL + (h,j,k,l) to move between panes
	{
		key = "h",
		mods = "CTRL",
		-- action = act.ActivatePaneDirection("Left"),
		action = wezterm.action.EmitEvent("switch-to-left"),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL",
		-- action = act.ActivatePaneDirection("Right"),
		action = wezterm.action.EmitEvent("switch-to-right"),
	},
	{
		-- Vertical split
		key = "h",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Left",
			size = { Percent = 50 },
		}),
	},
	{
		-- Horizontal split
		key = "j",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		-- Horizontal split
		key = "k",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Up",
			size = { Percent = 50 },
		}),
	},
	{
		-- Vertical split
		key = "l",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		-- Vertical split
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		-- Horizontal split
		key = "-",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "i",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Next"),
	},
	{
		key = "o",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Prev"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{ key = "LeftArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "UpArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },

	-- tab stuff
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	{
		key = "f",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
}

return config
