scriptencoding utf-8

function! statusline#MU() " show current completion method
  let l:modecurrent = mode()
  if l:modecurrent == 'i' && exists('g:mucomplete_current_method')
   return g:mucomplete_current_method
   else
     return ''
  endif
endfunction

function! statusline#LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:warning = l:counts.warning
    let l:error = l:counts.error
    if l:all_errors + l:counts.warning == 0
     return '✓'
    else
      return printf(
    \   '%d ⚠ %d ☓',
    \   l:warning,
    \   l:error
    \) . ' '
  endif
endfunction

let s:currentmode={ 'V' : 'V·Line ', 'i' : '[+]', 'R': 'Replace' }

function! statusline#ModeCurrent() abort
    let l:modecurrent = mode()
    if l:modecurrent == '^V'
      return 'V Block'
    else
      let l:modelist = toupper(get(s:currentmode, l:modecurrent, ''))
      return l:modelist
    endif
endfunction

function! statusline#Get_gutentags_status(mods) abort
  let l:msg = ''
    if index(a:mods, 'ctags') >= 0
      let l:msg .= '♨'
    endif
    if index(a:mods, 'cscope') >= 0
      let l:msg .= '♺'
    endif
  return l:msg
endfunction

function! statusline#ReadOnly() abort
  if &readonly || !&modifiable
    hi User3 guifg=#c9505c guibg=#191f26 gui=BOLD
    return ''
  else
    return ''
  endif
endfunction

function! statusline#GitBranch()
  return system("git rev-parse --abbrev-ref HEAD | tr -d '\n'")
endfunction

function! statusline#StatuslineGit()
  let l:branchname = statusline#GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! statusline#FileType() abort
  let l:currFile = expand('%')
  if filereadable(l:currFile)
    return system('devicon-lookup <<< '.l:currFile." | tr -d '\n'")
  else
    return l:currFile
  endif
endfunction

