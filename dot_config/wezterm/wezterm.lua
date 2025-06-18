-- ~/.config/wezterm/wezterm.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Load core configuration settings
require("config").apply(config)

-- Load plugin definitions and apply them
require("plugins").apply(config)

-- Load keymaps
require("keymaps").apply(config)

-- Load event handlers
require("events").setup()

return config
