"""""""""""""" JS stuff """"""""""""""""""""""
" Syntax Highlighting
let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
  " Allow prompt for interactive input.
let g:jsdoc_allow_input_prompt = 1
" Prompt for a function description
let g:jsdoc_input_description = 1
" Set value to 1 to turn on detecting underscore starting functions as private convention
let g:jsdoc_underscore_private = 1
" Enable to use ECMAScript6's Shorthand function, Arrow function.
let g:jsdoc_enable_es6 = 1
let g:vim_json_syntax_conceal = 0
let g:ale_completion_enabled = 1

if !exists('g:gui_oni')
  nnoremap <silent> gh ALEHover<CR>
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif

