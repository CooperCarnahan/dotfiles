local M = {
  'nvim-telescope/telescope.nvim',
  cmd = "Telescope",
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-frecency.nvim',
    { "kkharji/sqlite.lua" }
  },
  pin = true, -- Leave out of updates for now
  version = '*', -- Latest stable has bug right now
}

-- Keybinds
-- local function set_keybinds(keybind, cmd, desc)
--   desc = "[Telescope] " .. desc
--   cmd = "<cmd>Telescope " .. cmd .. "<cr>"
--   local opts = { noremap = true, silent = true, desc = desc }
--   vim.api.nvim_set_keymap("n", keybind, cmd, opts)
-- end

function M.config()
  require("telescope").setup({
    defaults = {
      file_ignore_patterns = { "Release/.*", "Debug/.*", "build/.*" },
    },
    pickers = {
      -- Your special builtin config goes in here
      buffers = {
        sort_lastused = false,
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
    extensions = {
      file_browser = {
        hijack_netrw = true,
      },
      frecency = {
        show_unindexed = true,
        default_workspace = "CWD",
        ignore_patterns = { "*.git/*", "*/tmp/*" },
        disable_devicons = false,
      },
    },
  })

  require "telescope".load_extension("frecency")
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("file_browser")
end

return M
