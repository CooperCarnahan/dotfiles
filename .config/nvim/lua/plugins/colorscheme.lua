return {

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local tokyonight = require("tokyonight")
      tokyonight.setup({ style = "moon" })
      tokyonight.load()
    end,
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

