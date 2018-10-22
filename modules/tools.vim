scriptencoding utf-8
"                ╔══════════════════════════════════════════╗
"                ║                » COMPLETION «            ║
"                ╚══════════════════════════════════════════╝
" if !g:isOni
let g:deoplete#enable_at_startup = 1
" endif
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
" if g:isWindows
"   let g:far#source= 'agnvim'
" endif
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

let g:fzf_layout = { 'window': 'enew' }
function! Fzf_dev(no_git) abort


  let s:file_list = ['']
  function! s:files(no_git)
    function! OnEvent(job_id, data, event)
      let s:file_list[-1] .= a:data[0]
      call extend(s:file_list, a:data[1:])
      call s:prepend_icon(s:file_list)
    endfunction

    let s:callbacks = {
    \ 'on_stdout': 'OnEvent'
    \ }
    if !a:no_git
      call jobstart([ 'rg --files' ], s:callbacks)
    else
      call jobstart([ 'rg', '-L', '-i', '--no-ignore', '--files' ], s:callbacks)
    endif
    " let l:files = split(s:file_list, '\n')
      " echom printf('%s', string(s:file_list))
    return s:prepend_icon(s:file_list)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[l:pos+1:-1]
    execute 'silent e' l:file_path
  endfunction

  if g:isWindows
    call fzf#run({
        \ 'source': <sid>files(a:no_git),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m',
        \ 'down': '40%'})
  else
    call skim#run({
        \ 'source': <sid>files(a:no_git),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m',
        \ 'down': '40%'})

  endif
endfunction

function! s:open_branch_fzf(line)
  let l:parser = split(a:line)
  let l:branch = l:parser[0]
  if l:branch ==? '*'
    let l:branch = l:parser[1]
  endif
  execute '!git checkout ' . l:branch
endfunction

command! -bang -nargs=0 GCheckout
  \ call fzf#vim#grep(
  \   'git branch -v', 0,
  \   {
  \     'sink': function('s:open_branch_fzf')
  \   },
  \   <bang>0
  \ )
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

call denite#custom#option('_', 'highlight_mode_insert', 'Visual')
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
let g:netrw_browse_split = 0
let g:netrw_fastbrowse = 2
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
