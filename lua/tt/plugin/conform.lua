local node = require("tt.nvim_utils").nodejs

require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		go = { "gofmt" },
		css = { "prettier_css" },
		scss = { "prettier_css" },
		astro = { "prettier_astro" },
		typescriptreact = { "prettier" },
		html = { "prettier_html" },
		lua = { "stylua" },
	},
	formatters = {
		prettier = {
			command = node.find_node_executable("prettier"),
		},
		prettier_html = {
			command = string.format("%s --parser html", node.find_node_executable("prettier")),
		},
		prettier_css = {
			command = node.find_node_executable("prettier"),
			args = { "--write", "$FILENAME", "--parser", "css" },
		},
	},
	format_on_save = function()
		if vim.b.autoformat then
			return { timeout_ms = 500, lsp_format = "fallback" }
		end
	end,
})
