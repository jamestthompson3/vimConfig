let b:ale_fixers = ['rustfmt']

let g:mucomplete#chains.rust = ['omni','tags','keyn', 'keyp', 'c-p', 'c-n','file','path', 'ulti']

nnoremap <silent> ge <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>

set omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

compiler cargo
