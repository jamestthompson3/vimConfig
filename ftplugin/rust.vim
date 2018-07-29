" function! OpenRefs() abort
"   call LanguageClient#textDocument_references()
"   exec ':lopen'
" endfunction


if !exists('g:gui_oni')
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
" nnoremap <silent> gd :ALEGoToDefinition<CR>
" nnoremap <silent> gh :ALEHover<CR>
" nnoremap <silent> K :call OpenRefs()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endif

nnoremap <silent> <leader>R :RustRun<CR>
" let g:rustfmt_autosave = 1
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif
call asyncomplete#register_source(
    \ asyncomplete#sources#racer#get_source_options())
