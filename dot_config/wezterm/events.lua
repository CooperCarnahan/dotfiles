local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local M = {}

function M.setup()
	wezterm.on("gui-startup", function(cmd)
		local dotfiles_path = wezterm.home_dir .. "/.config/nvim"
		local chezmoi_path = wezterm.home_dir .. "/.local/share/chezmoi"
		local wezterm_config_path = wezterm.home_dir .. "/.config/wezterm" -- Updated path for config

		-- Spawn the first window for nvim dotfiles
		local tab_nvim, pane_nvim, window = mux.spawn_window({
			workspace = "dotfiles",
			cwd = dotfiles_path,
			args = cmd,
		})
		pane_nvim:send_text("nvim\r\n")
		tab_nvim:set_title("nvim")

		-- Add another tab for chezmoi
		local tab_chezmoi, pane_chezmoi = window:spawn_tab({
			cwd = chezmoi_path,
		})
		pane_chezmoi:send_text("nvim\r\n")
		tab_chezmoi:set_title("chezmoi")

		-- Add a tab for the wezterm lua config
		local tab_wezterm_config, pane_wezterm_config = window:spawn_tab({
			cwd = wezterm_config_path,
		})
		pane_wezterm_config:send_text("nvim " .. "\r\n")
		tab_wezterm_config:set_title("wezterm.lua")
	end)
end

return M
