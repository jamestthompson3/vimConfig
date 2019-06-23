let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = ['prettier']

nnoremap <silent> gh :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> K :ALEFindReferences<CR>

let g:mucomplete#chains.typescript = ['omni', 'keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']
let g:mucomplete#chains['typescript.jsx'] = ['omni', 'keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']
let g:mucomplete#chains['typescript.tsx'] = ['omni', 'keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']
" let g:ale_completion_enabled = 0

syntax match typescriptOpSymbols "<=" conceal cchar=≤
syntax match typescriptOpSymbols ">=" conceal cchar=≥
syntax match typescriptOpSymbols "!==" conceal cchar=≢
syntax match typescriptOpSymbols /=>/ conceal cchar=⇒

setlocal suffixesadd+=.js,.jsx,.ts,.tsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
setlocal foldmethod=manual
setlocal foldlevelstart=99
setlocal foldlevel=99
