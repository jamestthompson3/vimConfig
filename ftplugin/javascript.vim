"""""""""""""" JS stuff """"""""""""""""""""""
" Syntax Highlighting
let g:jsx_ext_required = 0
" let g:vim_jsx_pretty_colorful_config = 1
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

" TODO fix slow lsp
" call lsp#register_server({
"       \ 'name': 'typescript-language-server',
"       \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
"       \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
"       \ 'whitelist': ['typescript', 'javascript', 'javascript.jsx']
"       \ })
call asyncomplete#register_source(asyncomplete#sources#flow#get_source_options({
    \ 'name': 'flow',
    \ 'whitelist': ['javascript'],
    \ 'completor': function('asyncomplete#sources#flow#completor'),
    \ 'config': {
    \    'prefer_local': 1,
    \    'flowbin_path': expand('~/bin/flow'),
    \    'show_typeinfo': 1
    \  },
    \ }))
" nnoremap <silent> gh :ALEHover<CR>
" nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gl :pc<CR>
nnoremap <silent> <leader>K :LspReferences<CR>

