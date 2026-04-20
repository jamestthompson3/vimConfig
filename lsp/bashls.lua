local node = require("tt.nvim_utils").nodejs

return {
	filetypes = { "bash", "sh" },
	cmd = { node.get_node_bin("bash-language-server"), "start" },
}
