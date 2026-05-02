local is_windows = vim.uv.os_uname().sysname == "Windows_NT"

if not is_windows then
	vim.o.shell = vim.fn.executable("fish") == 1 and "fish" or "bash"
end

vim.cmd.packadd("cfilter")

-- Common mistakes
vim.cmd.iabbrev({ args = { "retrun", "return" } })
vim.cmd.iabbrev({ args = { "pritn", "print" } })
vim.cmd.iabbrev({ args = { "cosnt", "const" } })
vim.cmd.iabbrev({ args = { "imoprt", "import" } })
vim.cmd.iabbrev({ args = { "imprt", "import" } })
vim.cmd.iabbrev({ args = { "iomprt", "import" } })
vim.cmd.iabbrev({ args = { "improt", "import" } })
vim.cmd.iabbrev({ args = { "slef", "self" } })
vim.cmd.iabbrev({ args = { "sapn", "span" } })
vim.cmd.iabbrev({ args = { "teh", "the" } })
vim.cmd.iabbrev({ args = { "tehn", "then" } })
vim.cmd.iabbrev({ args = { "hadnler", "handler" } })
vim.cmd.iabbrev({ args = { "typdef", "typedef" } })
vim.cmd.iabbrev({ args = { "bunlde", "bundle" } })

vim.o.tabline = "%{%v:lua.require'tt.core_opts'.tabline()%}"

function _G.tabline_label(bufnr)
	local title = vim.b[bufnr].term_title
	if title then
		return title
	end
	return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
end

local M = {}
M.tabline = function()
	local s = ""
	for i = 1, vim.fn.tabpagenr("$") do
		local win = vim.fn.tabpagewinnr(i)
		local buf = vim.fn.tabpagebuflist(i)[win]
		local label = tabline_label(buf)
		if i == vim.fn.tabpagenr() then
			s = s .. "%#TabLineSel# " .. label .. " "
		else
			s = s .. "%#TabLine# " .. label .. " "
		end
	end
	s = s .. "%#TabLineFill#"
	return s
end

vim.api.nvim_create_user_command("Diff", function()
	require("tt.git").diff()
end, {})

vim.api.nvim_create_user_command("Changed", function()
	require("tt.git").changedFiles()
end, {})

vim.api.nvim_create_user_command("Restore", function()
	require("tt.tools").restoreFile()
end, {})

vim.api.nvim_create_user_command("Redir", function(opts)
	require("tt.tools").redir(opts.args)
end, { nargs = 1, complete = "command" })

vim.api.nvim_create_user_command("Scratch", function()
	require("tt.tools").scratch()
end, {})

vim.api.nvim_create_user_command("Fqf", function(opts)
	require("tt.tools").files_to_qf(opts.args)
end, { nargs = 1 })

return M
