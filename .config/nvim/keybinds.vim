" This file is made to hold all keyboard mappings
" **NOTE: Should be sourced first in vimrc/init

""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""
" !!!MUST BE BEFORE ANY KEYBINDS THAT USE LEADER
nnoremap <SPACE> <Nop>
let mapleader=" "

" Remap <Esc> keys
imap jj <Esc>
imap jk <Esc>

" Edit/source vimrc
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>es :source $MYVIMRC<CR>
nnoremap <leader>er :split $MYVIMRC<CR>

" Edit movement keys
noremap H ^
noremap L $

" Searching
" n always searches forwards"
noremap <expr> <SID>(search-forward) 'Nn'[v:searchforward]  
"N always searches backwards
noremap <expr> <SID>(search-backward) 'nN'[v:searchforward] 

" Search moves to middle of screen and unfolds
" nmap n <SID>(search-forward)zzzv     
" xmap n <SID>(search-forward)zzzv

" nmap N <SID>(search-backward)zzzv
" xmap N <SID>(search-backward)zzzv

""""""""""""""""""""""""""""
" Navigate splits using <Ctrl + j,k,l,h>
""""""""""""""""""""""""""""
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nnoremap <leader>w :q<CR>

""""""""""""""""""""""""""""
" NERDTree Keybinds
""""""""""""""""""""""""""""
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <leader>ntt :NERDTreeToggle<CR>

""""""""""""""""""""""""""""
" Vim-Sneak Keybinds
""""""""""""""""""""""""""""
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S

""""""""""""""""""""""""""""
" Telescope Keybinds
""""""""""""""""""""""""""""
nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>

nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>

nnoremap <C-b> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>

nnoremap <leader>fr <cmd>lua require('telescope.builtin').oldfiles()<cr>

""""""""""""""""""""""""""""
" Vim-Commentary Keybinds
""""""""""""""""""""""""""""
" Actual maps Ctrl + / to comment out lines
nnoremap <C-_> :Commentary<cr>
" Toggle comment in visual mode and reopen highlight
vnoremap <C-_> :Commentary<cr>gv

""""""""""""""""""""""""""""
" Vim-Bookmark Keybinds
""""""""""""""""""""""""""""
" noremap  <leader><leader> :BookmarkToggle<cr>
" noremap  gn :BookmarkNext<cr>
" noremap  gp :BookmarkPrev<cr>

""""""""""""""""""""""""""""
" Incsearch Keybinds
""""""""""""""""""""""""""""
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz
