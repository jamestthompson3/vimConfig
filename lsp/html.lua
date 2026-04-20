local node = require("tt.nvim_utils").nodejs

return {
	filetypes = { "html", "templ" },
	init_options = { documentFormatting = false },
	cmd = { node.get_node_bin("html-languageserver"), "--stdio" },
}
