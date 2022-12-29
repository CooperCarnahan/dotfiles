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
if exists('g:vscode')
    " VSCode extension
else
  " nmap gd <Plug>(coc-definition)
  nmap gr <Plug>(coc-references)
  " vmap ]f <Plug>(coc-format-selected)
endif

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
" FloatTerm
""""""""""""""""""""""""""""
nnoremap <leader>lg :FloatermNew --cwd=<buffer> lazygit<cr>
tmap <ESC> <C-\><C-n>

""""""""""""""""""""""""""""
" Fugitive
""""""""""""""""""""""""""""
" nmap <leader>gs :Git<cr>
" nmap <leader>gh :diffget //2<cr>
" nmap <leader>gl :diffget //3<cr>
" nmap <leader>gd :Gdiffsplit!<cr>
" nmap <leader>gc :G commit<cr>
" nmap <leader>ga :Neoformat <bar> Gwrite<cr>
" nmap <C-g>      :Git<cr>
" nmap <leader>glog :Commits<cr>

""""""""""""""""""""""""""""
" FZF Keybinds
""""""""""""""""""""""""""""

""""""""""""""""""""""""""""
" Neoformat Keybinds
""""""""""""""""""""""""""""
nmap <leader>f :Neoformat<CR>

""""""""""""""""""""""""""""
" NERDTree Keybinds
""""""""""""""""""""""""""""
" nnoremap <C-e> :NERDTreeToggle<CR>      
" nnoremap <leader>ntt :NERDTreeToggle<CR>

""""""""""""""""""""""""""""
" NvimTree Keybinds
""""""""""""""""""""""""""""
" nnoremap <C-e> :NvimTreeToggle<CR>

""""""""""""""""""""""""""""
" Tagbar
""""""""""""""""""""""""""""
nnoremap <leader>t :Tagbar<CR>

""""""""""""""""""""""""""""
" Terminal
""""""""""""""""""""""""""""
" map <Leader>t :terminal<cr>
tnoremap <Esc> <C-\><C-n>

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
