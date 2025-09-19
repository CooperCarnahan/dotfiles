return {
  "neovim/nvim-lspconfig",
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
