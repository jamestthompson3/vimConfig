local formatting = require("tt.formatting")
local node = require("tt.nvim_utils").nodejs

local M = {}

local eslintd = {
	lintCommand = node.find_node_executable("eslint_d") .. " -f unix --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
}

local prettier = {
	formatCommand = node.find_node_executable("prettier") .. ' "${INPUT}"',
	fmtStdin = true,
}

local gofmt = {
  formatCommand = "gofmt",
  formatStdin = true,
}

function M.setup(opts)
	require("lspconfig").efm.setup({
		on_attach = function(client, bufnr)
			formatting.fmt_on_attach(client, bufnr)
		end,
		init_options = { documentFormatting = true },
		filetypes = {
			"css",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"markdown",
			"typescript",
			"typescriptreact",
			"yaml",
      "go",
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
        go = { gofmt },
			},
		},
	})
end

return M
