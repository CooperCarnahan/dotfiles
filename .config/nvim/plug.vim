""""""""""""""""""""""""""""""
" => Load vim-plug paths
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugins')

" Themes
Plug 'sainnhe/edge'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'shaunsingh/nord.nvim'
Plug 'marko-cerovac/material.nvim'

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }

Plug 'zhou13/vim-easyescape'
Plug 'tpope/vim-surround'

" Git-related
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Code Completion
Plug 'ervandew/supertab'
Plug 'ycm-core/YouCompleteMe'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Code formatting
Plug 'rhysd/vim-clang-format'

Plug 'folke/twilight.nvim'            " Dims inactive portions of code automatically
Plug 'vim-airline/vim-airline'        " Adds status bar at bottom of panel
Plug 'vim-airline/vim-airline-themes'

" Misc.
Plug 'gennaro-tedesco/nvim-peekup'       " Produces a list of all registers and their contents
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'machakann/vim-highlightedyank'     " Highlights most recently yanked text
Plug 'tpope/vim-commentary'              " Used for commenting and uncommenting code
Plug 'luochen1990/rainbow'               " Adds color to brackets {}
Plug 'yegappan/mru'
Plug 'mileszs/ack.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" Telescope-related
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Always leave devicons for last
Plug 'ryanoasis/vim-devicons'
call plug#end()

"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"             SETTINGS
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
""""""""""""""""""""""""""""
"  SuperTab 
""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = '<C-n>'

"""""""""""""""""""""""""""""
" GitGutter Settings
"""""""""""""""""""""""""""""

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
require('telescope').setup {
    extensions = {
        fzf_writer = {
            use_highlighter = true
        }
    }
}
EOF

