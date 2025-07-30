local M = {}

M.supported_langs = {
	"comment",
	"fish",
	"bash",
	"c",
	"cpp",
	"objc",
	"lua",
	"go",
	"css",
	"html",
	"javascript",
	"json",
	"java",
	"scala",
	"python",
	"graphql",
	"rust",
	"svelte",
	"typescript",
	"tsx",
}
local lines = vim.fn.line("$")

function M.init()
	local ts_config = require("nvim-treesitter.configs")
	if lines > 30000 then -- skip some settings for large files
		require("nvim-treesitter.configs").setup({ highlight = { enable = false } })
		return
	end
	require("treesitter-context").setup({
		enable = true,
		max_lines = -1,
		mulitwindow = true,
		trim_scope = "outer",
	})

	ts_config.setup({
		ensure_installed = M.supported_langs,
		matchup = {
			enable = true,
		},
		auto_install = true,
		disable = { "prisma" }, -- langs where the plugin is better
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
		},
		highlight = {
			enable = true,
		},
	})
end

return M
