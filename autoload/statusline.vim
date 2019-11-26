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

" vim-line-no-indicator
" Author: Sheldon Johnson
" Version: 0.3
function! statusline#LineNoIndicator() abort
  let l:line_no_indicator_chars = [
        \  ' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'
        \  ]
  " Zero index line number so 1/3 = 0, 2/3 = 0.5, and 3/3 = 1
  let l:current_line = line('.') - 1
  let l:total_lines = line('$') - 1

  if l:current_line == 0
    let l:index = 0
  elseif l:current_line == l:total_lines
    let l:index = -1
  else
    let l:line_no_fraction = floor(l:current_line) / floor(l:total_lines)
    let l:index = float2nr(l:line_no_fraction * len(l:line_no_indicator_chars))
  endif

  return l:line_no_indicator_chars[l:index]
endfunction
