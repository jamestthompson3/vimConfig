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
	cmd = node.lsp_cmd("typescript-language-server", { "--stdio" }),
	init_options = { hostInfo = "neovim" },
	before_init = function(params, config)
		local lib = node.get_node_lib("typescript/lib", config.root_dir or config.cmd_cwd or vim.fn.getcwd())
		if lib ~= "" then
			params.initializationOptions.tsserver = { path = vim.fs.joinpath(lib, "tsserver.js") }
		end
	end,
	root_dir = node.root_dir(
		{ "tsconfig.json", "jsconfig.json", "package.json", ".git" },
		"typescript-language-server"
	),
	workspace_required = false,
}
