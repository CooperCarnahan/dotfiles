local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = "BufEnter",
}

function M.config()
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = 'auto',
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        { "diagnostics", sources = { "nvim_diagnostic" } },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    winbar = {
      lualine_a = {},
      lualine_b = {
        {
          "filetype",
          colored = true,             -- Displays filetype icon in color if set to true
          icon_only = true,           -- Display only an icon for filetype
          icon = { align = "right" }, -- Display filetype icon on the right hand side
        },
      },
      lualine_c = {
        {
          "filename",
          path = 3,
          symbols = {
            modified = " ●",    -- Text to show when the buffer is modified
            alternate_file = "#", -- Text to show to identify the alternate file
            directory = "",    -- Text to show when the buffer is a directory
          },
        },
        {
          function()
            local navic = require("nvim-navic")
            local ret = navic.get_location()
            return ret:len() > 2000 and "navic error" or ret
          end,
          cond = function()
            if package.loaded["nvim-navic"] then
              local navic = require("nvim-navic")
              return navic.is_available()
            end
          end,
          -- color = { fg = "#ff9e64" },
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          symbols = {
            modified = " ●",    -- Text to show when the buffer is modified
            alternate_file = "#", -- Text to show to identify the alternate file
            directory = "",    -- Text to show when the buffer is a directory
          },
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  })
end

return M
