local node = require("tt.nvim_utils").nodejs

return {
	cmd = { node.get_node_bin("astro-ls"), "--stdio" },
	filetypes = { "astro" },
	init_options = {
		typescript = { tsdk = node.get_node_lib("typescript/lib") },
	},
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
}
