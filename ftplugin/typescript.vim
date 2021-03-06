
set formatoptions+=o

lua require'tt.user_lsp'.setMappings()
lua require 'tt.ft.ecma'.bootstrap()


" TODO figure out why ale is not working on mono repos
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
setlocal makeprg=yarn\ run\ --silent\ eslint\ --format\ compact\ --fix

setlocal autoread

if !exists('b:did_typescript_setup')
  " node_modules
  let node_modules = finddir('node_modules', '.;', -1)
  if len(node_modules)
    let b:ts_node_modules = map(node_modules, { idx, val -> substitute(fnamemodify(val, ':p'), '/$', '', '')})

    unlet node_modules
  endif

  " $PATH
  if exists('b:ts_node_modules')
    if $PATH !~ b:ts_node_modules[0]
      let $PATH = b:ts_node_modules[0] . ':' . $PATH
    endif
  endif


  " lint file on write
  " let &l:makeprg = 'tsc --noEmit --pretty false'
  " let &l:makeprg = 'eslint --format unix'
" setlocal makeprg=yarn\ --silent\ lint:compact\ --\ --fix
" setlocal autoread
" augroup TS
"     autocmd! * <buffer>
"     autocmd BufWritePost <buffer> silent make <afile> | checktime | silent redraw!
" augroup END
  " augroup TS
  "   autocmd!
  "   " FIXME for mono repo
  "   " autocmd BufWritePost <buffer>  call TSLint()
  " augroup END
  " set efm=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m
  " let l:errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m
  "TAGBAR:
  let g:tagbar_type_typescript = {
        \ 'ctagstype' : 'typescript',
        \ 'kinds'     : [
        \ 'f:functions',
        \ 'c:classes',
        \ 'i:interfaces',
        \ 'g:enums',
        \ 'e:enumerators',
        \ 'm:methods',
        \ 'n:namespaces',
        \ 'p:properties',
        \ 'v:variables',
        \ 'C:constants',
        \ 'G:generators',
        \ 'a:aliases',
        \ ],
        \ 'sro'        : '.',
        \ 'kind2scope' : {
        \ 'c' : 'classes',
        \ 'a' : 'aliases',
        \ 'f' : 'functions',
        \ 'v' : 'variables',
        \ 'm' : 'methods',
        \ 'i' : 'interfaces',
        \ 'e' : 'enumerators',
        \ 'enums'      : 'g'
        \ },
        \ 'scope2kind' : {
        \ 'classes'    : 'c',
        \ 'aliases'    : 'a',
        \ 'functions'  : 'f',
        \ 'variables'  : 'v',
        \ 'methods'    : 'm',
        \ 'interfaces' : 'i',
        \ 'enumerators'      : 'e',
        \ 'enums'      : 'g'
        \ }
        \ }

  let g:tagbar_type_typescriptreact = g:tagbar_type_typescript
  let b:did_typescript_setup = 1
endif


function! s:prep_qf(id, value)
  echom value
  let l:qf_item = {}
  let l:qf_item.filename = a:value
  return l:qf_item
endfunction

function! TSLint() abort
  let l:callbacks = {
        \ 'on_stdout': 'OnEvent',
        \ 'on_exit': 'OnExit'
        \ }
  let s:errors = ['']

  function! OnExit(job_id, data, event)
    call setqflist([], ' ', {'lines': s:errors, 'efm': '%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m'})
    " call setqflist([], ' ', {'lines': s:errors})
    exec 'cwindow'
  endfunction

  function! OnEvent(job_id, data, event)
    let s:errors[-1] .= a:data[0]
    call extend(s:errors, a:data[1:])
  endfunction

  " call jobstart(printf('yarn eslint --format unix %s', bufname('%')), l:callbacks)
  " call jobstart(printf('tsc %s --pretty false', bufname('%')), l:callbacks)
endfunction

let g:ts_loaded = 1
