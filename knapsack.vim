" MINIMAL VIMRC, focused on portability
if executable('rg')
  set grepprg=rg\ --smart-case\ --vimgrep
else if executable('ag')
  set grepprg=ag\ --vimgrep
endif

set path+=**
set path-=/usr/include
set wildignore+=*/lib/*,*/locale/*,*/flow-typed/*,*/node_modules/*
set wildignore+=*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf,*.exe,*.o,*.obj,*.dll,*.DS_Store
set wildignore+=*.ttf,*.otf,*.woff,*.woff2,*.eot
set autoindent
set incsearch
set tabstop=2
set expandtab
set shiftround
set ignorecase
set smartcase
syntax enable
set completeopt+=longest,noinsert,menuone,noselect
set completeopt-=preview
filetype plugin indent on
set formatoptions-=o " Don't insert comment lines when pressing o in normal mode
set autoread  " Automatically read a file changed outside of vim
set complete-=i
set belloff=all
set wildmenu
set backspace=indent,eol,start "better backspace behavior
set hlsearch
set smarttab
set history=10000
set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
set background=dark
set laststatus=2
set guifont=IBM\ Plex\ Mono

iabbrev retrun  return
iabbrev pritn   print
iabbrev cosnt   const
iabbrev imoprt  import
iabbrev imprt   import
iabbrev iomprt  import
iabbrev improt  import
iabbrev slef    self
iabbrev teh     the
iabbrev hadnler handler
iabbrev bunlde  bundle

filetype plugin indent on

augroup ECMA
  autocmd FileType typescript,typescript.tsx,typescript.jsx,javascript,javascript.jsx suffixesadd+=.js,.jsx,.ts,.tsx " navigate to imported files by adding the js(x) suffix
  autocmd FileType typescript,typescript.tsx,typescript.jsx,javascript,javascript.jsx setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\)
  autocmd FileType typescript,typescript.tsx,typescript.jsx,javascript,javascript.jsx setlocal define=class\\s
  autocmd FileType typescript,typescript.tsx,typescript.jsx,javascript,javascript.jsx inoremap <C-l> console.log()<esc>i
  autocmd FileType typescript,typescript.tsx,typescript.jsx,javascript,javascript.jsx inoremap <C-c> console.log(`%c${}`, 'color: ;')<esc>F{a
  autocmd FileType typescript,typescript.tsx,typescript.jsx,javascript,javascript.jsx inoremap d<C-l> debugger
  autocmd FileType typescript,typescript.tsx,typescript.jsx,javascript,javascript.jsx nnoremap <leader>i biimport {<esc>ea} from ''<esc>i
augroup END

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" MAPS:
let g:mapleader = "\<Space>"
imap jj <Esc>

if exists(':tnoremap')
  tnoremap <C-\> <C-\><C-n>
endif

nnoremap <silent> [q :cnext<CR>
nnoremap <silent> ]q :cprev<CR>
nnoremap <silent> [Q :cnfile<CR>
nnoremap <silent> ]Q :cpfile<CR>

nnoremap ; :
nnoremap : ;

" Blocks:
vnoremap <silent><up>    :m '<-2<cr>gv=gv
vnoremap <silent><down>  :m '>+1<cr>gv=gv
nnoremap <silent><up>    :m .-2<cr>==
nnoremap <silent><down>  :m .+1<cr>==

nnoremap , :find<space>
nnoremap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>

nnoremap <silent><C-J> :call WinMove('j')<cr>
nnoremap <silent><C-L> :call WinMove('l')<cr>
nnoremap <silent><C-H> :call WinMove('h')<cr>
nnoremap <silent><C-K> :call WinMove('k')<cr>
nnoremap <silent> wq :close<CR>

" System Clipboard:
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
" Don't trash current register when pasting in visual mode
xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>

" Move in given direction or create new split
function! WinMove(key) abort
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction


" COMMANDS:
command! -nargs=+ -complete=file_in_path -bar Grep  let a = split(<q-args>, ' ')
      \ | cgetexpr system(join([&grepprg, shellescape(a[0]), get(a, 1, '')], ' '))
      \ | unlet a
