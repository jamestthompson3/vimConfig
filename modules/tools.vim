scriptencoding utf-8
"                ╔══════════════════════════════════════════╗
"                ║                » COMPLETION «            ║
"                ╚══════════════════════════════════════════╝

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 10
call deoplete#custom#source('ultisnips', 'rank', 1000)

augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  set omnifunc=syntaxcomplete#Complete
augroup END
set completeopt+=preview,longest,noinsert,menuone,noselect
set complete+=i

" snippets settings
let g:UltiSnipsSnippetsDir = $MYVIMRC . g:file_separator . 'UltiSnips'
let g:UltiSnipsExpandTrigger = '<c-l>'
"                ╔══════════════════════════════════════════╗
"                ║              » SEARCHING «               ║
"                ╚══════════════════════════════════════════╝
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
set grepprg=rg\ --vimgrep
let g:fzf_layout = { 'window': 'enew' }

function! s:run_fzf(command)
 call fzf#run({
     \ 'source': a:command . ' | devicon-lookup',
     \ 'sink':   function('s:edit_file'),
     \ 'options': '-m',
     \ 'down': '40%'
     \ })
endfunction

function! s:run_fzf_list(list)
 call fzf#run({
     \ 'source': a:list,
     \ 'sink':   function('s:edit_file'),
     \ 'options': '-m',
     \ 'down': '40%'
     \ })
endfunction


function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[l:pos+1:-1]
    echom l:file_path
    execute 'silent e' l:file_path
endfunction

function! Fzf_dev(no_git) abort
  " Needs to be fixed on Windows
  " if executable('nf')
  "   let l:file_list_command = 'nf'
  "   let l:file_list_command_no_git = 'nf --no-ignore'
  " else
    let l:file_list_command = 'rg --files'
    let l:file_list_command_no_git = 'rg --files --no-ignore'
  " endif

   if !a:no_git
    call s:run_fzf(l:file_list_command)
  else
    call s:run_fzf(l:file_list_command_no_git)
  endif
endfunction

function! Fzf_mru() abort " Search most recently used files
  function! s:generate_mru()
    let l:mru_path_command = printf('sed "1d" %s', g:neomru#file_mru_path)
    let l:mru_files = split(system(l:mru_path_command.' | devicon-lookup'), '\n')
    let l:cur_dir = substitute(getcwd(), '\\', '/', 'g')
    let l:filtered_files = filter(l:mru_files, {idx, val -> stridx(val, cur_dir) >= 0} )
    return map(l:filtered_files, {idx, val -> substitute(val, cur_dir.'/', '', '')})
  endfunction
  call s:run_fzf_list(s:generate_mru())
endfunction

function! s:open_branch_fzf(line)
  let l:parser = split(a:line)
  let l:branch = l:parser[0]
  if l:branch ==? '*'
    let l:branch = l:parser[1]
  endif
  execute '!git checkout ' . l:branch
endfunction

command! -bang -nargs=0 GCheckout " fuzzy search through git branch, checkout selected branch
  \ call fzf#vim#grep(
  \   'git branch', 0,
  \   {
  \     'sink': function('s:open_branch_fzf')
  \   },
  \   <bang>0
  \ )

function! s:OpenList() abort
  let l:pattern = input('Search > ')
  if l:pattern == ''
    return
  endif
  call s:GrepToQF(l:pattern)
  exec ':cwindow'
endfunction

function! RenameFile() abort
  let l:oldName = getline('.')
  let l:newName = input('Rename as: ', l:oldName, 'file')
  if newName != '' && newName != oldName
    call rename(oldName, newName)
    call feedkeys('R')
  endif
endfunction

function! s:GrepToQF(pattern) abort
    call setqflist([], ' ', { 'lines': systemlist('rg --fixed-strings --vimgrep -S'.' '.a:pattern)})
endfunction

function! s:GrepBufs() abort
  let l:pattern  = input('Search > ')
  exec ':silent bufdo grepadd'.' '.l:pattern.' %'
  exec ':cwindow'
endfunction

function! s:Confirm(find, replace) abort
  let s:replace_string = printf('/\<%s\>/%s/g', a:find, a:replace)
  exec ':cwindow'
  function! s:Replace_words()
    exec ':silent cfdo %s'.s:replace_string.' | update'
  endfunction
  command! ReplaceAll call s:Replace_words()
endfunction

function! s:FindReplace(callback) abort
  let l:find = input('Find > ')
  if l:find == ''
    return
  endif
  let l:replace = input('Replace > ')
  call s:GrepToQF(l:find)
  call s:Confirm(l:find, l:replace)
endfunction

" Replace things in the quick fix list
function! s:Replace_qf(args) abort
  let l:arg_list = split(a:args, ' ')
  let s:replace_string = printf('/\<%s\>/%s/g', l:arg_list[0], l:arg_list[1])
  exec ':silent cfdo %s'.s:replace_string.' | update'
endfunction

command! -bang -nargs=+ ReplaceQF call s:Replace_qf(<q-args>)
command! -bang SearchProject call s:OpenList()
command! -bang SearchBuffers call s:GrepBufs()
command! -bang FindandReplace call s:FindReplace()
command! -bang -nargs=* Rg " Grep then fuzzy search through results
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)


"                ╔══════════════════════════════════════════╗
"                ║                » MATCHUP «               ║
"                ╚══════════════════════════════════════════╝
let g:matchup_matchparen_deferred = 1
let g:matchup_match_paren_timeout = 100
"                ╔══════════════════════════════════════════╗
"                ║                » NERDTREE «              ║
"                ╚══════════════════════════════════════════╝
" Use dirvish over netrw, but still preserve netrw behavior
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args> | silent call feedkeys('20<c-w>|')
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args> | silent call feedkeys('20<c-w>|')
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args> | silent call feedkeys('20<c-w>|')
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
"
" Turn off column numbers if the window is inactive
augroup WINDOWS
  autocmd!
  autocmd WinEnter * set number
  autocmd WinLeave * set nonumber
augroup END
"                ╔══════════════════════════════════════════╗
"                ║                » MISC «                  ║
"                ╚══════════════════════════════════════════╝

" Convert to snake_case
function! s:Snake(args) abort
  if a:args == 1
    exec ':%s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
  else
    exec ':s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
  endif
endfunction

" Convert to camelCase
function! s:Camel(args) abort
  if a:args == 1
    exec ':%s#\%($\%(\k\+\)\)\@<=_\(\k\)#\u\1#g'
  else
    exec ':s#\%($\%(\k\+\)\)\@<=_\(\k\)#\u\1#g'
  endif
endfunction

" allows for easy jumping using commands like ili, ls, dli, etc.
function! CCR()
    let cmdline = getcmdline()
    if cmdline =~ '\v\C^(ls|files|buffers)'
        " like :ls but prompts for a buffer command
        return "\<CR>:b"
    elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
        " like :g//# but prompts for a command
        return "\<CR>:"
    elseif cmdline =~ '\v\C^(dli|il)'
        " like :dlist or :ilist but prompts for a count for :djump or :ijump
        return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
    elseif cmdline =~ '\v\C^(cli|lli)'
        " like :clist or :llist but prompts for an error/location number
        return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
    elseif cmdline =~ '\C^old'
        " like :oldfiles but prompts for an old file to edit
        set nomore
        return "\<CR>:sil se more|e #<"
    elseif cmdline =~ '\C^changes'
        " like :changes but prompts for a change to jump to
        set nomore
        return "\<CR>:sil se more|norm! g;\<S-Left>"
    elseif cmdline =~ '\C^ju'
        " like :jumps but prompts for a position to jump to
        set nomore
        return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
    elseif cmdline =~ '\C^marks'
        " like :marks but prompts for a mark to jump to
        return "\<CR>:norm! `"
    elseif cmdline =~ '\C^undol'
        " like :undolist but prompts for a change to undo
        return "\<CR>:u "
    else
        return "\<CR>"
    endif
endfunction

command! -bang -nargs=* Snake call s:Snake(<q-args>)
command! -bang -nargs=* Camel call s:Camel(<q-args>)
