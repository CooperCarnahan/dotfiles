-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remap <Esc> keys
vim.keymap.set("i", "jk", "<Esc>")

-- Edit movement keys
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")

vim.keymap.set("n", "<leader>wh", "<cmd>split<cr>")
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>")

vim.keymap.set("n", "<leader><tab>n", "<cmd>tabn<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabp<cr>", { desc = "Previous Tab" })

-- Commandline mode
vim.keymap.set("c", "<c-a>", "<Home>")
vim.keymap.set("c", "<c-e>", "<End>")

vim.keymap.set("n", "<leader>ghq" ,"<cmd>Gitsigns setqflist<cr>")
vim.keymap.set('n', '<leader>ghQ', function() require("gitsigns").setqflist('all') end)
