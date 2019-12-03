scriptencoding utf-8

cnoreabbrev csa cs add
cnoreabbrev csf cs find
cnoreabbrev csk cs kill
cnoreabbrev csr cs reset
cnoreabbrev css cs show
cnoreabbrev csh cs help

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

function! s:AS_HandleSwapfile (filename, swapname)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
    call delete(v:swapname)
    let v:swapchoice = 'e'
  endif
endfunction

augroup core
  autocmd!
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

" Show changes that happen outside file
augroup checktime
  au!
  if !has('gui_running')
    autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
  endif
augroup END

