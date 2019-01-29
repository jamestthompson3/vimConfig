let b:ale_linters = ['tslint', 'tsserver']
let b:ale_fixers = ['prettier']

nnoremap <silent> gh :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> K :ALEFindReferences<CR>

if !exists('g:loaded_ts_config')
  runtime $MYVIMRC.g:file_separator.'modules'.g:file_separator.'ecmacommon.vim'
  packadd ultisnips

  let g:loaded_ts_config = 1
endif
