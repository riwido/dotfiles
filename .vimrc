let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()


inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

augroup Config
autocmd!
autocmd BufWritePost *vimrc source ~/.vimrc " autoreload vimrc
augroup END

