local formatting = require("tt.formatting")

local M = {}

local eslintd = {
	lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
}

local prettier = {
	formatCommand = get_node_bin("prettier") .. ' "${INPUT}"',
	fmtStdin = true,
}

function M.setup()
	require("lspconfig").efm.setup({
		on_attach = formatting.fmt_on_attach,
		init_options = { documentFormatting = true },
		filetypes = {
			"javascript",
			"typescript",
			"typescriptreact",
			"javascriptreact",
			"css",
			"json",
			"html",
			"yaml",
			"markdown",
		},
		settings = {
			rootMarkers = { "package.json" },
			languages = {
				javascript = { prettier, eslintd },
				typescript = { prettier, eslintd },
				javascriptreact = { prettier, eslintd },
				typescriptreact = { prettier, eslintd },
				json = { prettier },
				html = { prettier },
				css = { prettier },
				markdown = { prettier },
				yaml = { prettier },
			},
		},
	})
end

return M
