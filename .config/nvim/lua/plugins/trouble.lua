local M = {
  'folke/trouble.nvim',
  cmd = { "TroubleToggle", "Trouble" },
}

function M.config()
  require("trouble").setup({})

  -- Lua
  vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
    { desc = "TroubleToggle", silent = true, noremap = true }
  )
  vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
    { desc = "Workspace Diagnostics", silent = true, noremap = true }
  )
  vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
    { desc = "Document Diagnostics", silent = true, noremap = true }
  )
  vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
    { desc = "Loclist", silent = true, noremap = true }
  )
  vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
    { desc = "QuickFix", silent = true, noremap = true }
  )
  vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<cr>",
    { desc = "LSP Refs", silent = true, noremap = true }
  )
end

return M
