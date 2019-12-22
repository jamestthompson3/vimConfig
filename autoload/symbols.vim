let s:cscope_options_default    = '-C'

function! symbols#PreviewWord() abort
  if &previewwindow			" don't do this in the preview window
    return
  endif
  let w = expand('<cword>')		" get the word under cursor
  if w =~ '\a'			" if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P			" jump to preview window
    if &previewwindow			" if we really get there...
      match none			" delete existing highlight
      wincmd p			" back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
      exe 'ptag ' . w
    catch
      return
    endtry

    silent! wincmd P			" jump to preview window
    if &previewwindow		" if we really get there...
      if has('folding')
        silent! .foldopen		" don't want a closed fold
      endif
      call search('$', 'b')		" to end of previous line
      let w = substitute(w, '\\', '\\\\', '')
      call search('\<\V' . w . '\>')	" position cursor on match
      " Add a match highlight to the word at this position
      hi! link previewWord TODO
      exe 'match previewWord "\%' . line('.') . 'l\%' . col('.') . 'c\k*"'
      wincmd p			" back to old window
    endif
  endif
endfunction

function! symbols#ShowDeclaration(global) abort
  let pos = getpos('.')
  if searchdecl(expand('<cword>'), a:global) == 0
    let line_of_declaration = line('.')
    execute line_of_declaration . '#'
  endif
  call cursor(pos[1], pos[2])
endfunction

function! symbols#buildCscopeFiles() abort
  let l:pattern  = input('filetype > ')
  call system('fd -e '.l:pattern.' > cscope.files && cscope -bcqR')
endfunction


function! symbols#CSRefreshAllConns()

  " Check if there are any cscope connections
  let saveA = @a
  redir  @a
  silent! exec 'cs show'
  redir END
  let cs_conns = @a
  let @a = saveA

  if cs_conns !~? 'no cscope connections'
    let match_regex = '\(\d\+\s\+\d\+\s\+\S\+\s\+\S\+\)'
    let index = match(cs_conns, match_regex)

    while index > -1
      " Retrieve the name of option
      let cs_conn_num = matchstr(cs_conns, '^\d\+', index)
      if strlen(cs_conn_num) > 0
        let index = (index + strlen(cs_conn_num))
        let cs_db_name = matchstr(cs_conns,
              \ '\s\+\d\+\s\+\zs\S\+',
              \ index
              \ )
        let index = index + strlen(cs_conn_num)
              \     + strlen(cs_db_name)
        let cs_db_path = matchstr(cs_conns,
              \ '\s\+\zs\S\+',
              \ index
              \ )
        if cs_db_path =~ "<none>" || cs_db_path =~ '""'
          let cs_db_path = ''
        endif
        let index = index + strlen(cs_conn_num)
              \     + strlen(cs_db_name)
              \     + strlen(cs_db_path)
              \     + 1
        call s:CSReloadDB( cs_conn_num, cs_db_name, cs_db_path,
              \ s:cscope_options_default )
      endif
      let index = index + 1
      let index = match(cs_conns, match_regex, index)
    endwhile
  else
    if filereadable("cscope.out")
      " cscope -C (queries this with case insensitivity)
      exec 'cs add '.getcwd().'/cscope.out "" '.s:cscope_options_default
    endif
  endif

endfunction

function! s:CSReloadDB( cs_conn_num, cs_db_name, cs_db_path, cs_options )
  exec 'cs kill ' . a:cs_conn_num

  let cs_db_fullpath = fnamemodify(a:cs_db_name,":p")

  let root_file = a:cs_db_path
  if root_file == ""
    let root_file = fnamemodify(a:cs_db_name,":p")
  endif

  if filereadable(cs_db_fullpath)
    let cs_cmd = 'cs add '.
          \ cs_db_fullpath.' '.
          \ fnamemodify(cs_db_fullpath, ":p:h").' '.
          \ a:cs_options
    exec cs_cmd
  else
    echohl WarningMsg
    echomsg 'CSReloadDB - Cannot find: '.cs_db_fullpath
    echohl None
  endif
endfunction

function! CSRebuildDB( cs_db_fullpath, cs_options )
  let cscope_files = fnamemodify(a:cs_db_fullpath,":p:h").'\cscope.files'
  if filereadable(cscope_files)
    let cs_cmd = 'cscope -bqR '.
          \ '-f '.a:cs_db_fullpath.
          \ ' -i '.cscope_files
    let cs_out = system(cs_cmd)

    if v:shell_error
      echo cs_out
    else
      echo 'Rebuilt cscope database: ' . a:cs_db_fullpath
    endif
  endif

endfunction

" /*}}}*/
