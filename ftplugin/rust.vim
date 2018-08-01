if !exists('g:gui_oni')
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif
call asyncomplete#register_source(
    \ asyncomplete#sources#racer#get_source_options())
