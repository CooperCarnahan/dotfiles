-- basic telescope configuration
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for idx, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, {file = item.value, text = item.value, idx = idx})
  end
  require("snacks.picker").pick({title = "Harpoon", items = file_paths})
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})
  end,
  keys = {
    {
      "<leader>ho",
      function()
        toggle_telescope(require("harpoon"):list())
      end,
      desc = "Open harpoon window",
    },
    {
      "<leader>hh",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Open harpoon window",
    },
    {
      "<leader>ha",
      function()
        local harpoon = require("harpoon")
        harpoon:list():add()
      end,
      desc = "Add to harpoon",
    },
    {
      "<leader>hr",
      function()
        require("harpoon"):list():remove()
      end,
      desc = "Remove from harpoon",
    },
    {
      "<leader>hn",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Harpoon next",
    },
    {
      "<leader>hp",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Harpoon previous",
    },
  },
}
