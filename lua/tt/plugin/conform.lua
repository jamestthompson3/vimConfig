local node = require("tt.nvim_utils").nodejs

require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		astro = { "prettier" },
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
	},
	format_on_save = function()
		if vim.b.autoformat then
			return { timeout_ms = 500, lsp_format = "fallback" }
		end
	end,
})
