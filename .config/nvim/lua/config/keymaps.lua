local wk = require("which-key")

vim.o.timeoutlen = 300

wk.setup({
  show_help = false,
  triggers = "auto",
  plugins = { spelling = true },
})

-- Remap <Esc> keys
vim.keymap.set("i", "jk", "<Esc>")

-- Edit movement keys
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

-- Yanking
vim.keymap.set("n", "Y", "y$")

-- Searching
-- n always searches forwards"
vim.keymap.set("n", "n", "(v:searchforward ? 'n' : 'N')", { expr = true })
vim.keymap.set("n", "N", "(v:searchforward ? 'N' : 'n')", { expr = true })

-- Jump to previous jump location and center
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")

-- Navigate splits using <Ctrl + j,k,l,h>
vim.keymap.set("n", "<leader>s", ":split<cr>")
vim.keymap.set("n", "<leader>v", ":vsplit<cr>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

--"""""""""""""""""""""""""""
-- EasyClip Keybinds
--"""""""""""""""""""""""""""
vim.keymap.set("n", "m", "<Plug>MoveMotionPlug")
vim.keymap.set("x", "m", "<Plug>MoveMotionPlug")
vim.keymap.set("x", "m", "<Plug>MoveMotionPlug")
vim.keymap.set("n", "mm", "<Plug>MoveMotionLinePlug")

--"""""""""""""""""""""""""""
-- FloatTerm
--"""""""""""""""""""""""""""
vim.keymap.set("n", "<leader>lg", ":FloatermNew --cwd=<buffer> lazygit<cr>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
--tvim.keymap.set <ESC> <C-\><C-n>

--"""""""""""""""""""""""""""
-- Fugitive
--"""""""""""""""""""""""""""
-- nvim.keymap.set <leader>gs :Git<cr>
-- nvim.keymap.set <leader>gh :diffget //2<cr>
-- nvim.keymap.set <leader>gl :diffget //3<cr>
-- nvim.keymap.set <leader>gd :Gdiffsplit!<cr>
-- nvim.keymap.set <leader>gc :G commit<cr>
-- nvim.keymap.set <leader>ga :Neoformat <bar> Gwrite<cr>
-- nvim.keymap.set <C-g>      :Git<cr>
-- nvim.keymap.set <leader>glog :Commits<cr>

local leader = {
  t = {
    name = "toggle",
    f = {
      require("plugins.lsp.formatting").toggle,
      "Format on save",
    },
  }
}

wk.register(leader, { prefix = "<leader>" })
