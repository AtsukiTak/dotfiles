" Configuration file for vim
set modelines=0		" CVE-2007-2438

syntax on
filetype plugin indent on

set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set number
set title
set hlsearch
set ambiwidth=double
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set listchars=tab:--,trail:-,extends:»,precedes:«,nbsp:%  "When I want to see these chars, do `set list`
set hidden
set history=50
set virtualedit=block
set backspace=indent,eol,start
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

colorscheme molokai
set t_Co=256

highlight Normal ctermbg=none

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup


"" Plugin Manager

function! s:load_rust()
  let g:rustfmt_autosave = 1
  noremap qq :RustFmt<CR>
  noremap qc :Cargo check<CR>
endfunction

function! s:load_js()
  packadd vim-prettier
  noremap qq :Prettier<CR>
endfunction

function! s:load_ts()
  packadd vim-prettier
  noremap qq :Prettier<CR>
endfunction

augroup load_plugins
  autocmd!
  autocmd FileType rust call s:load_rust()
  autocmd FileType javascript call s:load_js()
  autocmd BufNewFile,BufRead *.tsx,*.ts call s:load_ts()
augroup END
