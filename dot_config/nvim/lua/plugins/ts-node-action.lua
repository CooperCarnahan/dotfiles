return {
  "ckolkey/ts-node-action",
  dependencies = { "nvim-treesitter" },
  opts = {},
  keys = { { "gk", "<cmd>NodeAction<cr>", desc = "Trigger Node Action" } },
  config = function()
    require("ts-node-action").setup()
  end,
}
