let b:ale_fixers = ['rustfmt']

let g:mucomplete#chains.rust = ['omni','tags','c-p', 'c-n','file','path', 'ulti']

lua require'user_lsp'.setMappings()

set omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

compiler cargo
