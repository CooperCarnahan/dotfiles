local wezterm = require("wezterm")

local M = {}
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

function M.apply(cfg)
	workspace_switcher.apply_to_config(cfg)

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
