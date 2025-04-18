return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "netmute/ctags-lsp.nvim",
  },
  opts = {
    diagnostics = {
      virtual_text = false,
      virtual_lines = true,
    },
    servers = {
      -- Ensure mason installs the server
      clangd = {
        keys = {
          { "gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
            fname
          ) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },
      ctags_lsp = {
        filetypes = { "c", "cpp" },
        root_dir = "", -- there's currently a bug on windows if we pass it a root dir, so we let the server figure it out instead
        on_attach = function(client, bufnr)
          -- Use lspconfig.util to check for compile_commands.json
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local compile_commands_root = require("lspconfig.util").root_pattern("compile_commands.json")(fname)

          -- If compile_commands.json is found, stop ctags_lsp
          if compile_commands_root then
            client.stop() -- Stop the ctags_lsp client
            return false -- Prevent further attachment
          end
        end,
      },
    },
    setup = {
      clangd = function(_, opts)
        local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
        require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
        return false
      end,
    },
  },
}
