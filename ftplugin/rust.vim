execute 'packadd vim-racer'

nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gh :ALEHover<CR>
nnoremap <silent> K :ALEFindReferences<CR>
let b:ale_linters =  ['rls']
let b:ale_fixers = ['rustfmt']
let g:racer_experimental_completer = 1

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

compiler cargo
