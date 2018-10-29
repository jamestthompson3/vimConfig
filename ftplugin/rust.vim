" if !exists('g:gui_oni')
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> gh :ALEHover<CR>
  nnoremap <silent> K :ALEFindReferences<CR>
" endif
let b:ale_linters =  ['rls']
let b:ale_fixers = ['rustfmt']

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif
let g:ale_completion_enabled = 1

compiler cargo
" let g:racer_cmd = system('which racer)
