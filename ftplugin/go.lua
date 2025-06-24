vim.bo.suffixesadd = ".go"
vim.lsp.start(vim.lsp.config.efm)
if vim.bo.readonly ~= true then
	require("tt.snippets.ft.go")
end
