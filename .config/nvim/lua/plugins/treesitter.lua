return {

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPre",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require('treesitter-context').setup()

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          -- "comment", -- comments are slowing down TS bigtime, so disable for now
          "cpp",
          "css",
          "diff",
          "fish",
          --          "gitignore",
          "go",
          "graphql",
          "help",
          "html",
          "http",
          "java",
          "javascript",
          "jsdoc",
          "jsonc",
          "latex",
          "lua",
          "markdown",
          "markdown_inline",
          "meson",
          "ninja",
          "nix",
          "norg",
          "org",
          "php",
          "python",
          "query",
          "regex",
          "rust",
          "scss",
          --         "sql",
          "svelte",
          --         "teal",
          "toml",
          "tsx",
          "typescript",
          "vhs",
          "vim",
          "vue",
          "wgsl",
          "yaml",
          "json",
        },
        sync_install = false,
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = false },
        context_commentstring = { enable = true, enable_autocmd = false },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<cr>",
            node_incremental = "<cr>",
            scope_incremental = "<C-s>",
            node_decremental = "<bs>",
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        textsubjects = {
          enable = true,
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.outer" },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sp"] = "@parameter.inner",
              ["<leader>sf"] = "@function.outer",
              ["<leader>sb"] = "@block.outer",
            },
            swap_previous = {
              ["<leader>sP"] = "@parameter.inner",
              ["<leader>sF"] = "@function.outer",
              ["<leader>sB"] = "@block.outer",
            },
          },
          lsp_interop = {
            enable = true,
            peek_definition_code = {
              ["gD"] = "@function.outer",
            },
          },
        },
      })
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.markdown.filetype_to_parsername = "octo"
    end,
  },
}
