nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>h <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

setl omnifunc=v:lua.vim.lsp.omnifunc