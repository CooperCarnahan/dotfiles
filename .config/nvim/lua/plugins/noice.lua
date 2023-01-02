local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  }

}

function M.config()
  require("noice").setup()
end

return M
