let b:ale_linters = ['tsserver']
let b:ale_fixers = ['prettier']
packadd vim-jsx-typescript
if !g:isOni
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif

