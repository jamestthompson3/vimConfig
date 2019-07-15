let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

packadd coc.nvim

nnoremap <leader>a :CocAction<CR>
nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> gh :call CocAction('doHover')<CR>
nnoremap <silent> K <Plug>(coc-references)

" let coc handle this
let g:mucomplete#chains.typescript = []
let g:mucomplete#chains['typescript.jsx'] = []
let g:mucomplete#chains['typescript.tsx'] = []

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
