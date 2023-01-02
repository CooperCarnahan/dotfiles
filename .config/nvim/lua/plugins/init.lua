-- Plugins that don't have some grandiose config can go in here

return {
  "MunifTanjim/nui.nvim",
  "folke/which-key.nvim",
  { "nvim-tree/nvim-web-devicons",
    config = { default = true }, },
  { "SmiteshP/nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
    end, },
  { "numToStr/comment.nvim",
    config = true,
    event = "VeryLazy" },
  { 'voldikss/vim-floaterm',
    config = function()
      vim.api.nvim_set_var("floaterm_width", .8)
      vim.api.nvim_set_var("floaterm_height", .8)
    end,
    event = "VeryLazy" },
  { "tpope/vim-surround",
    event = "VeryLazy" },
  { "tpope/vim-repeat",
    event = "VeryLazy" },
  { "jeffkreeftmeijer/vim-numbertoggle",
    event = "VeryLazy" },
  { "svermeulen/vim-cutlass",
    event = "VeryLazy" },
  { "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_save_enabled = true,
        auto_session_create_enabled = false
      }
    end,
    lazy = false, },
  { "folke/twilight.nvim",
    cmd = "Twilight",
    config = true },
  { "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true, },
}
