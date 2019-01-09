scriptencoding utf-8

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

" Jest: {{{
function! FuzzyJest(trimmed_values) abort
  call fzf#run({
        \ 'source': a:trimmed_values,
        \ 'sink':   function('JestTest'),
        \ 'options': '-m',
        \ 'down': '40%'
        \ })
    call feedkeys('i')
endfunction

function! ListTests() abort
  let g:Jest_list_callback = funcref('FuzzyJest')
  call JestList()
  unlet g:Jest_list_callback
endfunction

nmap <silent> Lrt :call ListTests()<CR>
nmap <silent> Lt :call JestList()<CR>
nmap <silent> T :call RunJest()<CR>
" }}}

" Misc: {{{
" peek symbol definition
nnoremap gh [i
" peek references
nnoremap <silent>K :call ListTags()<CR>
" jump to symbol definition
nnoremap <silent> gd :ijump <c-r><c-w><CR>
inoremap `<CR>       `<CR>`<esc>O<tab>

iabbrev cosnt const
iabbrev imoprt import
iabbrev iomprt import
iabbrev improt import

setlocal suffixesadd+=.js,.jsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
setlocal omnifunc=javascriptcomplete#CompleteJS
" }}}
