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
let g:ale_completion_enabled = 1
let b:ale_linters = ['eslint', 'flow-language-server']
let b:ale_fixers = ['prettier']

" if !g:isOni
"   let b:ale_linters = ['eslint', 'flow', 'tsserver']
" endif

if !g:isOni
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif
"                ╔══════════════════════════════════════════╗
"                ║                » TERN «                  ║
"                ╚══════════════════════════════════════════╝
let g:deoplete#sources#ternjs#types = 1 "Whether to include the types of the completions
let g:ternjs#arguments = ['--no-port-file']
let g:deoplete#sources#ternjs#depths = 1 "Whether to include the distance  between the completions and the origin position in the result data.

"                ╔══════════════════════════════════════════╗
"                ║             » SEARCH DOCS «              ║
"                ╚══════════════════════════════════════════╝
call denite#custom#var('doc_grep', 'command', ['rg'])
call denite#custom#var('doc_grep', 'default_opts',
    \ ['-i', '--vimgrep', '--no-ignore'])
call denite#custom#var('doc_grep', 'recursive_opts', [])
call denite#custom#var('doc_grep', 'pattern_opt', ['--type', 'markdown'])
call denite#custom#var('doc_grep', 'separator', ['--'])
call denite#custom#var('doc_grep', 'final_opts', [])

call denite#custom#alias('source', 'doc_grep', 'grep')
call denite#custom#source('doc_grep', 'matchers', ['matcher/regexp', 'matcher/fuzzy'])
call denite#custom#source('doc_grep', 'sorters', ['sorter/sublime', 'sorter/rank'])

nnoremap <silent><Leader>k :DeniteProjectDir -buffer-name=docs -direction=dynamicbottom doc_grep<CR>
