scriptencoding utf-8
" Completion tools
let g:asyncomplete_remove_duplicates = 1
if !exists('g:gui_oni')
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
endif
"for asyncomplete.vim log
let g:asyncomplete_log_file = expand('~/asyncomplete.log')
" Searching
let g:grepper = {}
let g:grepper.dir = 'repo,file'
let g:grepper.tools = ['rg', 'ag', 'git']
let g:FlyGrep_search_tools = ['rg', 'ag', 'grep', 'pt', 'ack']
let g:far#source= 'rg'
