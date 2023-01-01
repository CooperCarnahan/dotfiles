vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ================ Misc. Configs ====================
vim.o.number = true --Line numbers are good
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.backspace = "indent,eol,start" --Allow backspace in insert mode
vim.o.history = 1000 --Store lots of :cmdline history
vim.o.showcmd = true --Show incomplete cmds down the bottom
vim.o.visualbell = true --No sounds
vim.o.autoread = true --Reload files changed outside vim
vim.o.updatetime = 100 --Various plugins will update quicker (gitgutter, etc.).
vim.o.splitright = true
vim.o.hidden = true --Allows switching buffers without saving
vim.o.foldlevel = 99
vim.o.scrolloff = 999 --Jumps are centered if possible
vim.opt.grepprg = "rg --vimgrep"

--================ Color Configs ====================
vim.o.termguicolors = true --Enable true colors
vim.o.cursorline = true --Enable different coloring of current line #

--================ Persistent Undo ==================
--Keep undo history across sessions, by storing in file.
--Only works all the time.
--if has('persistent_undo') && isdirectory(expand('~').'/.config/nvim/undodir')
--  silent !mkdir ~/.config/nvim/undodir > /dev/null 2>&1
--  set undodir=~/.config/nvim/undodir
--  set undofile
--endif

--================ Indentation ======================
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.expandtab = true

vim.o.nowrap = true --Don't wrap lines
vim.o.linebreak = true --Wrap lines at convenient points

--================ Search ===========================
vim.o.incsearch = true -- Find the next match as we type the search
vim.o.hlsearch = true -- Highlight searches by default
vim.o.ignorecase = true -- Ignore case when searching...
vim.o.smartcase = true -- ...unless we type a capital

vim.cmd([[filetype plugin on]])
vim.cmd([[filetype indent on]])

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.cmd([[silent! normal! g`"]])
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 1000 }
  end,
})

--Wrap lines when working with a markdown file
vim.cmd([[autocmd FileType markdown setlocal spell]])

--Set .MD files to be interpreted as markdown
vim.cmd([[autocmd BufNewFile,BufRead *.MD set filetype=markdown]])
