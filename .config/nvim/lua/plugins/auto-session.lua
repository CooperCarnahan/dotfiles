local M = {
  "rmagatti/auto-session",
  lazy = false,
}

local function delete_git_index()
  vim.cmd("bdelete .git/index")
end

function M.config()
  require("auto-session").setup {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_save_enabled = true,
    auto_session_create_enabled = false,
    pre_save_cmds = { delete_git_index },
  }
end

return M
