local node = require("tt.nvim_utils").nodejs
local biome_roots = require("tt.constants").biome_roots

return {
	cmd = node.lsp_cmd("biome", { "lsp-proxy" }),
	-- Neovim can attach without a root when only root_markers is set.
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, biome_roots)
		if root and node.find_node_executable("biome", root) ~= "" then
			on_dir(root)
		end
	end,
	filetypes = {
		"astro",
		"css",
		"graphql",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"svelte",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"vue",
	},
}
