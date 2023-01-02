local M = {
  'glepnir/dashboard-nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-file-browser.nvim'
  },
  lazy = false,
}

local home = os.getenv('HOME')
local dotfiles = os.getenv('HOME') .. '/.config/nvim'

function search_dotfiles()
  vim.cmd('cd ' .. dotfiles)
  vim.cmd('RestoreSession')
end

function M.config()
  local db = require('dashboard')
  db.custom_center = {
    -- { icon = '  ',
    --   desc = 'Latest Session                          ',
    --   shortcut = 'SPC s l',
    --   action = '<cmd>lua require("persistence").load({ last = true})' },
    { icon = '  ',
      desc = 'Recently opened files                   ',
      action = 'Telescope oldfiles',
      shortcut = '' },
    { icon = '  ',
      desc = 'Find File                               ',
      action = 'Telescope find_files find_command=rg,--hidden,--files',
      shortcut = '' },
    { icon = '  ',
      desc = 'File Browser                            ',
      action = 'Telescope file_browser',
      shortcut = '' },
    { icon = '  ',
      desc = 'Find Word                               ',
      action = 'Telescope live_grep',
      shortcut = '' },
    { icon = '  ',
      desc = 'Open Personal dotfiles                  ',
      action = search_dotfiles,
      shortcut = '' },
  }
end

return M
