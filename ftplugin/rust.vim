let b:ale_fixers = ['rustfmt']

let g:mucomplete#chains.rust = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>

set omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

compiler cargo

