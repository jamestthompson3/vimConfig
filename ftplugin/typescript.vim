let g:ale_completion_enabled = 1
let b:ale_linters = ['tslint']
let b:ale_fixers = ['prettier']
if !g:isOni
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif

