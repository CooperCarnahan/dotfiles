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
