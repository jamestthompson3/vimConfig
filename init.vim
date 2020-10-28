scriptencoding utf-8
set fileencoding=utf8

" Disable some default vim plugins:
let loaded_matchit = 1

" vim globals
let mapleader = "\<Space>"
colorscheme ghost_mono

" Load Custom Modules:
lua << EOF
require('mappings')
require('init')
-- require('ui') TODO figure out colors that work w/ treesitter
EOF

" TODO move to lua
let g:pear_tree_pairs = {
      \   '(': {'closer': ')'},
      \   '[': {'closer': ']'},
      \   '{': {'closer': '}'},
      \   "'": {'closer': "'"},
      \   '"': {'closer': '"'},
      \   '`': {'closer': '`'},
      \   '/\*': {'closer': '\*/'}
      \ }



function! s:AS_HandleSwapfile (filename, swapname)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
    call delete(v:swapname)
    let v:swapchoice = 'e'
  endif
endfunction

augroup core
  autocmd!
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
