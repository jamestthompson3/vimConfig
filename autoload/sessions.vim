function! sessions#sourceSession() abort
  let [ sessionName, altName ] = sessions#manageSession()
  if sessionName != ''
    if sessionName == 'master'
      return
    else
      try
        execute 'so '.g:sessionPath.trim(sessionName).'.vim'
      catch
        execute 'so '.g:sessionPath.altName.'.vim'
      catch
        echom 'Could not source session'
      endtry
    endif
  endif
endfunction

" TODO move to lua
function! sessions#manageSession() abort
  let l:sessionName = git#branch()
  let l:cur_dir = substitute(getcwd(), '\\', '/', 'g')
  let l:filePath = substitute(expand('%:p:h'), '\\', '/', 'g')
  let l:altName = substitute(l:filePath, l:cur_dir, '', '')
  return [l:sessionName,  l:altName]
endfunction

" TODO move to lua
function! sessions#saveSession() abort
  return
  " let [ sessionName, altName ] = sessions#manageSession()
  " if sessionName != ''
  "   if sessionName == 'master'
  "     return
  "   else
  "     execute 'mks! '.g:sessionPath.trim(sessionName).'.vim'
  "   endif
  " else
  "   execute 'mks! '.g:sessionPath.altName.'.vim'
  " endif
endfunction
