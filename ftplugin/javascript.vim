scriptencoding utf-8
"                ╔══════════════════════════════════════════╗
"                ║           » SYNTAX HIGHLlGHTING «        ║
"                ╚══════════════════════════════════════════╝
let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
let g:vim_json_syntax_conceal = 0
"                ╔══════════════════════════════════════════╗
"                ║                  » JSDOC «               ║
"                ╚══════════════════════════════════════════╝
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1 "Prompt for a function description
let g:jsdoc_underscore_private = 1
let g:jsdoc_enable_es6 = 1
"                ╔══════════════════════════════════════════╗
"                ║                  » ALE «                 ║
"                ╚══════════════════════════════════════════╝
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']
let b:ale_linters_ignore = ['tsserver']

"                ╔══════════════════════════════════════════╗
"                ║                 » JEST «                 ║
"                ╚══════════════════════════════════════════╝

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

"                ╔══════════════════════════════════════════╗
"                ║                 » MISC «                 ║
"                ╚══════════════════════════════════════════╝

" peek symbol definition
nnoremap gh [I
" jump to symbol definition
nnoremap <silent> gd :ijump <c-r><c-w><CR>

iabbrev cosnt const
iabbrev imoprt import
iabbrev iomprt import
iabbrev improt import

setlocal suffixesadd+=.js,.jsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
" setlocal define=class\s[a-z]*\|export\sconst\s[a-z]*\|export\sdefault\s[a-z]*\|^\s*function\s[a-z]* " searches for symbols starting with 'class', 'export const' and 'function'
