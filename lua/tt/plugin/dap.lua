local dap = require("dap")
local M = {}
function M.init()
	vim.keymap.set("n", "<C-B>", require("dap").toggle_breakpoint)
	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = { "-i", "dap" },
	}
	dap.configurations.c = {
		{
			name = "Launch",
			type = "gdb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
		},
	}
end
return M
