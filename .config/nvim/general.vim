" ================ Misc. Configs ====================
set number relativenumber       "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set updatetime=100               "Various plugins will update quicker (gitgutter, etc.). 

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" ================ Color Configs ====================
colorscheme material
set termguicolors               "Enable true colors
hi  Normal guibg=NONE           "Disable background colors for transparency (in gui programs)
hi  Normal ctermbg=NONE         "Disable background colors for transparency (in terminal programs)
hi  CursorLineNr guifg=white    "Set current line number color (in gui programs)
hi  CursorLineNr ctermfg=white  "Set current line number color (in terminal programs)
hi  LineNr guifg=grey           "Set other line number color (in gui programs)
hi  LineNr ctermfg=grey         "Set other line number color (in terminal programs)
hi  SignColumn guibg=NONE       "Set sign column to nothing for opacity reasons
hi  SignColumn ctermbg=NONE     "Set sign column to nothing for opacity reasons

" ================ Plugin Color Configs ====================
hi  Sneak ctermbg=172           "Set sign column to nothing for opacity reasons
hi  Sneak guibg=orange          "Set sign column to nothing for opacity reasons
hi  Sneak ctermfg=white         "Set sign column to nothing for opacity reasons
hi  Sneak guifg=white           "Set sign column to nothing for opacity reasons

" ================ Autoreload init.vim ==================
" Automatically reload vimrc
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.config/nvim/undodir')
  silent !mkdir ~/.config/nvim/undodir > /dev/null 2>&1
  set undodir=~/.config/nvim/undodir
  set undofile
endif

" ================ Indentation ======================
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
" nnoremap p p=`]<C-o>
" nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Search ===========================
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

