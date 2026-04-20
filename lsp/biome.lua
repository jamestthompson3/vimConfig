local node = require("tt.nvim_utils").nodejs

return {
	cmd = { node.get_node_bin("biome"), "lsp-proxy" },
	root_markers = { "biome.json", "biome.jsonc" },
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
