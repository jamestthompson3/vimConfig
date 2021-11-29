local formatting = require("tt.formatting")
require("tt.nvim_utils")

local M = {}

local eslintd = {
	lintCommand = find_node_executable("eslint_d") .. " -f unix --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
}

local prettier = {
	formatCommand = find_node_executable("prettier") .. ' "${INPUT}"',
	fmtStdin = true,
}

function M.setup(opts)
	require("lspconfig").efm.setup({
		on_attach = function(client, bufnr)
			formatting.fmt_on_attach(client, bufnr)
		end,
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
			rootMarkers = { "package.json", ".git/" },
			languages = {
				javascript = { prettier, eslintd },
				typescript = { prettier, eslintd },
				javascriptreact = { prettier, eslintd },
				typescriptreact = { prettier, eslintd },
				json = {
					{
						formatCommand = "prettier --parser json",
						lintCommand = "jq .",
						lintStdin = true,
					},
				},
				html = { prettier },
				css = { prettier },
				markdown = { prettier },
				yaml = { prettier },
			},
		},
	})
end

return M