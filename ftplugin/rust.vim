packadd coc.nvim

" nnoremap <silent> gd :ALEGoToDefinition<CR>
" nnoremap <silent> gh :ALEHover<CR>
" nnoremap <silent> K :ALEFindReferences<CR>
" let b:ale_linters =  ['rls']

nnoremap <silent> gh :call CocAction('doHover')<CR>
nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> K <plug>(coc-references)
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

let b:ale_fixers = ['rustfmt']

let g:mucomplete#chains.rust = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']
let g:ale_completion_enabled = 0

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

compiler cargo
