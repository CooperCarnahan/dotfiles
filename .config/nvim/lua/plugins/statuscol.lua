local M = {
  "luukvbaal/statuscol.nvim",
  event = "BufReadPre",
}

function M.config()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup({
    relculright = true,
    segments = {
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      {
        sign = { name = { "Diagnostic" }, maxwidth = 2, colwidth = 2, auto = false },
        click = "v:lua.ScSa"
      },
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
      {
        sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = false },
      },
    }
  })
end

return M
