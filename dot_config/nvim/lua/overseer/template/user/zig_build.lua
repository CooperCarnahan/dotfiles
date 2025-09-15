return {
  name = "zig build run",
  priority = 1,
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "zig" },
      args = { "build", "run" },
      components = {
        {
          "on_output_parse",
          parser = {
            -- Put the parser results into the 'diagnostics' field on the task result
            diagnostics = {
              -- Extract fields using lua patterns
              -- To integrate with other components, items in the "diagnostics" result should match
              -- vim's quickfix item format (:help setqflist)
              {
                "sequence",
                {
                  "extract",
                  { append = false },
                  "^([^%s].+):(%d+):(%d+): (.+): (.+)$",
                  "filename",
                  "lnum",
                  "col",
                  "type",
                  "text",
                },
                {
                  "extract",
                  "^ *(.*)$",
                  "code",
                },
              },
            },
          },
        },
        { "on_result_diagnostics" },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "zig" },
  },
}
