let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

" packadd coc.nvim

nnoremap <leader>a :CocAction<CR>
nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> gh :call CocAction('doHover')<CR>
" nnoremap <silent> K <Plug>(coc-references)
" nnoremap <leader>ld :CocList diagnostics<CR>

let g:mucomplete#chains.typescript = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']
let g:mucomplete#chains['typescript.jsx'] = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']
let g:mucomplete#chains['typescript.tsx'] = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']
" let coc handle this
" let g:mucomplete#chains.typescript = []
" let g:mucomplete#chains['typescript.jsx'] = []
" let g:mucomplete#chains['typescript.tsx'] = []

syntax match typescriptOpSymbols "<=" conceal cchar=≤
syntax match typescriptOpSymbols ">=" conceal cchar=≥
syntax match typescriptOpSymbols "!==" conceal cchar=≢
syntax match typescriptOpSymbols /=>/ conceal cchar=⇒

setlocal foldmethod=manual
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
  " TODO run async
    let &l:makeprg = 'tsc --noEmit --pretty false'

    " augroup TS
    "   autocmd!
    "   autocmd BufWritePost <buffer> silent make! <afile> | silent redraw!
    " augroup END
  let b:did_typescript_setup = 1
endif
