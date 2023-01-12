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

" /*}}}*/
