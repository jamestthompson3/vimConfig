scriptencoding utf-8
":filter! /term:/ oldfiles
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

function! tools#switchSourceHeader() abort
  if (expand ('%:e') != 'h')
    find %:t:r.h
  else
    let l:filename = expand('%:t:r')
    execute 'find '.l:filename.'.'.b:source_ft
  endif
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

" TODO improve this
function! tools#GetFilesByType(ft) abort
  call setqflist([], ' ', {'title': 'Files', 'lines': systemlist('fd '.a:ft)})
  execute 'copen'
endfunction

function! tools#makeScratch() abort
  execute 'new'
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
endfunction

function! tools#redir(cmd)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let output = system(matchstr(a:cmd, '^!\zs.*'))
  else
    redir => output
    execute a:cmd
    redir END
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  nnoremap <buffer> q <c-w>c
  call setline(1, split(output, "\n"))
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

function! tools#smoothScroll(up)
  execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
  redraw
  for l:count in range(3, &scroll, 2)
    sleep 10m
    execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
    redraw
  endfor
endfunction

function! tools#CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

function! s:cmd() abort
  if executable("xdg-open")
    return "xdg-open"
  endif
  if executable("open")
    return "open"
  endif
  return "explorer"
endfunction

function! tools#getStub() abort
  if exists('b:devURL')
    let l:url = b:devURL
  else
    let l:url = " 'https://devdocs.io/#q="
  endif
  return s:cmd() . l:url
endfunction



function! tools#simpleMru() abort
  let cur_file = expand("%:.")
  let skip_first_file = 0

  enew
  setl buftype=nowrite nobuflisted bufhidden=delete noswapfile
  map <buffer> <silent> <CR> gf
  wviminfo | rviminfo!

  for oldfile in v:oldfiles
    let rel_file = fnamemodify(oldfile, ":.")

    if rel_file[0] == "/" || rel_file[0] == "."
      continue
    endif

    if line("$") == 1 && rel_file == cur_file
      let skip_first_file = 1
    endif

    call append(line("$") - 1, rel_file)
  endfor

  if skip_first_file
    :2
  else
    :1
  endif
endfunction

function! tools#PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('thinca/vim-localrc')
  call packager#add('justinmk/vim-dirvish')

  call packager#add('RRethy/vim-hexokinase', { 'type': 'opt' })
  call packager#add('SirVer/ultisnips', { 'type': 'opt' })
  call packager#add('andymass/vim-matchup', { 'type': 'opt' })
  call packager#add('jamestthompson3/vim-better-javascript-completion', { 'type': 'opt' })
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('lifepillar/vim-mucomplete', { 'type': 'opt' })
  call packager#add('majutsushi/tagbar', { 'type': 'opt' })
  call packager#add('ludovicchabant/vim-gutentags', { 'type': 'opt' })
  call packager#add('neoclide/coc.nvim', { 'type': 'opt', 'do': 'yarn install' })
  call packager#add('reasonml-editor/vim-reason-plus', { 'type': 'opt' })
  call packager#add('romainl/vim-cool', { 'type': 'opt'})
  call packager#add('romainl/vim-qf', { 'type': 'opt'})
  call packager#add('sheerun/vim-polyglot', { 'type': 'opt' })
  call packager#add('tmsvg/pear-tree', {'type': 'opt'})
  call packager#add('joelstrouts/swatch.vim', {'type': 'opt'})
  call packager#add('tpope/vim-commentary', { 'type': 'opt'})
  call packager#add('tpope/vim-scriptease', { 'type': 'opt' })
  call packager#add('tpope/vim-surround', { 'type': 'opt' })
  call packager#add('tpope/vim-repeat', { 'type': 'opt' })
  call packager#add('vimwiki/vimwiki', { 'type': 'opt' })
  call packager#add('w0rp/ale', { 'type': 'opt' })
endfunction


function! tools#loadDeps() abort
  if exists('g:loadedDeps')
    return
  else
    packadd ale
    packadd tagbar
    packadd vim-qf
    packadd pear-tree
    packadd vim-cool
    packadd vim-commentary
    packadd vim-polyglot
    packadd vim-hexokinase
    packadd vim-gutentags
    packadd vim-matchup
    packadd vim-surround
    packadd vim-mucomplete
    try
      silent cscope add cscope.out
    catch /^Vim\%((\a\+)\)\=:E/
    endtry
    let g:loadedDeps = 1
  endif
endfunction
