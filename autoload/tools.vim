scriptencoding utf-8

function! tools#switchSourceHeader() abort
  if (expand ('%:e') != 'h')
    find %:t:r.h
  else
    let l:filename = expand('%:t:r')
    for item in b:source_ft
      try
        execute 'find '.l:filename.'.'.item
      catch /^Vim\%((\a\+)\)\=:E/
      endtry
    endfor
  endif
endfunction


function! tools#redir(cmd)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let output = system(matchstr(a:cmd, '^!\zs.*'))
  else
    redir => output
    execute a:cmd
    redir END
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  nnoremap <buffer> q <c-w>c
  call setline(1, split(output, "\n"))
endfunction
