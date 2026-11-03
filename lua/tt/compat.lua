local M = {}

function M.noautocmd(fn)
	local saved = vim.o.eventignore
	vim.o.eventignore = "all"
	local ok, result = xpcall(fn, debug.traceback)
	vim.o.eventignore = saved
	if not ok then
		error(result, 0)
	end
	return result
end

function M.enable_ui2()
	if vim.g.enable_ui2 == false then
		return
	end
	local ok, ui = pcall(require, "vim._core.ui2")
	if not ok then
		return
	end
	local enabled, err = pcall(ui.enable)
	if not enabled then
		vim.schedule(function()
			vim.notify("UI2 unavailable: " .. tostring(err), vim.log.levels.WARN)
		end)
	end
end

function M.reload_directory(buf)
	vim.api.nvim_buf_call(buf, function()
		local mapping = vim.fn.maparg("<Plug>(nvim-dir-reload)", "n", false, true)
		if type(mapping.callback) == "function" then
			mapping.callback()
		else
			vim.cmd.edit()
		end
	end)
end

return M
