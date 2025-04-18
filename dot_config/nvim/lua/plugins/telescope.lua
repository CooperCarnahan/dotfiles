return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "jvgrootveld/telescope-zoxide",
  },
  keys = {
    { "<leader>st", "<cmd>Telescope tags<cr>", desc = "Find tags" },
    { "<leader>sz", "<cmd>Telescope zoxide list<cr>", desc = "Telescope Zoxide" },
  },
  opts = {
    pickers = {
      tags = {
        only_sort_tags = true,
      },
    },
    extensions = {
      zoxide = {
        mappings = {
          ["<C-t>"] = {
            action = function(selection)
              vim.cmd.tcd(selection.path)
            end,
            after_action = function(selection)
              print("Tab directory changed to " .. selection.path)
            end,
          },
        },
      },
      frecency = {
        default_workspace = "CWD",
      },
    },
  },
}
