local M = {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy"
}

function M.config()
  require('neogen').setup({
    languages = {
      ['cpp.doxygen'] = require('neogen.configurations.cpp'),
      ['c.doxygen'] = require('neogen.configurations.c')
    }
  })
  vim.keymap.set("n", "<leader>nf", "<cmd>TSTextobjectGotoPreviousStart @function.outer<cr><cmd>Neogen func<cr>",
    { desc = "Document Current Function" })
end

return M
