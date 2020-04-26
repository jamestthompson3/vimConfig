nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> ge <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap M :luafile %<CR>

setl omnifunc=v:lua.vim.lsp.omnifunc
