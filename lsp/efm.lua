local node = require("tt.nvim_utils").nodejs

local eslintd = {
	lintCommand = node.find_node_executable("eslint_d") .. " -f unix --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
}
local clang_tidy = {
	lintCommand = "/opt/homebrew/opt/llvm/bin/clang-tidy --quiet ${INPUT}",
	lintStdin = false,
	lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
	rootMarkers = { ".clang-tidy", "compile_commands.json", ".git" },
}
local stylint = {
	lintCommand = node.find_node_executable("stylelint")
		.. " --no-color --formatter compact --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = { "%.%#: line %l, col %c, %trror - %m", "%.%#: line %l, col %c, %tarning - %m" },
	rootMarkers = { ".stylelintrc", "package.json" },
}

return {
	cmd = { "efm-langserver" },
	filetypes = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"scss",
		"css",
		"json",
		"c",
		"cpp",
	},
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
			c = { clang_tidy },
			cpp = { clang_tidy },
		},
	},
}
