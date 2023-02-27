local M = {
  'cdelledonne/vim-cmake',
  event = "VeryLazy"
}

function M.config()
  vim.g.cmake_default_config = 'build'
end

return M
