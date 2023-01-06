return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    -- cmd = TODO
    event = "VeryLazy",
    config = function()
      -- Remaps for the refactoring operations currently offered by the plugin
      vim.api.nvim_set_keymap("v", "<leader>re",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        { desc = "Extract Function", noremap = true, silent = true, expr = false })
      vim.api.nvim_set_keymap("v", "<leader>rf",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
        { desc = "Extract Function to File", noremap = true, silent = true, expr = false })
      vim.api.nvim_set_keymap("v", "<leader>rv",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
        { desc = "Extract Variable", noremap = true, silent = true, expr = false })
      vim.api.nvim_set_keymap("v", "<leader>ri",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { desc = "Inline Variable", noremap = true, silent = true, expr = false })

      -- Extract block doesn't need visual mode
      vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
        { desc = "Extract Block", noremap = true, silent = true, expr = false })
      vim.api.nvim_set_keymap("n", "<leader>rbf",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
        { desc = "Extract Block To File", noremap = true, silent = true, expr = false })

      -- Inline variable can also pick up the identifier currently under the cursor without visual mode
      vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { desc = "Inline Variable", noremap = true, silent = true, expr = false })
    end,
  },
}
