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
    hi User3 guifg=#c9505c guibg=#191f26 gui=BOLD
    if g:isWindows
      return '-- RO --'
    else
      return ''
    endif
  else
    return ''
  endif
endfunction

function! statusline#StatuslineGit()
  return tools#gitCommand()
endfunction
