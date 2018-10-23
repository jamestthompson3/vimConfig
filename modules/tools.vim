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
" use ag for content search
function! GetOpts() abort
  let l:opts = ['ignore flow-typed']
  if getcwd() =~ 'kamu-front'
    call extend(l:opts, ['ignore viiksetjs', 'ignore front/flow-typed'])
  endif
  return l:opts
endfunction

let g:fzf_layout = { 'window': 'enew' }

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

function! Fzf_dev(no_git) abort
  let s:file_list = ['']
  let s:callbacks = {
    \ 'on_stdout': 'OnEvent',
    \ 'on_exit': 'OnExit'
    \ }

  if !a:no_git
    call jobstart([ 'rg',  '--files' ], s:callbacks)
  else
    call jobstart([ 'rg', '--no-ignore', '--files' ], s:callbacks)
  endif

  function! OnEvent(job_id, data, event)
    let s:file_list[-1] .= a:data[0]
    call extend(s:file_list, a:data[1:])
  endfunction

  function! OnExit(job_id, data, event)
    if g:isWindows
      call fzf#run({
        \ 'source': s:prepend_icon(s:file_list),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m',
        \ 'down': '40%'
        \ })
    call feedkeys('i')
    else
      call skim#run({
        \ 'source': s:prepend_icon(s:file_list),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m',
        \ 'down': '40%'
        \ })
    call feedkeys('i')
    endif
  endfunction
endfunction

function! Fzf_mru() abort
  function! s:generate_mru()
    let l:mru_path_command = printf('sed "1d" %s', g:neomru#file_mru_path)
    let l:mru_files = split(system(l:mru_path_command), '\n')
    let l:cur_dir = substitute(getcwd(), '\\', '/', 'g')
    let l:filtered_files = filter(l:mru_files, {idx, val -> stridx(val, cur_dir) >= 0} )
    return map(l:filtered_files, {idx, val -> substitute(val, cur_dir.'/', '', '')})
  endfunction

  if g:isWindows
      call fzf#run({
        \ 'source': s:prepend_icon(s:generate_mru()),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m',
        \ 'down': '40%'
        \ })
    else
      call skim#run({
        \ 'source': s:prepend_icon(s:generate_mru()),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m',
        \ 'down': '40%'
        \ })
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

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

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
