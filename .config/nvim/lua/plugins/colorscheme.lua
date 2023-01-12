return {

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      local tokyonight = require("tokyonight")
      tokyonight.setup({ style = "moon" })
      tokyonight.load()
    end,
  },
  {
    'sainnhe/gruvbox-material',
    priority = 100,
    lazy = false,
    config = function()
      vim.g.gruvbox_material_background = 'hard'
      vim.cmd([[colorscheme gruvbox-material]])
    end
  },
  {
    'sainnhe/edge',
    lazy = true
  },
  {
    'shaunsingh/nord.nvim',
    lazy = true
  },
  {
    'marko-cerovac/material.nvim',
    lazy = true
  },
  {
    'navarasu/onedark.nvim',
    lazy = true,
  },
}
