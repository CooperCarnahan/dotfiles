local M = {
  "luukvbaal/statuscol.nvim",
  event = "BufReadPre",
}

function M.config()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup({
    relculright = true,
    segments = {
      -- fold markers
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      -- lsp diagnostic symbols
      {
        sign = { name = { "Diagnostic" }, maxwidth = 2, colwidth = 2, auto = false },
        click = "v:lua.ScSa"
      },
      -- dap breakpoint symbol
      {
        sign = { name = { "DapBreakpoint" }, maxwidth = 2, colwidth = 0, auto = true },
        click = "v:lua.ScSa"
      },
      -- line numbers
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
      -- everything else; basically just git at this point
      {
        sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true },
      },
    }
  })
end

return M
