""""""""""""""""""""""""""""""
" => Load vim-plug paths
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugins')

" C/C++
Plug 'cdelledonne/vim-cmake'

" CoC
" Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-snippets'}
" Plug 'jackguo380/vim-lsp-cxx-highlight'

" Git-Related
Plug 'airblade/vim-gitgutter'
Plug 'antoinemadec/FixCursorHold.nvim' " Used to fix an issue with updatetime in gitgutter
Plug 'tpope/vim-fugitive'
Plug 'APZelos/blamer.nvim'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Formatting
Plug 'rhysd/vim-clang-format'
Plug 'sbdchd/neoformat'

" LSP
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Markdown
Plug 'plasticboy/vim-markdown', { 'for': ['markdown']}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Movement-Related
Plug 'zhou13/vim-easyescape'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'kshenoy/vim-signature' "Enhanced marking + gutter symbols for each mark
Plug 'tpope/vim-unimpaired'  "Adds various movements using the '[' and ']' keys
Plug 'bkad/CamelCaseMotion'  "Allows moving via CamelCase "words" using leader prefix

" " NVIM-Tree
" Plug 'kyazdani42/nvim-tree.lua'

" NERDTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }                    
Plug 'xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }            
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }

" Rust
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'

" Search-related
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'haya14busa/incsearch.vim'

" Sessions
Plug 'mhinz/vim-startify'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
" Plug 'SirVer/ultisnips'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'
" Plug 'honza/vim-snippets'

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

Plug 'akinsho/bufferline.nvim'
Plug 'vim-airline/vim-airline' " Adds status bar at bottom of panel
Plug 'vim-airline/vim-airline-themes'

" TMUX
Plug 'christoomey/vim-tmux-navigator'

" Wilder
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'nixprime/cpsm'
Plug 'romgrk/fzy-lua-native'

" Misc.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}       " We recommend updating the parsers on update
Plug 'tpope/vim-commentary'                                       " Used for commenting and uncommenting code
Plug 'svermeulen/vim-easyclip'
Plug 'machakann/vim-highlightedyank'                              " Highlights most recently yanked text
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'wincent/terminus'
Plug 'folke/twilight.nvim', { 'on': ['ZenMode', 'Twilight'] }     " Dims inactive portions of code automatically
Plug 'folke/zen-mode.nvim'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }

" Always leave devicons for last
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'ryanoasis/vim-devicons'
call plug#end()

"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"             SETTINGS
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
""""""""""""""""""""""""""""
"  Airline 
""""""""""""""""""""""""""""
let g:airline_theme='deus'
" let g:airline#extensions#tabline#enabled = 1

""""""""""""""""""""""""""""
"  Bufferline 
""""""""""""""""""""""""""""
set termguicolors
lua <<EOF
require('bufferline').setup {
  options = {
    close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
    right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
    -- NOTE: this plugin is designed with this icon in mind,
    -- and so changing this is NOT recommended, this is intended
    -- as an escape hatch for people who cannot bear it for whatever reason
    indicator_icon = '▎',
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    --- name_formatter can be used to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so use this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
    name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
      -- remove extension from markdown files for example
      if buf.name:match('index') then
        return vim.fn.fnamemodify(buf.name, 'git-status')
      end
      if buf.name:match('%.md') then
        return vim.fn.fnamemodify(buf.name, ':t:r')
      end
    end,
    offsets = {{filetype = "NvimTree", 
    text = "File Explorer",
    text_align = "left"}},
  }
}
EOF

"""""""""""""""""""""""""""""
"       Clang-Format        "
"""""""""""""""""""""""""""""
let g:clang_format##detect_style_file=1
let g:clang_format#code_style="llvm"
let g:clang_format#enable_fallback_style=1
" autocmd FileType c ClangFormatAutoEnable

""""""""""""""""""""""""""""
"       EasyClip           "
""""""""""""""""""""""""""""
let g:EasyClipUseSubstituteDefaults=1
let g:EasyClipUseCutDefaults=0

""""""""""""""""""""""""""""
"       FloatTerm          "
""""""""""""""""""""""""""""
" let g:floaterm_width=0.8
" let g:floaterm_height=0.8
lua<<EOF
vim.api.nvim_set_var("floaterm_width",.8)
vim.api.nvim_set_var("floaterm_height",.8)
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
"       IncSearch          "
""""""""""""""""""""""""""""
let g:incsearch#auto_nohlsearch=1

""""""""""""""""""""""""""""
"     LSP-Installer        "
""""""""""""""""""""""""""""
lua <<EOF
require("luasnip.loaders.from_vscode").lazy_load()
EOF

""""""""""""""""""""""""""""
"     LSP-Installer        "
""""""""""""""""""""""""""""
lua <<EOF
require("nvim-lsp-installer").setup({
    ensure_installed = { "rust_analyzer", "sumneko_lua" }, -- ensure these servers are always installed
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})
EOF

""""""""""""""""""""""""""""
"         Nvim-CMP         "
""""""""""""""""""""""""""""
set completeopt=menu,menuone,noselect
lua<<EOF
require('nvim-cmp')
EOF

""""""""""""""""""""""""""""
"      Nvim-LspConfig      "
""""""""""""""""""""""""""""
lua<<EOF
require('nvim-lspconfig')
EOF

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
  },
  extensions = {
    fzf_writer = {
        use_highlighter = true
    }
  }
}
EOF

""""""""""""""""""""""""""""
"        TreeSitter        "
""""""""""""""""""""""""""""
" Enable Treesitter highlighting
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust", "c", "go", "markdown", "toml", "yaml", "bash", "python", "html", "javascript"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
"         Vim-Sneak         "
"""""""""""""""""""""""""""""
highlight Sneak guifg=white guibg=orange ctermfg=black ctermbg=red

"""""""""""""""""""""""""""""
"         Wilder            "
"""""""""""""""""""""""""""""
call wilder#setup({'modes': [':', '/', '?']})

call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#python_file_finder_pipeline({
      \       'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
      \       'dir_command': ['fd', '-td'],
      \       'filters': ['cpsm_filter'],
      \     }),
      \     wilder#substitute_pipeline({
      \       'pipeline': wilder#python_search_pipeline({
      \         'skip_cmdtype_check': 1,
      \         'pattern': wilder#python_fuzzy_pattern({
      \           'start_at_boundary': 0,
      \         }),
      \       }),
      \     }),
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 2,
      \       'fuzzy_filter': has('nvim') ? wilder#lua_fzy_filter() : wilder#vim_fuzzy_filter(),
      \     }),
      \     [
      \       wilder#check({_, x -> empty(x)}),
      \       wilder#history(),
      \     ],
      \     wilder#python_search_pipeline({
      \       'pattern': wilder#python_fuzzy_pattern({
      \         'start_at_boundary': 0,
      \       }),
      \     }),
      \   ),
      \ ])

call wilder#set_option('renderer', wilder#wildmenu_renderer(
      \ wilder#wildmenu_airline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': ' · ',
      \ })))

let s:highlighters = [
      \ wilder#pcre2_highlighter(),
      \ has('nvim') ? wilder#lua_fzy_highlighter() : wilder#cpsm_highlighter(),
      \ ]

let s:popupmenu_renderer = wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'border': 'rounded',
      \ 'empty_message': wilder#popupmenu_empty_message_with_spinner(),
      \ 'highlighter': s:highlighters,
      \ 'left': [
      \   ' ',
      \   wilder#popupmenu_devicons(),
      \   wilder#popupmenu_buffer_flags({
      \     'flags': ' a + ',
      \     'icons': {'+': '???', 'a': '???', 'h': '???'},
      \   }),
      \ ],
      \ 'right': [
      \   ' ',
      \   wilder#popupmenu_scrollbar(),
      \ ],
      \ }))

let s:wildmenu_renderer = wilder#wildmenu_renderer({
      \ 'highlighter': s:highlighters,
      \ 'separator': ' ?? ',
      \ 'left': [' ', wilder#wildmenu_spinner(), ' '],
      \ 'right': [' ', wilder#wildmenu_index()],
      \ })

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': s:popupmenu_renderer,
      \ '/': s:wildmenu_renderer,
      \ 'substitute': s:wildmenu_renderer,
      \ }))

"""""""""""""""""""""""""""""
"       YouCompleteMe       "
"""""""""""""""""""""""""""""
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

""""""""""""""""""""""""""""
"         ZenMode          "
""""""""""""""""""""""""""""
lua << EOF
  require("zen-mode").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
hi ZenModeBg NONE

