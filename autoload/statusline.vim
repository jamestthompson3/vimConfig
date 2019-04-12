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

function! statusline#GetScope() abort
  let l:scope = get(b:, 'vista_nearest_method_or_function', '')
  echom l:scope
  return l:scope != '' ?  ' Ⓕ  '.l:scope : ''
endfunction

function! statusline#ReadOnly() abort
  if &readonly || !&modifiable
    hi User3 guifg=#c9505c guibg=#191f26 gui=BOLD
      return '-- RO --'
  else
    return ''
  endif
endfunction

function! statusline#FileType() abort
  let l:currFile = expand('%:~:.')
  let l:extension = expand('%:e')
  if l:extension == ''
    return ''
  endif
  if !executable('devicon-lookup')
    return l:currFile
  endif
  if g:isWindows
    return trim(system('devicon-lookup <<< '.l:currFile." 2> NUL | tr -d '\n'"))
  else
    return trim(system('devicon-lookup <<< '.l:currFile." 2> /dev/null | tr -d '\n'"))
  endif
endfunction
