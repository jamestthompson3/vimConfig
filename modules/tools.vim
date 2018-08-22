scriptencoding utf-8
" Completion tools
let g:deoplete#enable_at_startup = 1
" Searching
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:grepper = {}
let g:grepper.dir = 'repo,file'
let g:grepper.tools = ['ag', 'rg', 'git']
let g:FlyGrep_search_tools = ['ag', 'rg', 'grep', 'pt', 'ack']
let g:far#source= 'ag'
