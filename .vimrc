set encoding=utf-8

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set laststatus=2
set mouse=a " mouse & xterm interaction
set showcmd " show command as its typed

set wildmode=list,longest

function OpenHelpAsOnly()
    let buftype = getbufvar(bufnr('%'), '&buftype', v:null)
    if buftype == "help"
        execute ":only"
    endif
endfunction
autocmd BufEnter * call OpenHelpAsOnly()

function SendMsg(msg)
    echo a:msg
endfunction

map <S-Up> :call SendMsg('You pressed Shift Up.  Stop it')<C-CR>
map <S-Down> :call SendMsg('You pressed Shift Down.  Stop it')<C-CR>

" install https://github.com/junegunn/vim-plug if it isn't there
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" this .venv should be created in .bash_profile
if has('nvim')
    let g:python3_host_prog = $HOME . '/.vim/.venv/bin/python'
endif

" plugin list
call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'airblade/vim-gitgutter'
"Plug 'DougBeney/pickachu'
Plug 'psf/black', { 'branch': 'stable' }
"Plug 'drewtempelmeyer/palenight.vim'
"Plug 'guns/xterm-color-table.vim'
call plug#end()

let g:coc_global_extensions = [
   \'coc-css',
   \'coc-eslint',
   \'coc-json',
   \'coc-prettier',
   \'coc-pyright',
   \'coc-rust-analyzer',
   \'coc-stylelint',
   \'coc-tsserver',
   \'coc-vimlsp'
   \]

" auto commands
:autocmd InsertEnter * set cursorline
:autocmd InsertLeave * set nocursorline
augroup Config


autocmd!
" autoreload vimrc
autocmd BufWritePre * call StripWhitespace()
autocmd BufWritePost *.vimrc source ~/.vimrc
augroup END

:command FF CocCommand prettier.formatFile

function! StripWhitespace()
    "if &ft == 'markdown'
    "    return
    "endif
    let pos = getcurpos()
    %s#\s\+$##e " EOL
    %s#\($\n\s*\)\+\%$##e " EOF
    call setpos('.', pos)
endfunction
"
"" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
"" delays and poor user experience
set updatetime=300
"
"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved
set signcolumn=yes
"
"" Use tab for trigger completion with characters ahead and navigate
"" NOTE: There's always complete item selected by default, you may want to enable
"" no select by `"suggest.noselect": true` in your configuration file
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#insert() :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


"" Make <CR> to accept selected completion item or notify coc.nvim to format
" modified to <C-CR>

"" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <C-CR> coc#pum#visible() ? coc#pum#insert()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
"
"" Use `[g` and `]g` to navigate diagnostics
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
"

if has('nvim')
    set viminfo+=n$HOME/.vim/nviminfo
else
    set viminfo+=n$HOME/.vim/viminfo
endif

colorscheme zaibatsu

" from Kirjava, \gb to get blame for higlighted line
vnoremap <Leader>gb :<C-U>tabnew \|r!cd <C-R>=expand("%:p:h")<CR> && git annotate -L<C-R>=line("'<")<CR>,<C-R>=line("'>") <CR> <C-R>=expand("%:t") <CR><CR>

nnoremap <Leader>c ggVG"+y<C-o>

func! GetAsmIndentCustom()
    let line = getline(v:lnum)
    let ind = shiftwidth() + 4
    if line =~ '^\s*\k\+:' || line =~ '^\s*;'
        let ind = 0
    endif
    return ind
endfunction

autocmd FileType asm setlocal indentexpr=GetAsmIndentCustom()
" autocmd FileType asm setlocal indentkeys=<:>,;,!^F,o,O
autocmd FileType asm setlocal indentkeys=

" :redir! > vim_keys.txt
" :silent verbose map
" :redir END

" disable the incredibly annoying auto comment in a new line
set formatoptions=
