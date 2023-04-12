local M = {
  'tpope/vim-fugitive',
  event = "VeryLazy"
}

-- setup Fugitive
function M.config()
  vim.keymap.set("n", "<C-g>", "<cmd>Git<cr>", { desc = "Fugitive" })
end

return M
