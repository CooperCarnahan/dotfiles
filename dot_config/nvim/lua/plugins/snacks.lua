return {
  "folke/snacks.nvim",
  keys = {
    { "<C-p>", "<cmd>lua require('snacks').picker('files')<cr>", desc = "Find files" },
  },
  opts = {
    scroll = { enabled = false },
  },
}
