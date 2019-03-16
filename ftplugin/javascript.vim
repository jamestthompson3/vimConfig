scriptencoding utf-8

if !exists('g:loaded_js_config')
  packadd vim-better-javascript-completion
  packadd vim-jsx-improve
  packadd ultisnips
  packadd Colorizer
  packadd vim-nodejs-errorformat
  let g:loaded_js_config = 1
endif

let g:mucomplete#chains.javascript = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']
let g:mucomplete#chains['javascript.jsx'] = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']

" Syntax: {{{
let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
let g:vim_json_syntax_conceal = 0
" }}}

" ALE: {{{
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']
let b:ale_linters_ignore = ['tsserver']
" }}}


" Misc: {{{
let g:vimjs#casesensistive = 0
let g:vimjs#smartcomplete = 1
let g:vimjs#chromeapis = 1
let g:vimjs#reactapis = 1
" peek references
nnoremap <silent>K :call tools#ListTags()<CR>

inoremap `<CR>       `<CR>`<esc>O<tab>
setlocal suffixesadd+=.js,.jsx,.ts,.tsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
setlocal foldmethod=syntax
setlocal foldlevelstart=99
setlocal foldlevel=99
setlocal omnifunc=javascriptcomplete#CompleteJS
setlocal equalprg=prettier
" }}}
"
