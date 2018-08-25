scriptencoding utf-8
" Completion tools
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 10
" Searching
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:grepper = {}
let g:grepper.dir = 'repo,file'
let g:grepper.tools = ['ag', 'rg', 'git']
let g:FlyGrep_search_tools = ['ag', 'rg', 'grep', 'pt', 'ack']
let g:far#source= 'ag'
" matchup settings
let g:matchup_transmute_enabled = 1
let g:matchup_motion_enabled = 0
let g:matchup_matchparen_deferred = 1
let g:matchup_match_paren_timeout = 100

" Faster leaderf
let g:Lf_WildIgnore = {'dir': ['lib','build', 'node_modules', 'target'], 'file': []}

