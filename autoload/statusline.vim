scriptencoding utf-8

function! statusline#LinterStatus() abort
  if !exists('g:loaded_ale')
    return ' '
  else
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:warning = l:counts.warning
    let l:error = l:counts.error
    if l:all_errors + l:counts.warning == 0
      return '✓'
    else
      return printf(
            \   '%d W %d E',
            \   l:warning,
            \   l:error
            \) . ' '
    endif
  endif
endfunction

function! statusline#ReadOnly() abort
  if &readonly || !&modifiable
    return '-- RO --'
  else
    return ''
  endif
endfunction

function! statusline#FileType() abort
  let l:currFile = expand('%:t')
  let l:extension = expand('%:e')
  if l:extension == ''
    return ''
  endif
  return l:currFile
endfunction
