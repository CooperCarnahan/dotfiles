vim.api.nvim_buf_set_keymap(0, "n", "<leader>cb", "<cmd>CMakeBuild<CR>", { desc = "CMakeBuild" })
vim.api.nvim_buf_set_keymap(0, "n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { desc = "CMakeGenerate" })
vim.api.nvim_buf_set_keymap(0, "n", "<leader>tc", "<cmd>CMakeOpen<CR>", { desc = "CMakeOpen" })
