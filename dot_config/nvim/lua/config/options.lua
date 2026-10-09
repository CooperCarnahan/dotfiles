-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.fn.has("win32") == 1 then
	vim.opt.shell = "cmd"
else
	vim.opt.shell = "bash"
end

vim.cmd("abb u8 UINT8")
vim.cmd("abb u64 UINT64")
vim.cmd("abb u32 UINT32")
if vim.g.neovide then
	vim.o.guifont = "CaskaydiaCove Nerd Font:h14"
end

vim.g.zig_fmt_autosave = 0

-- enable project-specific setting overrides
vim.opt.exrc = true

-- Headless Linux (e.g. ubuntu LXC over SSH/herdr): use OSC 52 for copy only.
-- Reading the clipboard via OSC 52 asks the terminal and waits up to 10s for an
-- answer that, through herdr, never comes (yanky's sync_with_ring does this on
-- every focus change).
if vim.fn.has("linux") == 1 and not (vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY) then
	local osc52 = require("vim.ui.clipboard.osc52")
	local function paste()
		return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
	end
	vim.g.clipboard = {
		name = "OSC 52 (copy only)",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = paste, ["*"] = paste },
	}
end
