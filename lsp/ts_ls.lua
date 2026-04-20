local node = require("tt.nvim_utils").nodejs

return {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	cmd = { node.find_node_executable("typescript-language-server"), "--stdio" },
	init_options = {
		hostInfo = "neovim",
		tsserver = { path = node.get_node_lib("typescript/lib") },
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	single_file_support = true,
}
