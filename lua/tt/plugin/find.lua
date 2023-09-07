local M = {}

function M.init()
	require("fzf-lua").setup({
		"max-perf",
		winopts = { preview = { hidden = "hidden" } },
		fzf_opts = { ["--layout"] = "reverse" },
	})
	vim.keymap.set("n", ",", require("fzf-lua").files)
	vim.keymap.set("n", "<leader>.", require("fzf-lua").buffers)
end
return M
