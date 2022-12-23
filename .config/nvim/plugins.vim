""""""""""""""""""""""""""""""
" => Load vim-plug paths
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugins')

Plug 'lewis6991/impatient.nvim'

" C/C++
Plug 'cdelledonne/vim-cmake'

" Git-Related
Plug 'airblade/vim-gitgutter'
Plug 'antoinemadec/FixCursorHold.nvim' " Used to fix an issue with updatetime in gitgutter
Plug 'tpope/vim-fugitive'
Plug 'APZelos/blamer.nvim'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Formatting
Plug 'sbdchd/neoformat'

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'glepnir/lspsaga.nvim'

" Markdown
Plug 'plasticboy/vim-markdown', { 'for': ['markdown']}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Movement-Related
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'kshenoy/vim-signature' "Enhanced marking + gutter symbols for each mark
Plug 'tpope/vim-unimpaired'  "Adds various movements using the '[' and ']' keys
Plug 'bkad/CamelCaseMotion'  "Allows moving via CamelCase "words" using leader prefix
Plug 'ggandor/leap.nvim'

" Notify
" Plug 'MunifTanjim/nui.nvim'
" Plug 'rcarriga/nvim-notify'
" Plug 'folke/noice.nvim'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'

" Search-related
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-abolish'

" Sessions
Plug 'mhinz/vim-startify'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" Tags
Plug 'preservim/tagbar'
Plug 'ludovicchabant/vim-gutentags'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Terminal
Plug 'voldikss/vim-floaterm'

" Themes
Plug 'sainnhe/edge'
Plug 'shaunsingh/nord.nvim'
Plug 'marko-cerovac/material.nvim'
Plug 'joshdick/onedark.vim'

"Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lualine/lualine.nvim'

" TreeSitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}       " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-context'

Plug 'nixprime/cpsm'
Plug 'romgrk/fzy-lua-native'

" Misc.
Plug 'numToStr/comment.nvim'
Plug 'svermeulen/vim-easyclip'
Plug 'machakann/vim-highlightedyank'                              " Highlights most recently yanked text
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'wincent/terminus'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }

" Always leave devicons for last
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'ryanoasis/vim-devicons'
call plug#end()

"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"             SETTINGS
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

" Speed up plugins using cache
lua require('impatient')

""""""""""""""""""""""""""""
"  Bufferline 
""""""""""""""""""""""""""""
"set termguicolors
"lua require('bufferline-config')

""""""""""""""""""""""""""""
"       Commentary         "
""""""""""""""""""""""""""""
lua require('Comment').setup()

""""""""""""""""""""""""""""
"       EasyClip           "
""""""""""""""""""""""""""""
let g:EasyClipUseSubstituteDefaults=1
let g:EasyClipUseCutDefaults=0

""""""""""""""""""""""""""""
"       FloatTerm          "
""""""""""""""""""""""""""""
lua<<EOF
vim.api.nvim_set_var("floaterm_width", .8)
vim.api.nvim_set_var("floaterm_height", .8)
EOF

""""""""""""""""""""""""""""
"       GitBlamer          "
""""""""""""""""""""""""""""
let g:blamer_enabled = 0
let g:blamer_delay = 500
let g:blamer_prefix = '    '
let g:blamer_date_format = '%m/%d/%y %I:%M %p'

""""""""""""""""""""""""""""
"       Gutentags          "
""""""""""""""""""""""""""""
let g:gutentags_ctags_exclude=['Release', 'Debug', 'build', '*.d', '*.o']
let g:gutentags_ctags_extra_args=['--fields="+n"']
" Add gutentags TAGS message when generating things in the background
set statusline+=%{gutentags#statusline()}

""""""""""""""""""""""""""""
"       Gutter             "
""""""""""""""""""""""""""""
set signcolumn=yes

""""""""""""""""""""""""""""
"       Leap               "
""""""""""""""""""""""""""""
lua require('leap').add_default_mappings()

""""""""""""""""""""""""""""
"       LuaLine            "
""""""""""""""""""""""""""""
lua require('lualine-config')

""""""""""""""""""""""""""""
"       LuaSnip            "
""""""""""""""""""""""""""""
lua require("luasnip.loaders.from_vscode").lazy_load()
lua require("luasnip-config")

""""""""""""""""""""""""""""
"     LSP-Saga             "
""""""""""""""""""""""""""""
lua require('lsp/lsp-saga')

""""""""""""""""""""""""""""
"         Mason            "
""""""""""""""""""""""""""""
lua require("mason").setup()
lua require("mason-lspconfig").setup()

""""""""""""""""""""""""""""
"         Noice            "
""""""""""""""""""""""""""""
" lua<<EOF
" require("noice").setup()
" EOF

""""""""""""""""""""""""""""
"         Nvim-CMP         "
""""""""""""""""""""""""""""
set completeopt=menu,menuone,noselect
lua require('nvim-cmp')

""""""""""""""""""""""""""""
"      Nvim-LspConfig      "
""""""""""""""""""""""""""""
lua require('nvim-lspconfig')

""""""""""""""""""""""""""""
"     Nvim-TreeExplorer    "
""""""""""""""""""""""""""""
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.

lua <<EOF
require'nvim-web-devicons'.setup {
 -- your personal icons can go here (to override)
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    name = "Zsh"
  }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

EOF

""""""""""""""""""""""""""""
"         Startify         "
""""""""""""""""""""""""""""
let g:startify_session_dir = '~/.config/nvim/sessions'
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
let g:startify_bookmarks = [
      \ {'n': '~/.config/nvim'},
      \ {'z': '~/.zshrc'},
      \ ]

""""""""""""""""""""""""""""
"       Telescope          "
""""""""""""""""""""""""""""
" Telescope Plugin settings
lua require("telescope/telescope-config")

""""""""""""""""""""""""""""
"        TreeSitter        "
""""""""""""""""""""""""""""
" Enable Treesitter highlighting
lua require("treesitter/ts-config")

"""""""""""""""""""""""""""""
"         Vim-Sneak         "
"""""""""""""""""""""""""""""
highlight Sneak guifg=white guibg=orange ctermfg=black ctermbg=red

