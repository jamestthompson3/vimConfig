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
	"markdown",
	"markdown_inline",
}

function M.init()
	local lines = vim.fn.line("$")
	if lines > 30000 then
		return
	end

	require("nvim-treesitter").install(M.supported_langs)

	require("treesitter-context").setup({
		enable = true,
		max_lines = -1,
		multiwindow = true,
		trim_scope = "outer",
	})
end

return M
