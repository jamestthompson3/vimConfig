vim.bo.formatoptions = vim.bo.formatoptions .. "o"
require("tt.ft.ecma").bootstrap()
require("tt.snippets.ft.typescript").init()
vim.api.nvim_create_user_command("ShowFuncs", function()
	vim.b.showfunc = not vim.b.showfunc
	local link = vim.b.showfunc and "@comment.block.c" or "Identifier"
	vim.api.nvim_set_hl(0, "@lsp.type.function.typescript", { link = link })
end, {})
