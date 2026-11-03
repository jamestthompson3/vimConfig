local node = require("tt.nvim_utils").nodejs

return {
	cmd = node.lsp_cmd("astro-ls", { "--stdio" }),
	filetypes = { "astro" },
	init_options = {},
	before_init = function(params, config)
		local lib = node.get_node_lib("typescript/lib", config.root_dir or config.cmd_cwd or vim.fn.getcwd())
		if lib ~= "" then
			params.initializationOptions.typescript = { tsdk = lib }
		end
	end,
	root_dir = node.root_dir({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }, "astro-ls"),
}
