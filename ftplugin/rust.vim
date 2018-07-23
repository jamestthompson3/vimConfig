" function! OpenRefs() abort
"   call LanguageClient#textDocument_references()
"   exec ':lopen'
" endfunction

" nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gh :ALEHover<CR>
nnoremap <silent> K :ALEFindReferences<CR>
" nnoremap <silent> K :call OpenRefs()<CR>
nnoremap <silent> <leader>R :RustRun<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" let g:rustfmt_autosave = 1
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif
call asyncomplete#register_source(
    \ asyncomplete#sources#racer#get_source_options())
