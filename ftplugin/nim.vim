fun! JumpToDef()
  if exists('*GotoDefinition_' . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

let b:MarkMargin = 80

" Jump to tag
nnoremap <silent>gd :call JumpToDef()<cr>
inoremap <silent><M-g> <esc>:call JumpToDef()<cr>i
