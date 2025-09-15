local function get_jlink_device_from_workspace()
  local lyaml = require("lyaml")
  local cwd = vim.fn.getcwd()
  local yaml_path = cwd .. "/build/zephyr/runners.yaml"
  local file = io.open(yaml_path, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  local parsed = lyaml.load(content)
  local args = parsed and parsed.args and parsed.args.jlink
  if not args then
    return nil
  end
  for _, arg in ipairs(args) do
    local device = arg:match("^%-%-device=(.+)")
    if device then
      return device
    end
  end
  return nil
end

return {
  {
    "jedrzejboczar/nvim-dap-cortex-debug",
    dependencies = { "mfussenegger/nvim-dap", "gvvaughan/lyaml" },
    config = function()
      local dap = require("dap")
      local cortex = require("dap-cortex-debug")
      cortex.setup({
        dapui_rtt = true,
        dap_vscode_filetypes = { "c", "cpp" },
      })
      if vim.fn.isdirectory("./build/zephyr") then
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
