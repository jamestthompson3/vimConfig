scriptencoding utf-8
set fileencoding=utf8
set fileformat=unix

" Disable some default vim plugins:
let g:did_install_default_menus = 1
let g:loaded_tutor_mode_plugin = 1
let loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_zipPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_gzip = 1
let g:loaded_python_provider = 1

" User Globals:
let g:isWindows = has('win16') || has('win32') || has('win64')
let g:isMac = system('uname') =~ 'Darwin\n'
let g:remove_whitespace = 1 " Allows auto-remove whitespace to be toggled

if g:isWindows
  let g:file_separator = '\\'
  let g:python3_host_prog = 'C:\Users\taylor.thompson\AppData\Local\Programs\Python\Python36-32\python.exe'
else
  let g:file_separator = '/'
  let g:python3_host_prog= '/usr/local/bin/python3'
endif

let g:modules_folder = 'modules' . g:file_separator
let g:sessionPath = '~'.g:file_separator.'sessions'.g:file_separator


" Load Custom Modules:
lua << EOF
 local init = require('init')
 init.core_options()
 init.create_commands()
EOF
execute 'runtime! '.g:modules_folder.'*'

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

