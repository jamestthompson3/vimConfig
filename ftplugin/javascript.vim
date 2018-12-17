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
" call deoplete#disable()

if !g:isOni
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif

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

iabbrev cosnt const
iabbrev imoprt import
iabbrev iomprt import

setlocal suffixesadd+=.js " navigate to imported files by adding the js suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
