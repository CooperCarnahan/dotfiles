return {
  "https://git.sr.ht/~swaits/zellij-nav.nvim",
  lazy = true,
  event = "VeryLazy",
  cond = vim.uv.os_uname().sysname ~= "Windows_NT",
  keys = {
    { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "navigate left or tab" } },
    { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
    { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
    { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
  },
  opts = {},
}
