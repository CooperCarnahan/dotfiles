local M = {
  'glepnir/dashboard-nvim',
  lazy = false,
}

local home = os.getenv('HOME')

function M.config()
  local db = require('dashboard')
  db.custom_center = {
    { icon = '  ',
      desc = 'Latest Session                          ',
      shortcut = 'SPC s l',
      action = 'SessionLoad' },
    { icon = '  ',
      desc = 'Recently opened files                   ',
      action = 'DashboardFindHistory',
      shortcut = 'SPC f h' },
    { icon = '  ',
      desc = 'Find File                               ',
      action = 'Telescope find_files find_command=rg,--hidden,--files',
      shortcut = 'SPC f f' },
    { icon = '  ',
      desc = 'File Browser                            ',
      action = 'Telescope file_browser',
      shortcut = 'SPC f b' },
    { icon = '  ',
      desc = 'Find Word                               ',
      action = 'Telescope live_grep',
      shortcut = 'SPC f w' },
    { icon = '  ',
      desc = 'Open Personal dotfiles                  ',
      action = 'Telescope dotfiles path=' .. home .. '/.config/',
      shortcut = 'SPC f d' },
  }
end

return M
