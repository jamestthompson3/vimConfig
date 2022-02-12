local M = {}

function M.bootstrap()
	vim.bo.suffixesadd = ".go"
	vim.api.nvim_command([[ setlocal makeprg=go\ run ]])
end

return M
