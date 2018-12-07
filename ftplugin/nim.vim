fun! JumpToDef()
  if exists('*GotoDefinition_' . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

let b:MarkMargin = 80

compiler nim

function! CompileNim(threads) abort
  let l:filename = expand('%:t')
  if a:threads == 1
    exec printf(":!nim c -r --threads:on %s", l:filename)
  else
    exec printf(":!nim c -r %s", l:filename)
endfunction
command! -nargs=1 CompileNim call CompileNim(<q-args>)
" Jump to tag
nnoremap <silent>gd :call JumpToDef()<cr>
inoremap <silent><M-g> <esc>:call JumpToDef()<cr>i
nnoremap <silent>rcf CompileNim
