local wezterm = require("wezterm")
local config = {}

config.font = wezterm.font("Caskaydia Cove")
config.font_size = 13.0
config.color_scheme = "Catppuccin Mocha"

config.hide_tab_bar_if_only_one_tab = true

-- config.enable_kitty_keyboard = true
-- config.enable_csi_u_key_encoding = false
--
-- config.use_ime = false
config.native_macos_fullscreen_mode = true

return config
