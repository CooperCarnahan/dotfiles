local function get_jlink_device_from_workspace()
  local cwd = vim.fn.getcwd()
  local yaml_path = cwd .. "/build/zephyr/runners.yaml"
  local file = io.open(yaml_path, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()

  -- Find the jlink section
  local jlink_section = content:match("jlink:%s*(.-)%s*\n%s*%w+:")
  if not jlink_section then
    -- Try to get until end of file if jlink is last
    jlink_section = content:match("jlink:%s*(.*)")
  end
  if not jlink_section then
    return nil
  end

  -- Find --device=... in the jlink section
  local device = jlink_section:match("%-%-device=([%w%p]+)")

  return device
end

return {
  {
    "jedrzejboczar/nvim-dap-cortex-debug",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require("dap")
      local cortex = require("dap-cortex-debug")
      cortex.setup({
        dapui_rtt = true,
        dap_vscode_filetypes = { "c", "cpp" },
      })
      local sdk_dir = os.getenv("ZEPHYR_SDK_INSTALL_DIR")
      if vim.fn.isdirectory("./build/zephyr") == 1 and sdk_dir then
        dap.configurations.c = {
          cortex.jlink_config({
            name = "Zephyr (J-Link, Neovim)",
            servertype = "jlink",
            device = get_jlink_device_from_workspace(),
            interface = "swd",
            rtos = "Zephyr",
            cwd = "${workspaceFolder}",
            executable = "${workspaceFolder}/build/zephyr/zephyr.elf",
            gdbPath = os.getenv("ZEPHYR_SDK_INSTALL_DIR") .. "arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb",
            toolchainPrefix = "arm-zephyr-eabi",
            toolchainPath = os.getenv("ZEPHYR_SDK_INSTALL_DIR") .. "arm-zephyr-eabi/bin",
          }),
        }
      end
    end,
  },
}
