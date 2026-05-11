return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  opts = {
    layout = {
      prompt_position = "top",
    },
    keymaps = {
      close = { "<Esc>", "<C-c>" },
    },
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("fff").find_files()
      end,
      desc = "Find Files (fff)",
    },
    {
      "<leader>fG",
      function()
        require("fff").live_grep()
      end,
      desc = "Live Grep (fff)",
    },
  },
}
