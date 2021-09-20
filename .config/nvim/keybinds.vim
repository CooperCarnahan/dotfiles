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

" Navigate buffers
noremap J :bprevious<cr>
noremap K :bnext<cr>

" Yanking
noremap Y y$

" Searching
" n always searches forwards"
noremap <expr> <SID>(search-forward) 'Nn'[v:searchforward]  
"N always searches backwards
noremap <expr> <SID>(search-backward) 'nN'[v:searchforward] 

" Tags
nmap gd <C-]>

" Jump to previous jump location and center
nmap '' ''zz
nmap <C-O> <C-o>zz
nmap <C-i> <C-i>zz
" Search moves to middle of screen and unfolds
" nmap n <SID>(search-forward)zzzv     
" xmap n <SID>(search-forward)zzzv

" nmap N <SID>(search-backward)zzzv
" xmap N <SID>(search-backward)zzzv

""""""""""""""""""""""""""""
" Navigate splits using <Ctrl + j,k,l,h>
""""""""""""""""""""""""""""
nnoremap <leader>s :split<cr>
nnoremap <leader>v :vsplit<cr>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"" Delete buffer
nnoremap <leader>w :Sayonara!<CR>

""""""""""""""""""""""""""""
" EasyClip Keybinds
""""""""""""""""""""""""""""
nmap x <Plug>MoveMotionPlug
xmap x <Plug>MoveMotionXPlug
nmap xx <Plug>MoveMotionLinePlug

""""""""""""""""""""""""""""
" Fugitive
""""""""""""""""""""""""""""
nmap <leader>gs :Git<cr>
nmap <leader>gh :diffget //2<cr>
nmap <leader>gl :diffget //3<cr>
nmap <leader>gd :Gdiffsplit!<cr>
nmap <leader>gc :G commit<cr>
nmap <leader>ga :Neoformat <bar> Gwrite<cr>
nmap <C-g>      :Git<cr>
nmap <leader>glog :Commits<cr>

""""""""""""""""""""""""""""
" FZF Keybinds
""""""""""""""""""""""""""""
nmap <C-f> :Rg 
nmap <C-b> :Buffers<cr>
nmap <C-p> :Files<cr>
nmap <C-c> :Commits<cr>
" nmap <C-t> :Tags<cr>
"
""""""""""""""""""""""""""""
" Incsearch Keybinds
""""""""""""""""""""""""""""
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz

""""""""""""""""""""""""""""
" Neoformat Keybinds
""""""""""""""""""""""""""""
nmap <leader>f :Neoformat<CR>

""""""""""""""""""""""""""""
" NerdTree Keybinds
""""""""""""""""""""""""""""
nnoremap <C-e> :NERDTree<CR>

""""""""""""""""""""""""""""
" NvimTree Keybinds
""""""""""""""""""""""""""""
" nnoremap <C-e> :NvimTreeToggle<CR>

""""""""""""""""""""""""""""
" Tagbar
""""""""""""""""""""""""""""
nnoremap <C-t> :Tagbar<CR>

""""""""""""""""""""""""""""
" Telescope Keybinds
""""""""""""""""""""""""""""
"Like Ctrl+p command in VSCode
" nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
"Like Ctrl+Shift+F command in VSCode
" nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" Shows only files that have been opened thus far
" nnoremap <C-b> <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" Shows files in order of how recently they were opened
nnoremap <leader>fr <cmd>lua require('telescope.builtin').oldfiles()<cr>
" Shows all marks
nnoremap m/ <cmd>lua require('telescope.builtin').marks()<cr>
nnoremap <leader>fm <cmd>lua require('telescope.builtin').marks()<cr>
" Shows all tags
" nnoremap <C-t> <cmd>lua require('telescope.builtin').tags()<cr>
" nnoremap <leader>ft <cmd>lua require('telescope.builtin').tags()<cr>

""""""""""""""""""""""""""""
" Terminal
""""""""""""""""""""""""""""
map <Leader>t :terminal<cr>
tnoremap <Esc> <C-\><C-n>

""""""""""""""""""""""""""""
" Vim-Commentary Keybinds
""""""""""""""""""""""""""""
" Actual maps Ctrl + / to comment out lines
nnoremap <C-_> :Commentary<cr>
" Toggle comment in visual mode and reopen highlight
vnoremap <C-_> :Commentary<cr>gv

""""""""""""""""""""""""""""
" Vim-Signature Keybinds
""""""""""""""""""""""""""""
let g:SignatureMap = {
  \ 'Leader'             :  "m",
  \ 'PlaceNextMark'      :  "m,",
  \ 'ToggleMarkAtLine'   :  "m.",
  \ 'PurgeMarksAtLine'   :  "m-",
  \ 'DeleteMark'         :  "dm",
  \ 'PurgeMarks'         :  "m<Space>",
  \ 'PurgeMarkers'       :  "m<BS>",
  \ 'GotoNextLineAlpha'  :  "']",
  \ 'GotoPrevLineAlpha'  :  "'[",
  \ 'GotoNextSpotAlpha'  :  "`]",
  \ 'GotoPrevSpotAlpha'  :  "`[",
  \ 'GotoNextLineByPos'  :  "]'",
  \ 'GotoPrevLineByPos'  :  "['",
  \ 'GotoNextSpotByPos'  :  "]`",
  \ 'GotoPrevSpotByPos'  :  "gpm",
  \ 'GotoNextMarker'     :  "gnm",
  \ 'GotoPrevMarker'     :  "gpm",
  \ 'GotoNextMarkerAny'  :  "]=",
  \ 'GotoPrevMarkerAny'  :  "[=",
  \ 'ListBufferMarkers'  :  "m?"
  \ }

""""""""""""""""""""""""""""
" Vim-Sneak Keybinds
""""""""""""""""""""""""""""
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S
