local M = {}
local function search_files(search)
	local path = vim.opt.path:get()
	local path_str = table.concat(path, ",")
	local l = vim.fn.globpath(path_str, "*", false, true)
	local res = vim.fn.matchfuzzy(l, search)
	vim.ui.select(res, {
		prompt = "Choose file",
	}, function(choice)
		vim.cmd.edit(choice)
	end)
end

function M.init()
	vim.api.nvim_create_user_command("Find", function(p)
		search_files(p.args)
	end, { nargs = "*" })
	require("fzf-lua").setup({
		"max-perf",
		winopts = { preview = { hidden = "hidden" } },
	})
end

return M
