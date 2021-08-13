""""""""""""""""""""""""""""""
" => Load vim-plug paths
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugins')

" Themes
Plug 'sainnhe/edge'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'shaunsingh/nord.nvim'
Plug 'marko-cerovac/material.nvim'

Plug 'folke/twilight.nvim'     " Dims inactive portions of code automatically
Plug 'vim-airline/vim-airline' " Adds status bar at bottom of panel
Plug 'vim-airline/vim-airline-themes'

" Start screen
Plug 'mhinz/vim-startify'

"Sessions
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }

" Movement-Related
Plug 'zhou13/vim-easyescape'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'kshenoy/vim-signature' "Enhanced marking + gutter symbols for each mark

" Git-Related
Plug 'airblade/vim-gitgutter'
Plug 'antoinemadec/FixCursorHold.nvim' " Used to fix an issue with updatetime in gitgutter
Plug 'tpope/vim-fugitive'

"Tags
Plug 'preservim/tagbar'
Plug 'ludovicchabant/vim-gutentags'

" Code Completion
Plug 'ervandew/supertab'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-snippets'}

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Code Formatting
Plug 'rhysd/vim-clang-format'
Plug 'sbdchd/neoformat'

" Telescope-related
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" TMUX
Plug 'christoomey/vim-tmux-navigator'

" Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Misc.
Plug 'gennaro-tedesco/nvim-peekup'       " Produces a list of all registers and their contents
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'machakann/vim-highlightedyank'     " Highlights most recently yanked text
Plug 'tpope/vim-commentary'              " Used for commenting and uncommenting code
Plug 'luochen1990/rainbow'               " Adds color to brackets {}
Plug 'yegappan/mru'
Plug 'mileszs/ack.vim'
Plug 'wincent/terminus'
Plug 'folke/zen-mode.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'svermeulen/vim-easyclip'

" Search-related
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'haya14busa/incsearch.vim'

" Always leave devicons for last
Plug 'ryanoasis/vim-devicons'
call plug#end()

"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"             SETTINGS
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
""""""""""""""""""""""""""""
"  Airline 
""""""""""""""""""""""""""""
let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled = 1

""""""""""""""""""""""""""""
"  Startify 
""""""""""""""""""""""""""""
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

""""""""""""""""""""""""""""
"  Sessions 
""""""""""""""""""""""""""""
let g:session_autoload=0
let g:session_autosave="yes"
let g:session_autosave_silent=1

""""""""""""""""""""""""""""
"  SuperTab 
""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = '<C-n>'

"""""""""""""""""""""""""""""
" GitGutter Settings
"""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""
" Vim-sneak Settings
"""""""""""""""""""""""""""""
highlight Sneak guifg=white guibg=orange ctermfg=black ctermbg=red

"""""""""""""""""""""""""""""
"       Clang-Format        "
"""""""""""""""""""""""""""""
let g:clang_format##detect_style_file=1
autocmd FileType c ClangFormatAutoEnable

"""""""""""""""""""""""""""""
"       UltiSnips           "
"""""""""""""""""""""""""""""
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"""""""""""""""""""""""""""""
"       YouCompleteMe       "
"""""""""""""""""""""""""""""
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

"""""""""""""""""""""""""""""
"        Twilight           " 
"""""""""""""""""""""""""""""
lua << EOF
require("twilight").setup {
  dimming = {
    alpha = 0.25, -- amount of dimming
    -- we try to get the foreground from the highlight groups or fallback color
    color = { "Normal", "NONE"},
    inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
  },
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  }
EOF

""""""""""""""""""""""""""""
"      TreeSitter          "
""""""""""""""""""""""""""""
" Enable Treesitter highlighting
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {  },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

""""""""""""""""""""""""""""
"       Telescope          "
""""""""""""""""""""""""""""
" Telescope Plugin settings
lua <<EOF
require("telescope").setup {
  defaults = {
    file_ignore_patterns = { 'Release/.*', 'Debug/.*', 'build/.*'},
  },
  pickers = {
    -- Your special builtin config goes in here
    buffers = {
      sort_lastused = true,
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
          -- Right hand side can also be the name of the action as a string
          ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }
      }
    },
    find_files = {
      theme = "dropdown"
    }
  },
  extensions = {
    fzf_writer = {
        use_highlighter = true
    }
  }
}

EOF

""""""""""""""""""""""""""""
"       EasyClip           "
""""""""""""""""""""""""""""
let g:EasyClipUseSubstituteDefaults=1
let g:EasyClipUseCutDefaults=0

""""""""""""""""""""""""""""
"       IncSearch          "
""""""""""""""""""""""""""""
let g:incsearch#auto_nohlsearch=1

""""""""""""""""""""""""""""
"       Gutentags          "
""""""""""""""""""""""""""""
let g:gutentags_ctags_exclude=['Release', 'Debug', 'build', '*.d', '*.o']
" Add gutentags TAGS message when generating things in the background
set statusline+=%{gutentags#statusline()}

""""""""""""""""""""""""""""
"      Zen-Mode 
""""""""""""""""""""""""""""
lua << EOF
  require("zen-mode").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
hi ZenModeBg NONE

""""""""""""""""""""""""""""
"  Neoformat 
""""""""""""""""""""""""""""
augroup fmt
  autocmd!
  au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
augroup END
