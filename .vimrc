set encoding=utf-8

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set laststatus=2
set mouse=a " mouse & xterm interaction
set showcmd " show command as its typed

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


:command Z colorscheme zaibatsu
:command E colorscheme elflord
:command H colorscheme habamax


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
:autocmd InsertEnter * colorscheme industry
:autocmd InsertLeave * colorscheme zaibatsu

augroup Config
autocmd!
" autoreload vimrc
autocmd BufWritePre * call StripWhitespace()
autocmd BufWritePost *.vimrc source ~/.vimrc
augroup END

:command FF CocCommand prettier.formatFile

function! ColorPicker()
    let selected = expand("<cword>")
    let is_color = matchstr(selected, '\v[a-fA-F0-9]{6}')
    if empty(is_color)
        echomsg "Not a color"
        return
    endif
    let output = system("zenity --color-selection --color=#" . selected . " 2>/dev/null")
    let converted = trim(ConvertRgbToHex(output))
    if len(converted) == 6
        execute "normal! ciw" . converted
        stopinsert
    else
        echo "No color received"
    endif
endfunction

function! ConvertRgbToHex(str)
    " echomsg "ConvertRbgToHex running against " . a:string
    let pat = '\vrgb\((\d+),(\d+),(\d+)\)'
    return substitute(a:str, pat, '\=printf("%02x%02x%02x",(submatch(1)),submatch(2),submatch(3))', 'g')
endfunction

:command C call ColorPicker()

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
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


"" Make <CR> to accept selected completion item or notify coc.nvim to format
" modified to <C-CR>

"" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <C-CR> coc#pum#visible() ? coc#pum#confirm()
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


" help normal-index to see that normally Ctrl+N is j, Ctrl+P is k
let g:colors = getcompletion('', 'color')
func! NextColorscheme()
    let idx = index(g:colors, g:colors_name)
    return (idx + 1 >= len(g:colors) ? g:colors[0] : g:colors[idx + 1])
endfunction
func! PreviousColorscheme()
    let idx = index(g:colors, g:colors_name)
    return (idx - 1 < 0 ? g:colors[-1] : g:colors[idx - 1])
endfunction
nnoremap <C-n> :exe "colo " .. NextColorscheme()<CR>
nnoremap <C-p> :exe "colo " .. PreviousColorscheme()<CR>
autocmd! ColorScheme *
autocmd ColorScheme * echo g:colors_name

if has('nvim')
    set viminfo+=n$HOME/.vim/nviminfo
else
    set viminfo+=n$HOME/.vim/viminfo
endif

Z
