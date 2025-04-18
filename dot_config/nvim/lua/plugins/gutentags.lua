-- make ctags 'cache' dir so tags file doesn't pollute project
if vim.fn.isdirectory(vim.fn.stdpath("data") .. "/ctags") == 0 then
  vim.fn.mkdir(vim.fn.stdpath("data") .. "/ctags")
end

local M = {
  "ludovicchabant/vim-gutentags",
}

function M.config()
  vim.g.gutentags_ctags_exclude = {
    "*.git",
    "*.svg",
    "*.hg",
    "*/tests/*",
    "build",
    "dist",
    "*sites/*/files/*",
    "bin",
    "node_modules",
    "bower_components",
    "cache",
    "compiled",
    "docs",
    "example",
    "bundle",
    "vendor",
    "*.md",
    "*-lock.json",
    "*.lock",
    "*bundle*.js",
    "*build*.js",
    ".*rc*",
    "*.json",
    "*.min.*",
    "*.map",
    "*.bak",
    "*.zip",
    "*.pyc",
    "*.class",
    "*.sln",
    "*.Master",
    "*.csproj",
    "*.tmp",
    "*.csproj.user",
    "*.cache",
    "*.pdb",
    "tags*",
    "cscope.*",
    "*.exe",
    "*.dll",
    "*.mp3",
    "*.ogg",
    "*.flac",
    "*.swp",
    "*.swo",
    "*.bmp",
    "*.gif",
    "*.ico",
    "*.jpg",
    "*.png",
    "*.rar",
    "*.zip",
    "*.tar",
    "*.tar.gz",
    "*.tar.xz",
    "*.tar.bz2",
    "*.pdf",
    "*.doc",
    "*.docx",
    "*.ppt",
    "*.pptx",
  }

  vim.g.gutentags_cache_dir = vim.fn.stdpath("data") .. "/ctags"
  vim.g.gutentags_project_root = { "package.json", ".git" }
  vim.g.gutentags_generate_on_new = true
  vim.g.gutentags_generate_on_missing = true
  vim.g.gutentags_generate_on_write = true
  vim.g.gutentags_generate_on_empty_buffer = true
  vim.g.gutentags_modules = true
  vim.cmd([[command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')]])
  vim.g.gutentags_ctags_extra_args = { "--tag-relative=yes", "--fields=+ailmnS" }
  vim.g.gutentags_exclude_project_root = { "/usr/local/", vim.fn.expand("$HOME") }

  vim.g.gutentags_modules = { "ctags" }
end

-- custom function to use in statusline
function M.status()
  local i = 1
  local dots = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
  -- local dots = { "   ", ".  ", ".. ", "..." }
  return function()
    i = (i + 1) % #dots
    return (vim.fn["gutentags#statusline"]() ~= "" and "Generating tags " .. dots[i + 1] or "")
  end
end

return M
