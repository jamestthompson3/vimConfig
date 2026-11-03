local node = require("tt.nvim_utils").nodejs

return {
	filetypes = { "html", "templ" },
	root_dir = node.root_dir({ "package.json", ".git", "root_marker" }, "html-languageserver"),
	init_options = { documentFormatting = false },
	cmd = node.lsp_cmd("html-languageserver", { "--stdio" }),
}
