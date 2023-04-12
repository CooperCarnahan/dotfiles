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
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

--"""""""""""""""""""""""""""
-- FloatTerm
--"""""""""""""""""""""""""""
vim.keymap.set("n", "<leader>lg", ":FloatermNew --cwd=<buffer> lazygit<cr>", { desc = "LazyGit" })
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-----------------------------
-- Telescope --
-----------------------------
vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy find in buffer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope frecency<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<C-c>", "<cmd>Telescope git_bcommits<cr>", { desc = "Git buffer commits" })
vim.keymap.set("n", "<C-s>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "LSP document symbols" })
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>km", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
-- vim.keymap.set("n", "<leader>g", "<cmd>Telescope grep_string<cr>", { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>of", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

local leader = {
  ["f"] = {
    name = "find",
    b = {
      "<cmd>Telescope file_browser<cr>",
      "File browser"
    },
    f = {
      "<cmd>Telescope frecency<cr>",
      "Frecent files"
    },
    j = {
      "<cmd>Telescope jumplist<cr>",
      "Jumplist"
    },
    s = {
      "<cmd>Telescope lsp_workspace_symbols<cr>",
      "LSP workspace symbols",
    },
    t = {
      "<cmd>Telescope tagstack<cr>",
      "Tagstack",
    },
    y = {
      "<cmd>Telescope yank_history<cr>",
      "Yank History",
    },
  },
  ["s"] = {
    name = "swap",
  },
  ["t"] = {
    name = "toggle",
    f = {
      require("plugins.lsp.formatting").toggle,
      "Format on save",
    },
    t = {
      [[<cmd>Twilight<cr>]], "Twilight"
    },
    b = {
      [[<cmd>BlamerToggle<cr>]], "GitBlamer"
    }
  },
  ["w"] = {
    name = "window",
    s = {
      [[<cmd>split<cr>]], "Split Horizontal"
    },
    v = {
      [[<cmd>vsplit<cr>]], "Split Vertical"
    }
  },
}

wk.register(leader, { prefix = "<leader>" })
