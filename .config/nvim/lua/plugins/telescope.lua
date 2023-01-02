local M = {
  'nvim-telescope/telescope.nvim',
  cmd = "Telescope",
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  pin = true, -- Leave out of updates for now
  version = '*', -- Latest stable has bug right now
}

local function project_files(opts)
  opts = opts or {} -- define here if you want to define something
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

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

  require("telescope").load_extension("fzf")
end

return M
