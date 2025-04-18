return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>srw",
      mode = { "n", "v" },
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%") } })
      end,
      desc = "Replace current word in current file",
    },
    {
      "<leader>srW",
      mode = { "n", "v" },
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Replace current word everywhere",
    },
    {
      "<leader>srf",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Replace in current file",
    },
    {
      "<leader>srF",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Replace in all files",
    },
    {
      "<leader>sra",
      function()
        require("grug-far").open({ engine = "astgrep", prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Astgrep replace in current file",
    },
    {
      "<leader>srA",
      function()
        require("grug-far").open({ engine = "astgrep", prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Astgrep replace in all files",
    },
  },
}
