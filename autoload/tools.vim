scriptencoding utf-8
":filter! /term:/ oldfiles

function! tools#switchSourceHeader() abort
  if (expand ('%:e') != 'h')
    find %:t:r.h
  else
    let l:filename = expand('%:t:r')
    for item in b:source_ft
      try
        execute 'find '.l:filename.'.'.item
      catch /^Vim\%((\a\+)\)\=:E/
      endtry
    endfor
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

function! tools#PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('justinmk/vim-dirvish')
  call packager#add('thinca/vim-localrc')
  call packager#add('junegunn/fzf.vim')
  call packager#add('haorenW1025/completion-nvim')
  call packager#add('nvim-treesitter/nvim-treesitter')
  call packager#add('nvim-treesitter/completion-treesitter')

  call packager#add('aklt/plantuml-syntax', { 'type': 'opt' })
  call packager#add('andymass/vim-matchup', { 'type': 'opt' })
  call packager#add('davidhalter/jedi-vim', { 'type': 'opt' })
  call packager#add('dense-analysis/ale', { 'type': 'opt' })
  call packager#add('fcpg/vim-waikiki', { 'type': 'opt' })
  call packager#add('jamestthompson3/vim-apathy', { 'type': 'opt' })
  call packager#add('junegunn/fzf', { 'do': 'call fzf#install()'})
  call packager#add('junegunn/rainbow_parentheses.vim', { 'type': 'opt' })
  call packager#local('~/code/nvim-remote-containers', { 'type': 'opt' })
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('ludovicchabant/vim-gutentags', { 'type': 'opt' })
  call packager#add('majutsushi/tagbar', { 'type': 'opt' })
  call packager#add('neovim/nvim-lsp', { 'type': 'opt' })
  call packager#add('norcalli/nvim-colorizer.lua', { 'type': 'opt' })
  call packager#add('reedes/vim-wordy', { 'type': 'opt' })
  call packager#add('romainl/vim-cool', { 'type': 'opt'})
  call packager#add('tmsvg/pear-tree', {'type': 'opt'})
  call packager#add('tpope/vim-commentary', { 'type': 'opt'})
  call packager#add('tpope/vim-surround', { 'type': 'opt' })

endfunction


function! tools#loadCscope() abort
  try
    silent cscope add cscope.out
  catch /^Vim\%((\a\+)\)\=:E/
  endtry
endfunction
