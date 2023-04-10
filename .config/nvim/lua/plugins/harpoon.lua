local M = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
}


function M.config()
  vim.api.nvim_set_keymap('n', ']]', '<cmd>lua require("harpoon.ui").nav_next()<cr>', { desc = "Next mark" })
  vim.api.nvim_set_keymap('n', '[[', '<cmd>lua require("harpoon.ui").nav_prev()<cr>', { desc = "Previous mark" })
  vim.api.nvim_set_keymap('n', '<leader>ma', '<cmd>lua require("harpoon.mark").add_file()<cr>',
    { desc = "Add file mark" })
  vim.api.nvim_set_keymap('n', '<c-b>', '<cmd>Telescope harpoon marks<cr>',
    { desc = "Show marks" })
end

return M
