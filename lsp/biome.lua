local node = require("tt.nvim_utils").nodejs
local biome_roots = require("tt.constants").biome_roots

return {
	cmd = { node.get_node_bin("biome"), "lsp-proxy" },
	root_markers = biome_roots,
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, biome_roots)
		if root then
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
