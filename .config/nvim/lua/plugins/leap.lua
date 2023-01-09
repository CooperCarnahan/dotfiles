local M = {
  "ggandor/leap.nvim",
  event = "VeryLazy",

  dependencies = {
    { "ggandor/flit.nvim", config = { labeled_modes = "nxv" } },
  },

  config = function()
    require("leap").add_default_mappings()
  end,
}

return M
