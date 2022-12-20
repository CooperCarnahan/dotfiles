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
Plug 'haya14busa/incsearch.vim'
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

" Wilder
function! UpdateRemotePlugins(...)
  " Needed to refresh runtime files
  let &rtp=&rtp
  UpdateRemotePlugins
endfunction

Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
Plug 'nixprime/cpsm'
Plug 'romgrk/fzy-lua-native'

" Misc.
Plug 'tpope/vim-commentary'                                       " Used for commenting and uncommenting code
Plug 'svermeulen/vim-easyclip'
Plug 'machakann/vim-highlightedyank'                              " Highlights most recently yanked text
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'wincent/terminus'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'karb94/neoscroll.nvim'

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
"       IncSearch          "
""""""""""""""""""""""""""""
lua require('leap').add_default_mappings()

""""""""""""""""""""""""""""
"       LuaLine            "
""""""""""""""""""""""""""""
lua <<EOF
require('lualine').setup({
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    winbar = {
      lualine_a = {
      },
      lualine_b = {
        {
          'filetype',
          colored = true,   -- Displays filetype icon in color if set to true
          icon_only = true, -- Display only an icon for filetype
          icon = { align = 'right' }, -- Display filetype icon on the right hand side
        }
      },
      lualine_c = {
        {
          'filename', 
          path=3,
          symbols = {
            modified = ' ●',-- Text to show when the buffer is modified
            alternate_file = '#', -- Text to show to identify the alternate file
            directory =  '',     -- Text to show when the buffer is a directory
          }
        }
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    }
})

EOF

""""""""""""""""""""""""""""
"       LuaSnip            "
""""""""""""""""""""""""""""
lua require("luasnip.loaders.from_vscode").lazy_load()

""""""""""""""""""""""""""""
"     LSP-Installer        "
""""""""""""""""""""""""""""
lua <<EOF
require("nvim-lsp-installer").setup({
    ensure_installed = { "clangd", "rust_analyzer", "sumneko_lua" }, -- ensure these servers are always installed
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
"     LSP-Saga             "
""""""""""""""""""""""""""""
lua <<EOF
local keymap = vim.keymap.set
local saga = require('lspsaga')

saga.init_lsp_saga({
  show_outline = {
  win_position = 'right',
  --set special filetype win that outline window split.like NvimTree neotree
  -- defx, db_ui
  win_with = ' ',
  win_width = 50,
  auto_enter = true,
  auto_preview = true,
  virt_text = '┃',
  jump_key = '<CR>',
  -- auto refresh when change buffer
  auto_refresh = true,
  },
})

-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

-- Diagnostic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>",{ silent = true })

-- Hover Doc
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })

-- if you want to pass some cli command into a terminal you can do it like this
-- open lazygit in lspsaga float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- close floaterm
keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })

EOF

""""""""""""""""""""""""""""
"         Neoscroll        "
""""""""""""""""""""""""""""
"lua <<EOF
"require('neoscroll').setup({
"    -- All these keys will be mapped to their corresponding default scrolling animation
"    mappings = {'<C-u>', '<C-d>', '<C-b>',
"                '<C-y>', 'zt', 'zz', 'zb'},
"    hide_cursor = true,          -- Hide cursor while scrolling
"    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
"    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
"    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
"    easing_function = nil,       -- Default easing function
"    pre_hook = nil,              -- Function to run before the scrolling animation starts
"    post_hook = nil,             -- Function to run after the scrolling animation ends
"    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
"})
"EOF

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

