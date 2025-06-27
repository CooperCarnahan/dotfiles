return {
  "willothy/flatten.nvim",
  config = true,
  opts = function()
    local was_lazygit = false

    return {
      window = {
        open = "alternate",
      },
      hooks = {
        should_nest = function(host)
          local bufnr = vim.rpcrequest(host, "nvim_get_current_buf")
          local buftype = vim.rpcrequest(host, "nvim_get_option_value", "buftype", { buf = bufnr })
          local name = vim.rpcrequest(host, "nvim_buf_get_name", bufnr)
          if buftype == "terminal" and name:lower():find("lazygit") then
            return true
          end
          return false
        end,
      },
    }
  end,
  lazy = false,
  priority = 1001,
}
