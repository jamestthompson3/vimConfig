scriptencoding utf-8

function! tools#run_fzf(command)
  packadd fzf
 call fzf#run({
     \ 'source': a:command,
     \ 'sink':   function('tools#edit_file'),
     \ 'options': '-m',
     \ 'down': '40%'
     \ })
endfunction

function! tools#run_fzf_list(list)
  packadd fzf
 call fzf#run({
     \ 'source': a:list,
     \ 'sink':   function('tools#edit_file'),
     \ 'options': '-m',
     \ 'down': '40%'
     \ })
endfunction

function! tools#ShowDeclaration(global) abort
    let pos = getpos('.')
    if searchdecl(expand('<cword>'), a:global) == 0
        let line_of_declaration = line('.')
        execute line_of_declaration . '#'
    endif
    call cursor(pos[1], pos[2])
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
function! s:IsReadable(idx, val)
    return filereadable(expand(a:val))
endfunction
  function! s:generate_mru()
    let l:mru_files = map(filter(copy(v:oldfiles), function('s:IsReadable')), { idx, val -> substitute(val, '\\', '/','g') })
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

function! tools#RenameFile() abort
  let l:oldName = getline('.')
  let l:newName = input('Rename: ', l:oldName, 'file')
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
  exec 'silent bufdo grepadd'.' '.l:pattern.' %'
  exec 'cwindow'
endfunction

function! tools#Confirm(find, replace) abort
  let tools#replace_string = printf('/\<%s\>/%s/g', a:find, a:replace)
  exec 'cwindow'
  function! tools#Replace_words()
    exec 'silent cfdo %s'.tools#replace_string.' | update'
  endfunction
  command! ReplaceAll call tools#Replace_words()
endfunction

function! tools#FindReplace(callback) abort
  let l:find = input('Find > ')
  if l:find == ''
    return
  endif
  let l:replace = input('Replace > ')

  exec 'silent grep! '.l:find
  call tools#Confirm(l:find, l:replace)
endfunction

" Replace things in the quick fix list
function! tools#Replace_qf(args) abort
  let l:arg_list = split(a:args, ' ')
  let tools#replace_string = printf('/\<%s\>/%s/g', l:arg_list[0], l:arg_list[1])
  exec 'silent cfdo %s'.tools#replace_string.' | update'
endfunction

" Convert to snake_case
function! tools#Snake(args) abort
  if a:args == 1
    exec '%s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
  else
    exec 's#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
  endif
endfunction

" Convert to camelCase
function! tools#Camel(args) abort
  if a:args == 1
    exec '%s#\%($\%(\k\+\)\)\@<=_\(\k\)#\u\1#g'
  else
    exec 's#\%($\%(\k\+\)\)\@<=_\(\k\)#\u\1#g'
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
  execute 'ltag '.expand('<cword>')
  execute 'lwindow'
endfunction

function! tools#loadTagbar() abort
  packadd tagbar
  execute 'TagbarOpen'
endfunction

function! tools#loadDeps() abort
  let l:multiWindow = winnr('$') > 1
  packadd ale
  packadd vim-polyglot
  packadd fzf.vim
  packadd vim-fugitive
  packadd vim-gutentags
  packadd vim-matchup
  packadd vim-schlepp
  packadd vim-surround
  packadd vim-mucomplete
  if l:multiWindow
    packadd vim-buftabline
  endif
endfunction

function! tools#gitCommand()
  if g:isWindows
    return trim(system("git rev-parse --abbrev-ref HEAD 2> NUL | tr -d '\n'"))
  else
    return trim(system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'"))
  endif
endfunction

function! tools#manageSession() abort
  let l:sessionName = tools#gitCommand()
  let l:sessionPath = '~'.g:file_separator.'sessions'.g:file_separator
  let l:cur_dir = substitute(getcwd(), '\\', '/', 'g')
  let l:filePath = substitute(expand('%:p:h'), '\\', '/', 'g')
  let l:altName = substitute(l:filePath, l:cur_dir, '', '')
  return [l:sessionName, l:sessionPath, l:altName]
endfunction

function! tools#saveSession(argsList) abort
  let [ sessionName, sessionPath, altName ] = a:argsList
  if sessionName != ''
    if sessionName == 'master'
      return
    else
      execute 'mks! '.sessionPath.trim(sessionName).'.vim'
    endif
  else
    execute 'mks! '.sessionPath.altName.'.vim'
  endif
endfunction

function! tools#PackagerInit() abort
    packadd vim-packager
    call packager#init()
    call packager#add('tpope/vim-commentary')
    call packager#add('tpope/vim-repeat')
    call packager#add('romainl/vim-cool')
    call packager#add('romainl/vim-qf')
    call packager#add('justinmk/vim-dirvish')
    call packager#add('mattn/webapi-vim')
    call packager#add('thinca/vim-localrc')

    call packager#add('chrisbra/Colorizer', { 'type': 'opt' })
    call packager#add('andymass/vim-matchup', { 'type': 'opt' })
    call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
    call packager#add('kristijanhusak/vim-js-file-import', { 'type': 'opt', 'do': 'npm install' })
    call packager#add('vimwiki/vimwiki', { 'type': 'opt' })
    call packager#add('w0rp/ale', { 'type': 'opt' })
    call packager#add('junegunn/fzf', { 'type': 'opt', 'do': './install --all' })
    call packager#add('junegunn/fzf.vim', { 'type': 'opt' })
    call packager#add('majutsushi/tagbar', { 'type': 'opt' })
    call packager#add('SirVer/ultisnips', { 'type': 'opt' })
    call packager#add('jamestthompson3/vim-better-javascript-completion', { 'type': 'opt' })
    call packager#add('ap/vim-buftabline', { 'type': 'opt' })
    call packager#add('iamcco/markdown-preview.nvim', { 'type': 'opt', 'do': 'cd app && yarn install' })
    call packager#add('tpope/vim-fugitive', { 'type': 'opt' })
    call packager#add('ludovicchabant/vim-gutentags', { 'type': 'opt' })
    call packager#add('jamestthompson3/vim-jest', { 'type': 'opt' })
    call packager#add('elzr/vim-json', { 'type': 'opt' })
    call packager#add('lifepillar/vim-mucomplete', { 'type': 'opt' })
    call packager#add('sheerun/vim-polyglot', { 'type': 'opt' })
    call packager#add('racer-rust/vim-racer', { 'type': 'opt' })
    call packager#add('reasonml-editor/vim-reason-plus', { 'type': 'opt' })
    call packager#add('zirrostig/vim-schlepp', { 'type': 'opt' })
    call packager#add('tpope/vim-scriptease', { 'type': 'opt' })
    call packager#add('tpope/vim-speeddating', { 'type': 'opt' })
    call packager#add('tpope/vim-surround', { 'type': 'opt' })
  endfunction

function! tools#PreviewWord() abort
  if &previewwindow			" don't do this in the preview window
    return
  endif
  let w = expand('<cword>')		" get the word under cursor
  if w =~ '\a'			" if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P			" jump to preview window
    if &previewwindow			" if we really get there...
      match none			" delete existing highlight
      wincmd p			" back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
        exe 'ptag ' . w
    catch
      return
    endtry

    silent! wincmd P			" jump to preview window
    if &previewwindow		" if we really get there...
    if has('folding')
      silent! .foldopen		" don't want a closed fold
    endif
    call search('$', 'b')		" to end of previous line
    let w = substitute(w, '\\', '\\\\', '')
    call search('\<\V' . w . '\>')	" position cursor on match
    " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=green guibg=green
    exe 'match previewWord "\%' . line('.') . 'l\%' . col('.') . 'c\k*"'
      wincmd p			" back to old window
    endif
  endif
endfun
