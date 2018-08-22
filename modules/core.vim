scriptencoding utf-8
syntax enable
set hidden
filetype plugin indent on
set autoindent
set autoread  " Automatically read a file changed outside of vim
set undolevels=1000
set wildignorecase
set mouse=nv
set wildmode=list:longest,full " gives tab completion lists in ex command area
set shiftwidth=2 " indent code with two spaces
set softtabstop=2 " tabs take two spaces
set tabstop=2
set expandtab " replace tabs with spaces
set smarttab " pressing tab key in insert mode insert spaces
set shiftround " round indent to multiples of shiftwidth
set linebreak " do not break words.
set backspace=indent,eol,start
set completeopt+=preview,longest,noinsert,menuone,noselect
set omnifunc=syntaxcomplete#Complete
augroup core
  autocmd!
  if has('nvim')
    autocmd BufWritePre * :set ff=unix
  endif

  au GUIEnter * set vb t_vb=
  " removes whitespace
  autocmd BufWritePre * %s/\s\+$//e
augroup END
" if has('pythonx')
"   set pythonxversion=3
" else
"   set pythonxversion=2
" endif
let g:data_dir = $HOME . '/.cache/Vim/'
let g:backup_dir = g:data_dir . 'backup'
let g:swap_dir = g:data_dir . 'swap'
let g:undo_dir = g:data_dir . 'undofile'
let g:conf_dir = g:data_dir . 'conf'
if finddir(g:data_dir) ==# ''
  silent call mkdir(g:data_dir, 'p', 0700)
endif
if finddir(g:backup_dir) ==# ''
  silent call mkdir(g:backup_dir, 'p', 0700)
endif
if finddir(g:swap_dir) ==# ''
  silent call mkdir(g:swap_dir, 'p', 0700)
endif
if finddir(g:undo_dir) ==# ''
  silent call mkdir(g:undo_dir, 'p', 0700)
endif
if finddir(g:conf_dir) ==# ''
  silent call mkdir(g:conf_dir, 'p', 0700)
endif
unlet g:data_dir
unlet g:backup_dir
unlet g:swap_dir
unlet g:undo_dir
unlet g:conf_dir
set undodir=$HOME/.cache/Vim/undofile
set backupdir=$HOME/.cache/Vim/backup
set directory=$HOME/.cache/Vim/swap
set noerrorbells vb t_vb=
if has('gui_running')
  " GUI is running or is about to start.
  set lines=50 columns=300
endif
"" Ignore dist and build folders
set wildignore+=*/dist*/**,*/target/**,*/build*/**
" Ignore libs
set wildignore+=*/lib/**,*/node_modules/**,*/bower_components/**,*/locale/**
" Ignore images, pdfs, and font files
set wildignore+=*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf
set wildignore+=*.ttf,*.otf,*.woff,*.woff2,*.eot
