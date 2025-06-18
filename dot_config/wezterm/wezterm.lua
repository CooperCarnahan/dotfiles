-- ~/.config/wezterm/wezterm.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Load core configuration settings
require("config").apply(config)

-- Load keymaps
require("keymaps").apply(config)

-- Load plugin definitions and apply them
require("plugins").apply_workspace_switcher(config)
require("plugins").apply_tabline(config)
require("plugins").apply_smart_splits(config)

-- Load event handlers
require("events").setup()

return config
