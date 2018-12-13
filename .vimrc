" Configuration file for vim
set modelines=0		" CVE-2007-2438

filetype plugin on

" RustFmt
let g:rustfmt_command = 'rustfmt'
noremap qq :RustFmt<cr>


set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set number
set title
set hlsearch
set ambiwidth=double
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set listchars=tab:--,trail:-,extends:»,precedes:«,nbsp:%  "When I want to see these chars, do `set list`
set hidden
set history=50
set virtualedit=block
" set whichwrap=b,s,[,],<,>
set backspace=indent,eol,start
set wildmenu
set foldmethod=marker
set foldtext=getline(v:foldstart)


" Key Mapping
noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $
noremap == gg=G''
noremap <C-j> <ESC>
inoremap <C-j> <ESC>

syntax on
colorscheme molokai
set t_Co=256

highlight Normal ctermbg=none

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup
