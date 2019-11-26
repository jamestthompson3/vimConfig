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
    for item in b:source_ft
      try
        execute 'find '.l:filename.'.'.item
      catch /^Vim\%((\a\+)\)\=:E/
      endtry
    endfor
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

function! tools#OpenQuickfix()
  if get(g:, 'qf_auto_open_quickfix', 1)
    " get user-defined maximum height
    let max_height = get(g:, 'qf_max_height', 10) < 1 ? 10 : get(g:, 'qf_max_height', 10)
    execute get(g:, "qf_auto_resize", 1) ? 'cclose|' . min([ max_height, len(getqflist()) ]) . 'cwindow' : 'cwindow'
  endif
endfunction

function! tools#PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('justinmk/vim-dirvish')
  call packager#add('thinca/vim-localrc')

  call packager#add('andymass/vim-matchup', { 'type': 'opt' })
  call packager#add('davidhalter/jedi-vim', { 'type': 'opt' })
  call packager#add('dense-analysis/ale', { 'type': 'opt' })
  call packager#add('jamestthompson3/vim-apathy', { 'type': 'opt' })
  call packager#add('junegunn/rainbow_parentheses.vim', { 'type': 'opt' })
  call packager#add('junegunn/fzf.vim', { 'type': 'opt' })
  call packager#local('/usr/local/opt/fzf', { 'type': 'opt' })
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('lifepillar/vim-mucomplete', { 'type': 'opt' })
  call packager#add('ludovicchabant/vim-gutentags', { 'type': 'opt' })
  call packager#add('majutsushi/tagbar', { 'type': 'opt' })
  call packager#add('neovim/nvim-lsp', { 'type': 'opt' })
  call packager#add('reedes/vim-wordy', { 'type': 'opt' })
  call packager#add('romainl/vim-cool', { 'type': 'opt'})
  call packager#add('tmsvg/pear-tree', {'type': 'opt'})
  call packager#add('tpope/vim-commentary', { 'type': 'opt'})
  call packager#add('tpope/vim-markdown', { 'type': 'opt' })
  call packager#add('tpope/vim-surround', { 'type': 'opt' })

  " TEMP
  call packager#add('scrooloose/vim-slumlord', { 'type': 'opt' })
  call packager#add('aklt/plantuml-syntax', { 'type': 'opt' })
endfunction


function! tools#loadDeps() abort
  if exists('g:loadedDeps')
    return
  else


    " plugin globals:
    let g:netrw_localrmdir = 'rm -r'
    let g:netrw_banner=0
    let g:netrw_winsize=45
    let g:netrw_liststyle=3
    let g:gutentags_cache_dir = '~/.cache/'
    let g:gutentags_project_root = ['Cargo.toml']
    let g:gutentags_file_list_command = 'fd . -c never'
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#no_mappings = 1
    let g:mucomplete#buffer_relative_paths = 1
    let g:mucomplete#chains = {}
    let g:mucomplete#chains.default = ['omni','tags', 'c-p', 'c-n', 'keyn', 'keyp', 'incl', 'defs', 'file', 'path']
    let g:mucomplete#minimum_prefix_length = 1
    let g:matchup_matchparen_deferred = 1
    let g:matchup_match_paren_timeout = 100
    let g:matchup_matchparen_stopline = 200
    let g:matchup_matchparen_offscreen = {'method': 'popup'}
    let g:pear_tree_map_special_keys = 0
    let g:pear_tree_pairs = {
          \   '(': {'closer': ')'},
          \   '[': {'closer': ']'},
          \   '{': {'closer': '}'},
          \   "'": {'closer': "'"},
          \   '"': {'closer': '"'},
          \   '`': {'closer': '`'},
          \   '/\*': {'closer': '\*/'}
          \ }

    let g:pear_tree_smart_openers = 1
    let g:pear_tree_smart_closers = 1
    let g:pear_tree_smart_backspace = 1
    let g:pear_tree_timeout = 60
    let g:pear_tree_repeatable_expand = 1
    let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

    " ALE:
    let g:ale_completion_delay = 20
    let g:ale_linters_explicit = 1
    let g:ale_sign_error = 'X'
    let g:ale_sign_warning = '◉'
    let g:ale_close_preview_on_insert = 1
    let g:ale_fix_on_save = 1
    let g:ale_lint_on_insert_leave = 0
    let g:ale_lint_on_text_changed = 0
    let g:ale_list_window_size = 5
    let g:ale_virtualtext_cursor = 1
    let g:ale_javascript_prettier_use_local_config = 1
    let g:ale_echo_msg_format = '[%linter%] %s'
    let g:ale_sign_column_always = 0

    packadd ale
    packadd cfilter
    packadd pear-tree
    packadd rainbow_parentheses.vim
    packadd tagbar
    packadd fzf
    packadd fzf.vim
    packadd nvim-lsp
    packadd vim-apathy
    packadd vim-commentary
    packadd vim-cool
    packadd vim-gutentags
    packadd vim-matchup
    packadd vim-mucomplete
    packadd vim-surround
    try
      silent cscope add cscope.out
    catch /^Vim\%((\a\+)\)\=:E/
    endtry

lua << EOF
  local nvim_lsp = require('nvim_lsp')
  local diagnostic = require('user_lsp')
  vim.lsp.default_callbacks['textDocument/publishDiagnostics'] = diagnostic.buf_diagnostics_set_signs
  nvim_lsp.tsserver.setup({})
  nvim_lsp.rls.setup({})
  nvim_lsp.sumneko_lua.setup({})
EOF
    augroup LSP
      au!
      autocmd! CursorHold * :lua vim.lsp.util.show_line_diagnostics()
    augroup END
    let g:loadedDeps = 1
  endif
endfunction
