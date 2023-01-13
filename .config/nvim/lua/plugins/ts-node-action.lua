return {
  "CKolkey/ts-node-action",
  event = "VeryLazy",
  dependencies = { 'nvim-treesitter' },
  config = function()
    vim.keymap.set({ "n" }, "<C-a>", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
    local actions = require("ts-node-action.actions")
    require('ts-node-action').setup({
      ['*'] = {
        ["binary_expression"] = actions.toggle_operator(),
        ["field_identifier"] = actions.cycle_case()
      }
    })
  end
}
