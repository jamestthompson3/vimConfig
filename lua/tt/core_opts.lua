local is_windows = require("tt.platform").is_windows

-- fish is only for :terminal (see tt.platform.term_shell). sh starts faster for
-- :! and system(), and does not print interactive shell output into the result.
if not is_windows then
	vim.o.shell = "sh"
end

vim.ui.select = require("tt.pick").select

-- Common mistakes
local typos = {
	retrun = "return",
	pritn = "print",
	cosnt = "const",
	imoprt = "import",
	imprt = "import",
	iomprt = "import",
	improt = "import",
	slef = "self",
	sapn = "span",
	teh = "the",
	tehn = "then",
	hadnler = "handler",
	typdef = "typedef",
	bunlde = "bundle",
}
for wrong, right in pairs(typos) do
	vim.keymap.set("ia", wrong, right)
end

vim.o.tabline = "%{%v:lua.require'tt.core_opts'.tabline()%}"

local function tabline_label(bufnr)
	local label = vim.b[bufnr].term_title or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
	return (label:gsub("%%", "%%%%"))
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
