local M = {
  'glepnir/lspsaga.nvim',
  event = 'BufRead'
}

function M.config()
  local keymap = vim.keymap.set
  local saga = require("lspsaga")
  saga.setup({
    show_outline = {
      win_position = "right",
      --set special filetype win that outline window split.like NvimTree neotree
      -- defx, db_ui
      win_with = " ",
      win_width = 50,
      auto_enter = true,
      auto_preview = true,
      virt_text = "┃",
      jump_key = "<CR>",
      -- auto refresh when change buffer
      auto_refresh = true,
    },
  })

  -- Lsp finder find the symbol definition implement reference
  -- if there is no implement it will hide
  -- when you use action in finder like open vsplit then you can
  -- use <C-t> to jump back
  keymap("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", { silent = true, desc = "[LspSaga] Open delcaration & references" })

  -- Code action
  keymap(
    { "n", "v" },
    "<leader>ca",
    "<cmd>Lspsaga code_action<CR>",
    { silent = true, desc = "[LspSaga] Run code action" }
  )

  -- Rename
  keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true, desc = "[LspSaga] Interactive rename" })

  -- Peek Definition
  -- you can edit the definition file in this floatwindow
  -- also support open/vsplit/etc operation check definition_action_keys
  -- support tagstack C-t jump back
  keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true, desc = "[LspSaga] Peek definition" })

  -- Show line diagnostics
  keymap(
    "n",
    "<leader>ld",
    "<cmd>Lspsaga show_line_diagnostics<CR>",
    { silent = true, desc = "[LspSaga] Show line diagnostics" }
  )

  -- Show cursor diagnostics
  keymap(
    "n",
    "<leader>cd",
    "<cmd>Lspsaga show_cursor_diagnostics<CR>",
    { silent = true, desc = "[LspSaga] Show cursor diagnostics" }
  )

  -- Outline
  keymap("n", "<leader>ol", "<cmd>Lspsaga outline<CR>", { silent = true, desc = "[LspSaga] Open LSP outline of buffer" })

  -- Hover Doc
  keymap(
    "n",
    "K",
    "<cmd>Lspsaga hover_doc<CR>",
    { silent = true, desc = "[LspSaga] Open documentation for symbol under cursor in a floating window" }
  )

end

return M
