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
let g:jsdoc_input_description = 1 "...Prompt for a function description
let g:jsdoc_underscore_private = 1
let g:jsdoc_enable_es6 = 1
"                ╔══════════════════════════════════════════╗
"                ║                  » ALE «                 ║
"                ╚══════════════════════════════════════════╝
let g:ale_completion_enabled = 1
if !exists('g:gui_oni')
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif
"                ╔══════════════════════════════════════════╗
"                ║                » TERN «                  ║
"                ╚══════════════════════════════════════════╝
let g:deoplete#sources#ternjs#types = 1 "...Whether to include the types of the completions
let g:ternjs#arguments = ['--no-port-file']
let g:deoplete#sources#ternjs#depths = 1 "...Whether to include the distance  between the completions and the origin position in the result data.
