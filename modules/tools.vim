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
set grepprg=rg\ --vimgrep
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

function! s:run_fzf(list, async)
 call fzf#run({
     \ 'source': s:prepend_icon(a:list),
     \ 'sink':   function('s:edit_file'),
     \ 'options': '-m',
     \ 'down': '40%'
     \ })
 if a:async
   call feedkeys('i')
 endif
endfunction

function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[l:pos+1:-1]
    echom l:file_path
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
    call s:run_fzf(filter( s:file_list, {idx, val -> val isnot# ''} ), 1)
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
  call s:run_fzf(s:generate_mru(), 0)
endfunction

function! Fzf_dir() abort
  let l:file_dir = expand('%:p:h')
  let l:dir_files = map(split(system(printf('ls %s', l:file_dir)), '\n'), {idx, val -> substitute(fnamemodify(val, ':p'), '\\', '/', 'g')})
  call s:run_fzf(l:dir_files, 0)
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
  \   'git branch', 0,
  \   {
  \     'sink': function('s:open_branch_fzf')
  \   },
  \   <bang>0
  \ )

function! s:OpenList() abort
  let l:pattern = input('Search > ')
  call setqflist([], ' ', { 'lines': systemlist('rg --fixed-strings --vimgrep -S'.' '.l:pattern)})
  exec ':copen'
endfunction

function! s:GrepBufs() abort
  let l:pattern  = input('Search > ')
  exec ':silent bufdo grepadd'.' '.l:pattern.' %'
  exec ':copen'
endfunction

function! s:Confirm(find, replace) abort
  let s:replace_string = printf('/\<%s\>/%s/g', a:find, a:replace)
  exec ':copen'
  function! s:Replace_words()
    exec ':silent cfdo %s'.s:replace_string.' | update'
  endfunction
  command! ReplaceAll call s:Replace_words()
endfunction

function! s:FindReplace() abort
  let l:find = input('Find > ')
  let l:replace = input('Replace > ')
  call setqflist([], ' ', { 'lines': systemlist('rg --fixed-strings --vimgrep -S'.' '.l:find)})
  call s:Confirm(l:find, l:replace)
endfunction


command! -bang SearchProject call s:OpenList()
command! -bang SearchBuffers call s:GrepBufs()
command! -bang  FindandReplace call s:FindReplace()
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
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
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
