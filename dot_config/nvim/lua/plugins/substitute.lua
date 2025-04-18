local M = {
  "gbprod/substitute.nvim",
  event = "VeryLazy",
}

function M.config()
  require("substitute").setup()
  vim.keymap.set("n", "r", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
  vim.keymap.set("n", "rr", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
  vim.keymap.set("n", "R", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
  vim.keymap.set("x", "r", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
end

return M
