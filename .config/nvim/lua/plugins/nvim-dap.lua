local M = {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui',
      config = true
    },
    { 'theHamsta/nvim-dap-virtual-text',
      config = true
    },
    { 'mfussenegger/nvim-dap-python',
    },
  },
  event = "VeryLazy"
}

-- setup DAP
function M.config()
  local dap = require('dap')
  require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '/usr/bin/lldb-vscode-15',
    name = 'lldb'
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtEntry = true,
    },
    {
      name = 'Attach to gdbserver :1234',
      type = 'cppdbg',
      request = 'launch',
      MIMode = 'gdb',
      miDebuggerServerAddress = 'localhost:1234',
      miDebuggerPath = '/usr/bin/gdb',
      cwd = '${workspaceFolder}',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
      end,
    },
  }
  dap.configurations.c = dap.configurations.cpp

  -- Keymaps
  vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = "DAP Continue" })
  vim.keymap.set('n', '<leader>dr', function() require('dap').run_last() end, { desc = "DAP Run Last" })
  vim.keymap.set('n', '<leader>dsi', function() require('dap').step_into() end, { desc = "DAP Step into" })
  vim.keymap.set('n', '<leader>dso', function() require('dap').step_over() end, { desc = "DAP Step over" })
  vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = "Toggle breakpoint" })

  -- open dapui on debug enable
  local dapui = require("dapui")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

return M
