scriptencoding utf-8

function! tools#run_fzf(command)
 call fzf#run({
     \ 'source': a:command . ' | devicon-lookup',
     \ 'sink':   function('tools#edit_file'),
     \ 'options': '-m',
     \ 'down': '40%'
     \ })
endfunction

function! tools#run_fzf_list(list)
 call fzf#run({
     \ 'source': a:list,
     \ 'sink':   function('tools#edit_file'),
     \ 'options': '-m',
     \ 'down': '40%'
     \ })
endfunction


function! tools#edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[l:pos+1:-1]
    echom l:file_path
    execute 'silent e' l:file_path
endfunction

function! tools#Fzf_dev(no_git) abort
  " Needs to be fixed on Windows
  " if executable('nf')
  "   let l:file_list_command = 'nf'
  "   let l:file_list_command_no_git = 'nf --no-ignore'
  " else
    let l:file_list_command = 'rg --files'
    let l:file_list_command_no_git = 'rg --files --no-ignore'
  " endif

   if !a:no_git
    call tools#run_fzf(l:file_list_command)
  else
    call tools#run_fzf(l:file_list_command_no_git)
  endif
endfunction

function! tools#Fzf_mru() abort " Search most recently used files
  function! s:generate_mru()
    let l:mru_path_command = printf('sed "1d" %s', g:neomru#file_mru_path)
    let l:mru_files = split(system(l:mru_path_command.' | devicon-lookup'), '\n')
    let l:cur_dir = substitute(getcwd(), '\\', '/', 'g')
    let l:filtered_files = filter(l:mru_files, {idx, val -> stridx(val, cur_dir) >= 0} )
    return map(l:filtered_files, {idx, val -> substitute(val, cur_dir.'/', '', '')})
  endfunction
  call tools#run_fzf_list(s:generate_mru())
endfunction

function! tools#open_branch_fzf(line)
  let l:parser = split(a:line)
  let l:branch = l:parser[0]
  if l:branch ==? '*'
    let l:branch = l:parser[1]
  endif
  execute '!git checkout ' . l:branch
endfunction

function! tools#GrepToQF(pattern) abort
    let l:grepPattern = ':silent grep! '.a:pattern
    exec l:grepPattern
endfunction

function! tools#RenameFile() abort
  let l:oldName = getline('.')
  let l:newName = input('Rename atools# ', l:oldName, 'file')
  if newName != '' && newName != oldName
    call rename(oldName, newName)
    call feedkeys('R')
  endif
endfunction

function! tools#DeleteFile() abort
  call system(printf('rm -rf %s',getline('.')))
  call feedkeys('R')
endfunction


function! tools#GrepBufs() abort
  let l:pattern  = input('Search > ')
  exec ':silent bufdo grepadd'.' '.l:pattern.' %'
  exec ':cwindow'
endfunction

function! tools#Confirm(find, replace) abort
  let tools#replace_string = printf('/\<%s\>/%s/g', a:find, a:replace)
  exec ':cwindow'
  function! tools#Replace_words()
    exec ':silent cfdo %s'.tools#replace_string.' | update'
  endfunction
  command! ReplaceAll call tools#Replace_words()
endfunction

function! tools#FindReplace(callback) abort
  let l:find = input('Find > ')
  if l:find == ''
    return
  endif
  let l:replace = input('Replace > ')
  call tools#GrepToQF(l:find)
  call tools#Confirm(l:find, l:replace)
endfunction

" Replace things in the quick fix list
function! tools#Replace_qf(args) abort
  let l:arg_list = split(a:args, ' ')
  let tools#replace_string = printf('/\<%s\>/%s/g', l:arg_list[0], l:arg_list[1])
  exec ':silent cfdo %s'.tools#replace_string.' | update'
endfunction

" Convert to snake_case
function! tools#Snake(args) abort
  if a:args == 1
    exec ':%s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
  else
    exec ':s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
  endif
endfunction

" Convert to camelCase
function! tools#Camel(args) abort
  if a:args == 1
    exec ':%s#\%($\%(\k\+\)\)\@<=_\(\k\)#\u\1#g'
  else
    exec ':s#\%($\%(\k\+\)\)\@<=_\(\k\)#\u\1#g'
  endif
endfunction

" allows for easy jumping using commands like ili, ls, dli, etc.
function! tools#CCR()
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

" list all associated tags with cursor word
function! tools#ListTags() abort
  exec('ltag '.expand('<cword>'))
  exec('lwindow')
endfunction

