local wezterm = require("wezterm")

local M = {}

function M.apply_workspace_switcher(cfg)
	local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
	workspace_switcher.apply_to_config(cfg)
	table.insert(cfg.keys, {
		key = "w",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	})
	table.insert(cfg.keys, {
		key = "W",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	})
end

function M.apply_tabline(cfg)
	local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
	tabline.setup({
		options = {
			icons_enabled = true,
			theme = "Tokyo Night",
			tabs_enabled = true,
			theme_overrides = {
				normal_mode = {
					b = { bg = "#3b4261" },
				},
				copy_mode = {
					b = { bg = "#3b4261" },
				},
				search_mode = {
					b = { bg = "#3b4261" },
				},
				window_mode = {
					b = { bg = "#3b4261" },
				},
				tab = {
					inactive = { fg = "#363d59" },
					active = { fg = "#a9b1d6" },
				},
			},
			section_separators = {
				left = wezterm.nerdfonts.ple_right_half_circle_thick,
				right = wezterm.nerdfonts.ple_left_half_circle_thick,
			},
			component_separators = {
				left = wezterm.nerdfonts.ple_right_half_circle_thick,
				right = wezterm.nerdfonts.ple_right_half_circle_thick,
			},
			tab_separators = {
				left = "",
				right = "",
			},
		},
		sections = {
			tabline_a = { "mode" },
			tabline_b = { "workspace" },
			tabline_c = { " " },
			tab_active = {
				"index",
				{ "parent", padding = 0 },
				"/",
				{ "cwd", padding = { left = 0, right = 1 } },
				{ "zoomed", padding = 0 },
			},
			tab_inactive = {
				"index",
				{ "parent", padding = 0 },
				"/",
				{ "cwd", padding = { left = 0, right = 1 } },
				{ "zoomed", padding = 0 },
			},
			tabline_x = {},
			tabline_y = { "battery" },
			tabline_z = { "hostname" },
		},
		extensions = {},
	})
	tabline.apply_to_config(cfg)
end

function M.apply_smart_splits(cfg)
	local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
	smart_splits.apply_to_config(cfg, {
		-- the default config is here, if you'd like to use the default keys,
		-- you can omit this configuration table parameter and just use
		-- smart_splits.apply_to_config(config)
		-- if you want to use separate direction keys for move vs. resize, you
		-- can also do this:
		direction_keys = {
			move = { "h", "j", "k", "l" },
			resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
		},
		-- modifier keys to combine with direction_keys
		modifiers = {
			move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
			resize = "CTRL", -- modifier to use for pane resize, e.g. ctrl+alt+h to resize to the left
		},
		-- log level to use: info, warn, error
		log_level = "info",
	})
end

return M
