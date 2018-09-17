let g:ale_completion_enabled = 1
let b:ale_linters = ['tslint']
let b:ale_fixers = ['prettier']
if !exists('g:gui_oni')
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
endif

