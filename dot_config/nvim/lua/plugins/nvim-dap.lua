return {
  "mfussenegger/nvim-dap",
  -- stylua: ignore
  keys = {
    { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over" },
  },
}
