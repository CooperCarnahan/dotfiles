local seen = {} -- used to skip duplicate entries in lsp_definitions

return {
  "folke/snacks.nvim",
  keys = {
    { "<C-p>", "<cmd>lua require('snacks').picker('smart')<cr>", desc = "Find files (smart)" },
    { "<C-t>", "<cmd>lua require('snacks').picker('treesitter')<cr>", desc = "Find treesitter symbols" },
    { "<leader>sz", "<cmd>lua require('snacks').picker('zoxide')<cr>", desc = "Find Zoxide" },
  },
  opts = {
    scroll = { enabled = false },
    picker = {
      sources = {
        lsp_definitions = {
          layout = { preset = "ivy" },
          matcher = { frecency = true, history_bonus = true },
          unique_lines = true,
          filter = {
            filter = function(item, _)
              if not item.file or not item.line then
                return false -- Return false for invalid items
              end

              -- skip stuff we've already seen
              local key = item.file .. ":" .. item.line
              if not seen[key] then
                seen[key] = true
                return true
              end
              return false
            end,
          },
          on_close = function()
            -- Clear the `seen` table efficiently when the picker is closed
            seen = {}
          end,
        },
      },
    },
  },
}
