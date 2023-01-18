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
  { "michaelb/sniprun",
    build = "bash ./install.sh",
    config = true,
    cmd = "SnipRun" },
  { "kylechui/nvim-surround",
    config = true,
    commit = "ad56e62",
    event = "VeryLazy" },
  { "tpope/vim-repeat",
    event = "VeryLazy" },
  { "jeffkreeftmeijer/vim-numbertoggle",
    event = "VeryLazy" },
  { "gbprod/cutlass.nvim",
    event = "VeryLazy",
    config = function()
      require("cutlass").setup({ exclude = { "ns", "nS" }, })
    end,
    commit = "e607a",
    pin = true },
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
  { "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true, },
  { "jghauser/mkdir.nvim",
    event = "VeryLazy", },
  { "stevearc/overseer.nvim",
    -- cmd = "OverseerRun",
    event = "VeryLazy",
    config = true },
  { "folke/twilight.nvim",
    cmd = "Twilight",
    config = true },
  { "vim-test/vim-test",
    branch = "master",
    commit = "ca25025",
    event = "VeryLazy",
    config = function()
      vim.g['test#cpp#catch2#relToProject_build_dir'] = "Debug/bin"
      -- vim.g['test#cpp#catch2#bin_dir'] = './bin/'
    end,
    dependencies = {
      'skywind3000/asyncrun.vim',
      'cdelledonne/vim-cmake',
      -- 'neomake/neomake',
      'tpope/vim-dispatch',
    }
  },
  { "APZelos/blamer.nvim",
    cmd = "BlamerToggle",
  },
  -- { "chrisgrieser/nvim-recorder",
  --   event = "VeryLazy",
  --   config = true, }
}
