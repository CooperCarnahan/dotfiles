local M = {
  'cdelledonne/vim-cmake',
  event = "VeryLazy"
}

-- setup DAP
function M.config()
  vim.g.cmake_build_options = ['--parallel']
  vim.g.cmake_default_config = 'build'
end

return M
