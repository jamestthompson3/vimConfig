local node = require("tt.nvim_utils").nodejs
local efm_initialized = false
local M = {}
function M.init()
	if not efm_initialized then
		local eslintd = {
			lintCommand = node.find_node_executable("eslint_d") .. " -f unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		}
		local stylint = {
			lintCommand = node.find_node_executable("stylelint") .. " --no-color --formatter compact --stdin",
			lintStdin = true,
			lintFormats = { "%.%#: line %l, col %c, %trror - %m", "%.%#: line %l, col %c, %tarning - %m" },
			rootMarkers = { ".stylelintrc" },
		}
		vim.lsp.config.efm = {
			cmd = { "efm-langserver" },
			settings = {
				rootMarkers = { "package.json", ".git" },
				languages = {
					javascript = { eslintd },
					typescript = { eslintd },
					scss = { stylint },
					css = { stylint },
					javascriptreact = { eslintd },
					typescriptreact = { eslintd },
					json = {
						{
							lintCommand = "jq .",
							lintStdin = true,
						},
					},
				},
			},
		}
		efm_initialized = true
	end
end

return M
