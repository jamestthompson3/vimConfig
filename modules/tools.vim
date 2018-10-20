scriptencoding utf-8
"                ╔══════════════════════════════════════════╗
"                ║                » COMPLETION «            ║
"                ╚══════════════════════════════════════════╝
if !g:isOni
let g:deoplete#enable_at_startup = 1
endif
let g:deoplete#auto_complete_delay = 10
call deoplete#custom#source('ultisnips', 'rank', 1000)
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  " set omnifunc=syntaxcomplete#Complete
augroup END
set completeopt+=preview,longest,noinsert,menuone,noselect
let g:UltiSnipsSnippetsDir = $MYVIMRC . g:file_separator . 'UltiSnips'
let g:UltiSnipsExpandTrigger = '<c-l>'
"                ╔══════════════════════════════════════════╗
"                ║              » SEARCHING «               ║
"                ╚══════════════════════════════════════════╝
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:grepper = {}
let g:grepper.dir = 'repo,file'
let g:grepper.tools = ['rg', 'ag', 'git']
if g:isWindows
  let g:grepper.tools = ['ag', 'rg', 'git']
endif
let g:grepper.ag = {
      \'grepprg': 'ag -i --vimgrep --ignore flow-typed'
      \}
let g:grepper.rg = {
      \'grepprg': 'rg --vimgrep'
      \}
let g:far#source= 'rgnvim'
if g:isWindows
  let g:far#source= 'agnvim'
endif
let g:far#auto_write_replaced_buffers = 1
call denite#custom#source(
\ 'grep', 'matchers', ['matcher_regexp'])

" use ag for content search
function! GetOpts() abort
  let l:opts = ['ignore flow-typed']
  if getcwd() =~ 'kamu-front'
    call extend(l:opts, ['ignore viiksetjs', 'ignore front/flow-typed'])
  endif
  return l:opts
endfunction

call denite#custom#source('file_mru', 'matchers', ['matcher/regexp', 'matcher/fruzzy', 'matcher/project_files'])
call denite#custom#source('file_mru', 'sorters', ['sorter/sublime', 'sorter/rank'])
" call denite#custom#source('buffer', 'sorters', ['sorter/sublime', 'sorter/rank'])
" call denite#custom#source('buffer', 'matchers', ['matcher/regexp', 'matcher/fruzzy', 'matcher/project_files'])

let g:fruzzy#usenative = 1
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', GetOpts())
call denite#custom#var('file_rec', 'command',
      \ ['rg', '-L', '-i', '--no-ignore', '--files'])


" call denite#custom#var('file_rec/git', 'command', ['rg', '-L', '-i', '--files'])
call denite#custom#var('file_rec/git', 'command', ['fd', '.', '-i', '--type', 'file'])
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#source('file_rec/git', 'matchers', ['matcher/regexp', 'matcher/fruzzy'])
call denite#custom#source('file_rec', 'matchers', ['matcher/regexp', 'matcher/fruzzy'])
call denite#custom#source('file_rec', 'sorters', ['sorter/sublime', 'sorter/rank'])
call denite#custom#source('file_rec/git', 'sorters', ['sorter/sublime', 'sorter/rank'])

call denite#custom#option('_', 'highlight_mode_insert', 'CursorLineNr')
call denite#custom#option('_', 'highlight_matched_range', 'Search')
call denite#custom#option('_', 'highlight_matched_char', 'None')
call denite#custom#option('_', 'prompt', '>')

"                ╔══════════════════════════════════════════╗
"                ║                » MATCHUP «               ║
"                ╚══════════════════════════════════════════╝
let g:matchup_transmute_enabled = 1
let g:matchup_motion_enabled = 0
let g:matchup_matchparen_deferred = 1
let g:matchup_match_paren_timeout = 100
"                ╔══════════════════════════════════════════╗
"                ║                » NERDTREE «              ║
"                ╚══════════════════════════════════════════╝
let g:netrw_winsize = 20
let g:netrw_banner = 0
let g:netrw_browse_split = 4
"                ╔══════════════════════════════════════════╗
"                ║                  » GOYO «                ║
"                ╚══════════════════════════════════════════╝
let g:goyo_width = 120
"                ╔══════════════════════════════════════════╗
"                ║                 » COLOR «                ║
"                ╚══════════════════════════════════════════╝
" let g:colorizer_auto_color = 1
let g:colorizer_auto_filetype='css,html,javascript.jsx'
"                ╔══════════════════════════════════════════╗
"                ║               » WINDOWS «                ║
"                ╚══════════════════════════════════════════╝
augroup WINDOWS
  autocmd!
  autocmd WinEnter * set number
  autocmd WinLeave * set nonumber
augroup END
