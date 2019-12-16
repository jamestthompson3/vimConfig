scriptencoding utf-8
set fileencoding=utf8

" Disable some default vim plugins:
let loaded_matchit = 1

" Load Custom Modules:
lua << EOF
 require('mappings')
 require('init')
 -- require('ui')
EOF

" Commands:
command! -nargs=+ -complete=dir -bar SearchProject call s:find(<q-args>)

" Async grep
function! s:find(term) abort
  let l:callbacks = {
        \ 'on_stdout': 'OnEvent',
        \ 'on_exit': 'OnExit',
        \ 'stdout_buffered':v:true
        \ }

  let s:results = ['']

  function! OnExit(job_id, data, event)
    call setqflist([], 'r', {'title': 'Search Results', 'lines': s:results})
    exec 'cwindow'
  endfunction

  function! OnEvent(job_id, data, event)
      let eof = (a:data == [''])
      let s:results[-1] .= a:data[0]
    call extend(s:results, a:data[1:])
  endfunction

  call jobstart(printf('rg %s --vimgrep --smart-case', a:term), l:callbacks)
endfunction
