local formatting = require("tt.formatting")
local node = require("tt.nvim_utils").nodejs

local M = {}

function M.setup(opts)
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

	local rustfmt = {
		formatCommand = "rustfmt" .. ' "${INPUT}"' .. " --emit=stdout -q",
		formatStdin = true,
	}

	local stylua = {
		formatCommand = 'stylua --stdin-filepath "${INPUT}" -',
		formatStdin = true,
	}
	require("lspconfig").efm.setup({
		on_attach = function(client, bufnr)
			if vim.g.autoformat == true then
				formatting.fmt_on_attach(client, bufnr)
			end
		end,
		init_options = { documentFormatting = true },
		filetypes = vim.g.autoformat_ft,
		settings = {
			rootMarkers = { "package.json", ".git/", "Cargo.toml", "go.mod" },
			languages = {
				javascript = { prettier, eslintd },
				typescript = { prettier, eslintd },
				javascriptreact = { prettier, eslintd },
				typescriptreact = { prettier, eslintd },
				json = {
					{
						formatCommand = "prettierd --parser json",
						lintCommand = "jq .",
						lintStdin = true,
					},
				},
				html = { prettier },
				css = { prettier },
				markdown = { prettier },
				yaml = { prettier },
				go = { gofmt },
				fish = { fishIndent },
				-- rust = { rustfmt },
				lua = { stylua },
			},
		},
	})
end

return M
