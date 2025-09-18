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
      },
      ctags_lsp = {
        cmd = { "ctags-lsp" },
        filetypes = { "c", "cpp" },
      },
    },
  },
}
