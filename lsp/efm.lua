local node = require("tt.nvim_utils").nodejs

local brew_clang_tidy = "/opt/homebrew/opt/llvm/bin/clang-tidy"

-- Resolve node binaries for the buffer that starts the client, not for the
-- buffer that was current when this file loaded.
local function languages()
	local result = {}
	local function add(fts, tool)
		for _, ft in ipairs(fts) do
			result[ft] = result[ft] or {}
			table.insert(result[ft], tool)
		end
	end

	local eslint_d = node.find_node_executable("eslint_d")
	if eslint_d ~= "" then
		add({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, {
			lintCommand = eslint_d .. " -f unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
			-- Only lint when the project has an eslint config (replaces the old
			-- per-ftplugin `vim.fs.root(eslint_roots)` gate before vim.lsp.start).
			rootMarkers = require("tt.constants").eslint_roots,
		})
	end

	local stylelint = node.find_node_executable("stylelint")
	if stylelint ~= "" then
		add({ "scss", "css" }, {
			lintCommand = stylelint .. " --no-color --formatter compact --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%.%#: line %l, col %c, %trror - %m", "%.%#: line %l, col %c, %tarning - %m" },
			rootMarkers = { ".stylelintrc", "package.json" },
		})
	end

	local clang_tidy = vim.fn.executable(brew_clang_tidy) == 1 and brew_clang_tidy or vim.fn.exepath("clang-tidy")
	if clang_tidy ~= "" then
		add({ "c", "cpp" }, {
			lintCommand = clang_tidy .. " --quiet ${INPUT}",
			lintStdin = false,
			lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
			rootMarkers = { ".clang-tidy", "compile_commands.json", ".git" },
		})
	end

	add({ "json" }, { lintCommand = "jq .", lintStdin = true })
	return result
end

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
		languages = {},
	},
	before_init = function(_, config)
		config.settings.languages = languages()
	end,
}
