let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = ['prettier']

" packadd coc.nvim

" nnoremap <leader>a :CocAction<CR>
" nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
" nnoremap <silent> gh :call CocAction('doHover')<CR>
" nnoremap <silent> K <Plug>(coc-references)
" nnoremap <leader>ld :CocList diagnostics<CR>

" let coc handle this
let g:mucomplete#chains.typescript = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']
let g:mucomplete#chains['typescript.jsx'] = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']
let g:mucomplete#chains['typescript.tsx'] = ['tags','keyn', 'keyp', 'c-p', 'c-n', 'omni', 'file','path', 'ulti']
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
