local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}

function M.config()
  local noice = require("noice")
  noice.setup({
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
    },
  })
end

return M
