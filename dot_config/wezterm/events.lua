local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local M = {}

-- Helper function for get_current_working_dir
local function get_current_working_dir(tab)
	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = "" }
	local HOME_DIR = string.format("file://%s", wezterm.home_dir)

	return current_dir.file_path == HOME_DIR and "." or string.gsub(current_dir.file_path, "(.*[/\\])(.*)", "%2")
end

function M.setup()
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local has_unseen_output = false
		if not tab.is_active then
			for _, pane in ipairs(tab.panes) do
				if pane.has_unseen_output then
					has_unseen_output = true
					break
				end
			end
		end

		local cwd = wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Text = get_current_working_dir(tab) },
		})

		local title = string.format(" [%s] %s", tab.tab_index + 1, cwd)

		if has_unseen_output then
			return {
				{ Foreground = { Color = "#8866bb" } },
				{ Text = title },
			}
		end

		return {
			{ Text = title },
		}
	end)

	wezterm.on("switch-to-left", function(window, pane)
		local tab = window:mux_window():active_tab()

		if tab:get_pane_direction("Left") ~= nil then
			window:perform_action(act.ActivatePaneDirection("Left"), pane)
		else
			window:perform_action(act.ActivateTabRelative(-1), pane)
		end
	end)

	wezterm.on("switch-to-right", function(window, pane)
		local tab = window:mux_window():active_tab()

		if tab:get_pane_direction("Right") ~= nil then
			window:perform_action(act.ActivatePaneDirection("Right"), pane)
		else
			window:perform_action(act.ActivateTabRelative(1), pane)
		end
	end)

	wezterm.on("gui-startup", function(cmd)
		local dotfiles_path = wezterm.home_dir .. "/.config/nvim"
		local chezmoi_path = wezterm.home_dir .. "/.local/share/chezmoi"
		local wezterm_config_path = wezterm.home_dir .. "/.config/wezterm/wezterm.lua" -- Updated path for config

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
			cwd = wezterm.home_dir,
		})
		pane_wezterm_config:send_text("nvim " .. wezterm_config_path .. "\r\n")
		tab_wezterm_config:set_title("wezterm.lua")
	end)
end

return M
