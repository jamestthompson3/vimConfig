let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

let g:mucomplete#chains.typescript = [ 'omni','keyn', 'keyp','tags','c-p','c-n', 'file','path']
let g:mucomplete#chains['typescriptreact'] = ['omni','keyn', 'keyp', 'tags','c-p', 'c-n', 'file','path']

setl omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <silent> ge <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
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
  " let &l:makeprg = 'tsc --noEmit --pretty false'
  let &l:makeprg = 'eslint --format unix'

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
    " call setqflist([], ' ', {'lines': s:errors, 'efm': '%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m'})
    call setqflist([], ' ', {'lines': s:errors})
    exec 'cwindow'
  endfunction

  function! OnEvent(job_id, data, event)
    let s:errors[-1] .= a:data[0]
    call extend(s:errors, a:data[1:])
  endfunction

  call jobstart(printf('yarn eslint --format unix %s', bufname('%')), l:callbacks)
endfunction

