scriptencoding utf-8
" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_tree_opened_icon = get(g:, 'vimfiler_tree_opened_icon', '▼')
let g:vimfiler_tree_closed_icon = get(g:, 'vimfiler_tree_closed_icon', '▷')
let g:vimfiler_file_icon = get(g:, 'vimfiler_file_icon', '')
let g:vimfiler_tree_leaf_icon = ''
let g:vimfiler_readonly_file_icon = get(g:, 'vimfiler_readonly_file_icon', '*')
let g:vimfiler_marked_file_icon = get(g:, 'vimfiler_marked_file_icon', '√')
let g:vimfiler_ignore_pattern = get(g:, 'vimfiler_ignore_pattern', [
      \ '^\.git$',
      \ '^\.DS_Store$',
      \ '^\.init\.vim-rplugin\~$',
      \ '^\.netrwhist$',
      \ '\.class$',
      \ '^\.'
      \])

call vimfiler#custom#profile('custom', 'context', {
      \ 'explorer' : 1,
      \ 'winwidth' : 30,
      \ 'winminwidth' : 30,
      \ 'toggle' : 1,
      \ 'auto_expand': 1,
      \ 'direction' : 'rightbelow',
      \ 'parent': 0,
      \ 'status' : 1,
      \ 'safe' : 0,
      \ 'split' : 1,
      \ 'hidden': 1,
      \ 'no_quit' : 1,
      \ 'force_hide' : 0,
      \ })

" Completion tools
" TODO fine tune completion not to interfere with lsp
" 'blacklist': ['javascript', 'rust'],
let g:asyncomplete_remove_duplicates = 1

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))

call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 50000000,
    \  },
    \ }))

call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
\ 'name': 'omni',
\ 'whitelist': ['*'],
\ 'blacklist': ['c', 'cpp' ],
\ 'completor': function('asyncomplete#sources#omni#completor')
\  }))
"for asyncomplete.vim log
let g:asyncomplete_log_file = expand('~/asyncomplete.log')
" let g:deoplete#enable_at_startup = 1

" call deoplete#custom#option({
"     \ 'auto_complete_delay': 50,
"     \ 'smart_case': v:true,
"     \ 'complete_method': 'omnifunc'
"     \ })
" let g:deoplete#sources#rust#racer_binary = system('which racer')
" let g:deoplete#sources#rust#rust_source_path = system('which rustc')
" let g:deoplete#sources#rust#disable_keymap=1

" Searching
let g:grepper = {}
let g:grepper.dir = 'repo,file'
let g:grepper.tools = ['rg', 'ag', 'git']
let g:FlyGrep_search_tools = ['rg', 'ag', 'grep', 'pt', 'ack']
let g:far#source= 'rg'
