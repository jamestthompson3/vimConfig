" vimfiler
let g:vimfiler_as_default_explorer = 1
function! s:open_vimfiler() abort
  silent VimFiler
endfunction
nnoremap <silent> <F3> :call <SID>open_vimfiler()<CR>
let g:vimfiler_tree_opened_icon = get(g:, 'vimfiler_tree_opened_icon', '▼')
" let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:vimfiler_tree_closed_icon = get(g:, 'vimfiler_tree_closed_icon', '▷')
let g:vimfiler_file_icon = get(g:, 'vimfiler_file_icon', '')
let g:vimfiler_tree_leaf_icon = ''
let g:vimfiler_readonly_file_icon = get(g:, 'vimfiler_readonly_file_icon', '*')
let g:vimfiler_marked_file_icon = get(g:, 'vimfiler_marked_file_icon', '√')
let g:vimfiler_ignore_pattern = get(g:, 'vimfiler_ignore_pattern', [
      \ '^\.git$',
      \ '^\.DS_Store$',
      \ '^\.init\.vim-rplugin\~$',
      \ '^\.netrwhist$',
      \ '\.class$',
      \ '^\.'
      \])

call vimfiler#custom#profile('custom', 'context', {
      \ 'explorer' : 1,
      \ 'winwidth' : 30,
      \ 'winminwidth' : 30,
      \ 'toggle' : 1,
      \ 'auto_expand': 1,
      \ 'direction' : 'rightbelow',
      \ 'parent': 0,
      \ 'status' : 1,
      \ 'safe' : 0,
      \ 'split' : 1,
      \ 'hidden': 1,
      \ 'no_quit' : 1,
      \ 'force_hide' : 0,
      \ })
" Completion tools
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))
call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'whitelist': ['c'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 50000000,
    \  },
    \ }))

" autoclose
let g:closetag_filenames = ['*.html,*.xhtml,*.phtml', '*.js', '*.jsx', '*.tsx']
