local M = {}
local jfind = require("jfind")
local key = require("jfind.key")

function M.init()
	jfind.setup({
		exclude = {
			".git",
			".idea",
			".vscode",
			".sass-cache",
			".class",
			"__pycache__",
			"node_modules",
			"target",
			"build",
			"tmp",
			"assets",
			"dist",
			"public",
			"*.iml",
			"*.meta",
		},
		border = "shadow",
	})
	local function get_buffers()
		local buffers = {}
		for i, buf_hndl in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf_hndl) then
				local path = vim.api.nvim_buf_get_name(buf_hndl)
				if path ~= nil and path ~= "" then
					table.insert(buffers,jfind.formatPath(path))
					table.insert(buffers, path)
				end
			end
		end
		return buffers
	end

	-- Keymaps
	vim.keymap.set("n", ",", function()
		jfind.findFile({
			formatPaths = true,
			callback = {
				[key.DEFAULT] = vim.cmd.edit,
				[key.CTRL_S] = vim.cmd.split,
				[key.CTRL_V] = vim.cmd.vsplit,
			},
		})
	end)

	vim.keymap.set("n", "<leader>.", function()
		jfind.jfind({
			input = get_buffers(),
			hints = true,
			callbackWrapper = function(callback, _, path)
				callback(path)
			end,
			callback = {
				[key.DEFAULT] = vim.cmd.edit,
				[key.CTRL_S] = vim.cmd.split,
				[key.CTRL_V] = vim.cmd.vsplit,
			},
		})
  end)
end

return M
