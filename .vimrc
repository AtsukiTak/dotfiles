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

" Makefile.tomlを開いた時にmakeではなくtomlとして認識するようにする
autocmd BufNewFile,BufRead Makefile.toml set filetype=toml


"" Plugin Manager

" 「%」key で、対応する tag にジャンプするプラグイン
packadd matchit

let g:polyglot_disabled = ['coffee-script']

function! s:load_vim_lsp()
  packadd vim-lsp
  au User lsp_setup call lsp#register_server({
    \ 'name': 'rust-analyzer',
    \ 'cmd': {server_info->['rust-analyzer']},
    \ 'allowlist': ['rust'],
    \ })
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  let g:lsp_signs_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gpd <plug>(lsp-peek-definition)
  nmap <buffer> K <plug>(lsp-hover)
  nmap J :LspDocumentDiagnostics<CR>
endfunction

function! s:load_rust()
  let g:rustfmt_autosave = 1
  noremap qq :RustFmt<CR>
  noremap qc :Cargo check<CR>
  call s:load_vim_lsp()
endfunction

function! s:load_js()
  packadd vim-prettier
  noremap qq :PrettierAsync<CR>
endfunction

function! s:load_ts()
  packadd vim-prettier
  noremap qq :PrettierAsync<CR>
endfunction

function! s:load_vue()
  packadd vim-prettier
  noremap qq :PrettierAsync<CR>
endfunction

function! s:load_html()
  packadd vim-prettier
  noremap qq :PrettierAsync<CR>
endfunction

function! s:load_python()
  noremap qq :0,$!yapf<CR>
endfunction

augroup load_plugins
  autocmd!
  autocmd FileType rust call s:load_rust()
  autocmd FileType javascript call s:load_js()
  autocmd BufNewFile,BufRead *.tsx,*.ts call s:load_ts()
  autocmd BufNewFile,BufRead *.vue call s:load_vue()
  autocmd FileType html call s:load_html()
  autocmd FileType python call s:load_python()
augroup END
