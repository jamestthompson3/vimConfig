nnoremap <silent> gh :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gl :pc<CR>
nnoremap <silent> <leader>K :ALEFindReferences<CR>
nnoremap <silent> <leader>R :RustRun<CR>
let g:rustfmt_autosave = 1
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif
