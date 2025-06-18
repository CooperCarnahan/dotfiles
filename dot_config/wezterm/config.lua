local M = {}

function M.apply(cfg)
	cfg.default_prog = { "nu" }
	cfg.color_scheme = "Tokyo Night"
	cfg.switch_to_last_active_tab_when_closing_tab = true
	cfg.mux_enable_ssh_agent = false
	cfg.hide_tab_bar_if_only_one_tab = false
	cfg.tab_bar_at_bottom = false
	cfg.use_fancy_tab_bar = false
	cfg.window_decorations = "RESIZE"
end

return M
