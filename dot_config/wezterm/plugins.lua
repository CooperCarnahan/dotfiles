local wezterm = require("wezterm")

local M = {}
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

function M.apply(cfg)
	workspace_switcher.apply_to_config(cfg)
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

	-- Append plugin-specific keybindings directly to cfg.keys
	-- It's crucial that cfg.keys has already been initialized as a table
	table.insert(cfg.keys, {
		key = "s",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	})
	table.insert(cfg.keys, {
		key = "S",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	})
end

return M
