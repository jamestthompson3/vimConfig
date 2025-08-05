local M = {}
function M.init()
	local fzf = require("fzf-lua")
	fzf.setup({
		"max-perf",
		winopts = { preview = { hidden = true } },
	})
	vim.keymap.set("n", ",", function()
		fzf.files({
			fzf_opts = { ["--scheme"] = "path", ["--tiebreak"] = "index" },
		})
	end)
	vim.keymap.set("n", "ts", "FzfLua lsp_workspace_symbols")
	vim.keymap.set("n", "<leader>.", require("fzf-lua").buffers)
end

return M
