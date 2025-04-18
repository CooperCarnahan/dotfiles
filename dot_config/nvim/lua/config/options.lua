-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.shell = "nu"
vim.cmd("abb u8 UINT8")
vim.cmd("abb u64 UINT64")
vim.cmd("abb u32 UINT32")
if vim.g.neovide then
  vim.o.guifont = "CaskaydiaCove Nerd Font:h14"
end

vim.g.zig_fmt_autosave = 0
