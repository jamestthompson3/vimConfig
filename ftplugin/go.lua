vim.bo.suffixesadd = ".go"
if vim.bo.readonly ~= true then
	require("tt.snippets.ft.go").init()
end
