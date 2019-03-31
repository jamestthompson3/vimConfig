scriptencoding utf-8

function! tools#ShowDeclaration(global) abort
    let pos = getpos('.')
    if searchdecl(expand('<cword>'), a:global) == 0
        let line_of_declaration = line('.')
        execute line_of_declaration . '#'
    endif
    call cursor(pos[1], pos[2])
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

" Replace things in the quick fix list
function! tools#Replace_qf(term1, term2) abort
  let tools#replace_string = printf('/\<%s\>/%s/g', a:term1, a:term2)
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
  packadd vista.vim
  execute 'Vista'
endfunction


function! tools#gitCommand()
  if g:isWindows
    return trim(system("git rev-parse --abbrev-ref HEAD 2> NUL | tr -d '\n'"))
  else
    return trim(system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'"))
  endif
endfunction

function! tools#gitStat()
  if g:isWindows
    return trim(system("'git diff --shortstat 2> NUL | tr -d '\n'"))
  else
    return trim(system("git diff --shortstat 2> /dev/null | tr -d '\n'"))
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

" TODO improve this
function! tools#GetFilesByType(ft) abort
 call setqflist([], ' ', {'title': 'Files', 'lines': systemlist('fd '.a:ft)})
 execute 'copen'
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
      hi! link previewWord TODO
    exe 'match previewWord "\%' . line('.') . 'l\%' . col('.') . 'c\k*"'
      wincmd p			" back to old window
    endif
  endif
endfunction

function! tools#makeScratch() abort
  execute 'new'
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
endfunction

function! tools#GitManager() abort
  execute 'tabnew'
  execute 'term lazygit'
endfunction

function! tools#HighlightRegion(color)
  hi Green guibg=#77ff77 guifg=#000000
  let l_start = line("'<")
  let l_end = line("'>") + 1
  execute 'syntax region '.a:color.' start=/\%'.l_start.'l/ end=/\%'.l_end.'l/'
endfunction


function! tools#UnHighlightRegion()
  let l_start = line("'<")
  let l_end = line("'>") + 1
  execute 'syntax off start=/\%'.l_start.'l/ end=/\%'.l_end.'l/'
  execute 'syntax on start=/\%'.l_start.'l/ end=/\%'.l_end.'l/'
endfunction

function! tools#BufSel(pattern) abort
  let bufcount = bufnr('$')
  let currbufnr = 1
  let nummatches = 0
  let firstmatchingbufnr = 0
  while currbufnr <= bufcount
    if(bufexists(currbufnr))
      let currbufname = bufname(currbufnr)
      if(match(currbufname, a:pattern) > -1)
        echo currbufnr . ': '. bufname(currbufnr)
        let nummatches += 1
        let firstmatchingbufnr = currbufnr
      endif
    endif
    let currbufnr = currbufnr + 1
  endwhile
  if(nummatches == 1)
    execute ':buffer '. firstmatchingbufnr
  elseif(nummatches > 1)
    let desiredbufnr = input('Enter buffer number: ')
    if(strlen(desiredbufnr) != 0)
      execute ':buffer '. desiredbufnr
    endif
  else
    echo 'No matching buffers'
  endif
endfunction

function! tools#PackagerInit() abort
    packadd vim-packager
    call packager#init()
    call packager#add('justinmk/vim-dirvish')
    call packager#add('mhinz/vim-startify')
    call packager#add('romainl/vim-cool')
    call packager#add('thinca/vim-localrc')
    call packager#add('tmsvg/pear-tree')
    call packager#add('tpope/vim-commentary')
    call packager#add('tpope/vim-repeat')

    call packager#add('romainl/vim-qf', { 'type': 'opt'})
    call packager#add('SirVer/ultisnips', { 'type': 'opt' })
    call packager#add('andymass/vim-matchup', { 'type': 'opt' })
    call packager#add('RRethy/vim-hexokinase', { 'type': 'opt' })
    call packager#add('elzr/vim-json', { 'type': 'opt' })
    call packager#add('felixge/vim-nodejs-errorformat', { 'type': 'opt' })
    call packager#add('iamcco/markdown-preview.nvim', { 'type': 'opt', 'do': 'cd app && yarn install' })
    call packager#add('jamestthompson3/vim-better-javascript-completion', { 'type': 'opt' })
    call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
    call packager#add('leafgarland/typescript-vim', { 'type': 'opt' })
    call packager#add('lifepillar/vim-mucomplete', { 'type': 'opt' })
    call packager#add('liuchengxu/vista.vim', { 'type': 'opt' })
    call packager#add('ludovicchabant/vim-gutentags', { 'type': 'opt' })
    call packager#add('neoclide/coc.nvim', { 'type': 'opt', 'do': 'yarn install' })
    call packager#add('peitalin/vim-jsx-typescript', { 'type': 'opt' })
    call packager#add('racer-rust/vim-racer', { 'type': 'opt' })
    call packager#add('reasonml-editor/vim-reason-plus', { 'type': 'opt' })
    call packager#add('rhysd/git-messenger.vim', { 'type': 'opt' })
    call packager#add('sheerun/vim-polyglot', { 'type': 'opt' })
    call packager#add('tpope/vim-scriptease', { 'type': 'opt' })
    call packager#add('tpope/vim-fugitive', { 'type': 'opt' })
    call packager#add('tpope/vim-surround', { 'type': 'opt' })
    call packager#add('vimwiki/vimwiki', { 'type': 'opt' })
    call packager#add('w0rp/ale', { 'type': 'opt' })
    call packager#add('zirrostig/vim-schlepp', { 'type': 'opt' })
endfunction


function! tools#loadDeps() abort
  if exists('g:loadedDeps')
    return
  else
    packadd ale
    packadd vim-qf
    packadd vim-polyglot
    packadd git-messenger.vim
    packadd vim-hexokinase
    packadd vim-gutentags
    packadd vim-matchup
    packadd vim-schlepp
    packadd vim-surround
    packadd vim-mucomplete
    packadd vim-fugitive
    let g:loadedDeps = 1
  endif
endfunction
