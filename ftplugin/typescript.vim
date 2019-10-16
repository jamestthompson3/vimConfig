let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

let g:mucomplete#chains.typescript = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']
let g:mucomplete#chains['typescriptreact'] = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']

setlocal foldmethod=syntax
setlocal foldlevelstart=99
setlocal foldlevel=99

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
    let &l:makeprg = 'tsc --noEmit --pretty false'

    augroup TS
      autocmd!
      " FIXME for mono repo
      " autocmd BufWritePost <buffer>  call TSLint()
    augroup END
    " let l:errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m
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
        exec 'cwindow'
  endfunction

  " :call setqflist([], ' ', {'lines': systemlist('tsc --noEmit --pretty false ./services/docs/pages/_app.tsx'), 'efm': '%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m'})
  function! OnEvent(job_id, data, event)
    let s:errors[-1] .= a:data[0]
    call extend(s:errors, a:data[1:])
  endfunction

  call jobstart(printf('tsc --noEmit --pretty false %s', bufname('%')), l:callbacks)
endfunction
