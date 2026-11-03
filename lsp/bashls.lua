local node = require("tt.nvim_utils").nodejs

return {
	filetypes = { "bash", "sh" },
	root_dir = node.root_dir({ ".git", "root_marker" }, "bash-language-server"),
	cmd = node.lsp_cmd("bash-language-server", { "start" }),
}
