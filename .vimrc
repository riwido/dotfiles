" install https://github.com/junegunn/vim-plug if it isn't there
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugin list
call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()

" use enter to use autocomplete option
" inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

" auto commands
augroup Config
autocmd!
autocmd BufWritePost *vimrc source ~/.vimrc " autoreload vimrc
augroup END

" todo: disable autocomplete for non code files

