set runtimepath+=~/.vim_runtime

" Import vim runtime sources
source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/vimrcs/my_configs.vim
catch
endtry

set termguicolors
