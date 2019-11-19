scriptencoding utf-8
set hidden
set secure
set title " more meta info for window manager
set lazyredraw
set splitright
set nomodeline
set undolevels=1000
set ttimeout
set ttimeoutlen=20
set wildignorecase
set wildcharm=<C-z> " wildchar in macros
set magic " Use extended regular expressions
set mouse=nv
set wildmode=list:longest,full
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set shiftround
set ignorecase
set smartcase
set undofile
set backup
set noswapfile
set synmaxcol=200 " Large columns with syntax highlights slow things down
set cmdheight=2 " Reduce 'hit enter to continue' messages
set grepprg=rg\ --smart-case\ --vimgrep
set completeopt+=longest,noinsert,menuone,noselect
set completeopt-=preview
set complete-=t " let mucomplete handle searching for tags. Don't scan by default
set path-=/usr/include
set path+=**
set virtualedit=block
set conceallevel=2
set foldopen+=search
set updatetime=200
set inccommand=split
set wildoptions=pum
set diffopt+=hiddenoff
set diffopt+=iwhiteall
set diffopt+=algorithm:patience


" Cscope
set cscopetagorder=0
set cscopepathcomp=3
" Use the quickfix window for the cscope query
set cscopequickfix=s-,c-,d-,i-,t-,e-

cnoreabbrev csa cs add
cnoreabbrev csf cs find
cnoreabbrev csk cs kill
cnoreabbrev csr cs reset
cnoreabbrev css cs show
cnoreabbrev csh cs help

if !g:isWindows
  set shell=bash
endif

set formatoptions+=t
set formatlistpat=^\\s*                     " Optional leading whitespace
set formatlistpat+=[                        " Start character class
set formatlistpat+=\\[({]\\?                " |  Optionally match opening punctuation
set formatlistpat+=\\(                      " |  Start group
set formatlistpat+=[0-9]\\+                 " |  |  Numbers
set formatlistpat+=\\\|                     " |  |  or
set formatlistpat+=[a-zA-Z]\\+              " |  |  Letters
set formatlistpat+=\\)                      " |  End group
set formatlistpat+=[\\]:.)}                 " |  Closing punctuation
set formatlistpat+=]                        " End character class
set formatlistpat+=\\s\\+                   " One or more spaces
set formatlistpat+=\\\|                     " or
set formatlistpat+=^\\s*[-–+o*•]\\s\\+      " Bullet points

" BACKUPS:
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
" TODO add function to dive into previously ignored paths?
set wildignore+=*/dist*/*,*/target/*,*/builds/*,tags
set wildignore+=*/lib/*,*/locale/*,*/flow-typed/*,*/node_modules/*
set wildignore+=*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf,*.exe,*.o,*.obj,*.dll,*.DS_Store
set wildignore+=*.ttf,*.otf,*.woff,*.woff2,*.eot

" Common mistakes
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

" FUNCTIONS:
function! MarkMargin () abort
  if exists('b:MarkMargin')
    call matchadd('ErrorMsg', '\%>'.b:MarkMargin.'v\s*\zs\S', 0)
  endif
endfunction

function! SplashScreen() abort
  if line2byte('$') != -1 || argc() >= 1
    return
  else
    noautocmd enew
    silent! setlocal
          \ bufhidden=wipe
          \ colorcolumn=
          \ foldcolumn=0
          \ matchpairs=
          \ nobuflisted
          \ nocursorcolumn
          \ nocursorline
          \ nolist
          \ nonumber
          \ norelativenumber
          \ nospell
          \ noswapfile
          \ signcolumn=no

    silent! r ~/vim/skeletons/start.screen
    setlocal nomodifiable nomodified
  endif
endfunction

function s:remove_whitespace() abort
  if (g:remove_whitespace)
    %s/\s\+$//e " removes whitespace
  endif
endfunction

function! s:AS_HandleSwapfile (filename, swapname)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
    call delete(v:swapname)
    let v:swapchoice = 'e'
  endif
endfunction

augroup filebrowser
  autocmd!
  autocmd FileType netrw au BufLeave netrw close
augroup END

augroup core
  autocmd!
  autocmd VimEnter *  call SplashScreen()
  autocmd BufWritePre * call s:remove_whitespace()
  autocmd BufNewFile *.html 0r ~/vim/skeletons/skeleton.html
  autocmd BufNewFile *.tsx 0r ~/vim/skeletons/skeleton.tsx
  autocmd BufNewFile *.md 0r ~/vim/skeletons/skeleton.md
  autocmd WinNew * call sessions#saveSession()
  autocmd VimLeavePre * call sessions#saveSession()
  autocmd BufAdd * call tools#loadDeps()
  autocmd SessionLoadPost * call tools#loadDeps()
  autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
        \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif
  autocmd BufWritePre *
        \ if !isdirectory(expand("<afile>:p:h")) |
        \ call mkdir(expand("<afile>:p:h"), "p") |
        \ endif

  autocmd BufReadPost cscope.files
        \ let before_lines = line('$') |
        \ silent! exec 'silent! g/\(cscope\|node_modules\|build\/\|assets\/\|\.\(gif\|bmp\|png\|jpg\|swp\)\)/d' |
        \ silent! exec 'silent! v/\./d' |
        \ let before_lines = before_lines - line('$') |
        \ if before_lines > 0 |
        \   call confirm( 'Removed ' . before_lines . ' lines from file.  ' .
        \           'These were any of the following: ' .
        \           "\n".'- image and swap files ' .
        \           "\n".'- directories ' .
        \           "\n".'- any cscope files.' .
        \           "\n\n".'Press u to recover these lines.'
        \           ) |
        \ endif
augroup END

augroup AutoSwap
  autocmd!
  autocmd SwapExists *  call s:AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
augroup END

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested call tools#OpenQuickfix()
  autocmd VimEnter            * nested call tools#OpenQuickfix()
augroup END

augroup MarkMargin
  autocmd!
  autocmd  BufEnter  * :call MarkMargin()
augroup END

" Show changes that happen outside file
augroup checktime
  au!
  if !has('gui_running')
    autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
  endif
augroup END

" LSP
" runs out of mem on big projects
" call lsp#add_filetype_config({
"       \ 'filetype': ['typescript', 'typescriptreact', 'javascript', 'javascriptreact'],
"       \ 'name': 'ecma-server',
"       \ 'cmd': ['typescript-language-server', '--stdio']
"       \ })

call lsp#add_filetype_config({
      \ 'filetype': 'rust',
      \ 'name': 'rls',
      \ 'cmd': 'rls',
      \ 'capabilities': {
      \   'clippy_preference': 'on',
      \   'all_targets': v:false,
      \   'build_on_save': v:true,
      \   'wait_to_build': 0
      \ }})

