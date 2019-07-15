nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> gh :call CocAction('doHover')<CR>
nnoremap <silent> K <Plug>(coc-references)

"let b:ale_linters =  ['rls']
let b:ale_fixers = ['rustfmt']

let g:mucomplete#chains.rust = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

compiler cargo
