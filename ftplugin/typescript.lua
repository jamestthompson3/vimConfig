vim.bo.formatoptions = vim.bo.formatoptions .. "o"
require("tt.ft.ecma").bootstrap()
require("tt.snippets.ft.typescript").init()
vim.api.nvim_create_user_command("ShowFuncs", function()
	if vim.b.showfunc == true then
		vim.cmd("hi! link @lsp.type.function.typescript Identifier")
	else
		vim.cmd("hi! link @lsp.type.function.typescript @comment.block.c")
		vim.b.showfunc = true
	end
end, {})
