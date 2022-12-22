""""""""""""""""""""""""""""""
" => Load vim-plug paths
""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugins')

Plug 'lewis6991/impatient.nvim'

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

" NVIM-Tree
" Plug 'kyazdani42/nvim-tree.lua'

" NERDTree
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }                    
" Plug 'xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }            
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }

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

" TMUX
Plug 'christoomey/vim-tmux-navigator'

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
"lua <<EOF
"require('bufferline').setup {
"  options = {
"    close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
"    right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
"    left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
"    middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
"    -- NOTE: this plugin is designed with this icon in mind,
"    -- and so changing this is NOT recommended, this is intended
"    -- as an escape hatch for people who cannot bear it for whatever reason
"    indicator = '▎',
"    buffer_close_icon = '',
"    modified_icon = '●',
"    close_icon = '',
"    left_trunc_marker = '',
"    right_trunc_marker = '',
"    --- name_formatter can be used to change the buffer's label in the bufferline.
"    --- Please note some names can/will break the
"    --- bufferline so use this at your discretion knowing that it has
"    --- some limitations that will *NOT* be fixed.
"    name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
"      -- remove extension from markdown files for example
"      if buf.name:match('index') then
"        return vim.fn.fnamemodify(buf.name, 'git-status')
"      end
"      if buf.name:match('%.md') then
"        return vim.fn.fnamemodify(buf.name, ':t:r')
"      end
"    end,
"    offsets = {{filetype = "NvimTree", 
"    text = "File Explorer",
"    text_align = "left"}},
"  }
"}
"EOF

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
  ensure_installed = {"rust", "c", "cpp", "go", "markdown", "toml", "yaml", "bash", "python", "html", "javascript"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
   incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.outer",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        ["]a"] = "@parameter.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
        ["]A"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[a"] = "@parameter.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[]"] = "@class.outer",
        ["[A"] = "@parameter.outer",
      },
    },
  },
}

-- Enable treesitter-context plugin
require'treesitter-context'.setup()

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
"       YouCompleteMe       "
"""""""""""""""""""""""""""""
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

