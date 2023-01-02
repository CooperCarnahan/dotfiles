local M = {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
}

local function project_files(opts)
  opts = opts or {} -- define here if you want to define something
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

-- Keybinds
local function set_keybinds(keybind, cmd, desc)
  desc = "[Telescope] " .. desc
  cmd = "<cmd>Telescope " .. cmd .. "<cr>"
  local opts = { noremap = true, silent = true, desc = desc }
  vim.api.nvim_set_keymap("n", keybind, cmd, opts)
end

function M.config()
  require("telescope").setup({
    defaults = {
      file_ignore_patterns = { "Release/.*", "Debug/.*", "build/.*" },
    },
    pickers = {
      -- Your special builtin config goes in here
      buffers = {
        sort_lastused = true,
        theme = "dropdown",
        previewer = false,
        mappings = {
          i = {
            ["<c-d>"] = require("telescope.actions").delete_buffer,
          },
          n = {
            ["<c-d>"] = require("telescope.actions").delete_buffer,
          },
        },
      },
    },
  })

  set_keybinds("<C-f>", "current_buffer_fuzzy_find", "Fuzzy find in current buffer")
  set_keybinds("<C-b>", "buffers", "Fuzzy select from open buffers")
  set_keybinds("<C-p>", "find_files", "Recursively fuzzy find files in cwd")
  set_keybinds("<C-c>", "git_commits", "Search git commits of current repo")
  set_keybinds("<C-s>", "lsp_dynamic_workspace_symbols", "Find LSP symbols in current workspace")
  set_keybinds("<C-t>", "current_buffer_tags", "Find tags in current buffer")
  set_keybinds("<C-g>", "live_grep", "Run interactive ripgrep session")
  set_keybinds("<leader>km", "keymaps", "Show keymaps")
  set_keybinds("<leader>g", "grep_string", "Search word under cursor")
  set_keybinds("<leader>of", "oldfiles", "Recent files")

  require("telescope").load_extension("fzf")
end

return M
