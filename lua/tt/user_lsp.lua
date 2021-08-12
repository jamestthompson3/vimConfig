local icons = require("nvim-nonicons")
require("tt.nvim_utils")
local fmt = string.format

local M = {}

local kind_symbols = {
	Text = "",
	Method = "ƒ",
	Function = icons.get("pulse"),
	Constructor = "",
	Variable = icons.get("variable"),
	Class = icons.get("class"),
	Interface = "ﰮ",
	Module = icons.get("package"),
	Property = "",
	Unit = "",
	Value = icons.get("ellipsis"),
	Enum = icons.get("workflow"),
	Keyword = "",
	Snippet = "﬌",
	Color = "",
	File = icons.get("file"),
	Folder = icons.get("file-directory-outline"),
	EnumMember = "",
	Constant = icons.get("constant"),
	Struct = icons.get("struct"),
}

local kind_order = {
	"Text",
	"Method",
	"Function",
	"Constructor",
	"Field",
	"Variable",
	"Class",
	"Interface",
	"Module",
	"Property",
	"Unit",
	"Value",
	"Enum",
	"Keyword",
	"Snippet",
	"Color",
	"File",
	"Reference",
	"Folder",
	"EnumMember",
	"Constant",
	"Struct",
	"Event",
	"Operator",
	"TypeParameter",
}
local symbols = {}
local len = 25
local with_text
if with_text == true or with_text == nil then
	for i = 1, len do
		local name = kind_order[i]
		local symbol = kind_symbols[name]
		symbol = symbol and (symbol .. " ") or ""
		symbols[i] = fmt("%s%s", symbol, name)
	end
else
	for i = 1, len do
		local name = kind_order[i]
		symbols[i] = kind_symbols[name]
	end
end

require("vim.lsp.protocol").CompletionItemKind = symbols

-- require('vim.lsp.protocol').CompletionItemKind = kind_symbols

local sign_defined = false
if not sign_defined then
	vim.fn.sign_define(
		"LspDiagnosticsSignError",
		{ text = "", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"LspDiagnosticsSignWarning",
		{ text = "", texthl = "LspDiagnosticsSignWarning", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"LspDiagnosticsSignInfo",
		{ text = "", texthl = "LspDiagnosticsSignInfo", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"LspDiagnosticsSignHint",
		{ text = "", texthl = "LspDiagnosticsSignHint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"LspDiagnosticsSignOther",
		{ text = "﫠", texthl = "LspDiagnosticsSignOther", linehl = "", numhl = "" }
	)
	sign_defined = true
end

function M.setMappings()
	local mappings = {
		["nge"] = map_cmd([[lua vim.lsp.diagnostic.show_line_diagnostics()]]),
		["ngd"] = map_cmd([[lua vim.lsp.buf.definition()]]),
		["ngh"] = map_cmd([[lua vim.lsp.buf.hover()]]),
		["n[e"] = map_cmd([[lua vim.lsp.diagnostic.goto_next()]]),
		["n]e"] = map_cmd([[lua vim.lsp.diagnostic.goto_prev()]]),
		["nga"] = map_cmd([[lua vim.lsp.buf.code_action()]]),
		["ngs"] = map_cmd([[vsplit|lua vim.lsp.buf.definition()]]),
		["n<leader>r"] = map_cmd([[lua vim.lsp.buf.references()]]),
		["n<leader>f"] = map_cmd([[lua vim.lsp.buf.formatting()]]),
		["n<leader>n"] = map_cmd([[lua vim.lsp.buf.rename()]]),
	}
	nvim_apply_mappings(mappings, { silent = true })
end


local eslintd = {
	lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
	formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
	formatStdin = true,
}

local prettier = {
	formatCommand = ([[
  ./node_modules/.bin/prettier
  ${--config-precedence:configPrecedence}
  ${--tab-width:tabWidth}
  ${--single-quote:singleQuote}
  ${--trailing-comma:trailingComma}
  ]]):gsub("\n", ""),
}

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

function M.configureLSP()
	local nvim_lsp = require("lspconfig")
	local util = nvim_lsp.util
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	require("lspconfig").efm.setup({
		init_options = { documentFormatting = true },
		filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
		root_dir = function(fname)
			return util.root_pattern("tsconfig.json")(fname)
				or util.root_pattern(".eslintrc.js", ".git", ".eslintrc")(fname)
		end,
		settings = {
			rootMarkers = { ".eslintrc.js", ".git/", ".eslintrc" },
			languages = {
				javascript = { eslintd },
				typescript = { eslintd },
			},
		},
	})

	nvim_lsp.cssls.setup({
		cmd = { get_node_bin("vscode-css-languageserver"), "--stdio" },
	})
	nvim_lsp.html.setup({
		capabilities = capabilities,
		cmd = { get_node_bin("vscode-html-languageserver-bin"), "--stdio" },
	})
	nvim_lsp.tsserver.setup({
		capabilities = capabilities,
		cmd = { get_node_bin("typescript-language-server"), "--stdio" },
		commands = {
			OrganizeImports = {
				organize_imports,
				description = "Organize Imports",
			},
		},
	})
	nvim_lsp.rust_analyzer.setup({
		capabilities = capabilities,
		init_options = {
			documentFormatting = true,
		},
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					enabled = true,
					command = "clippy",
				},
			},
		},
	})
	nvim_lsp.gopls.setup({})
	-- nvim_lsp.efm.setup {
	--   init_options = {documentFormatting = false},
	--   filetypes = {
	--     "javascript",
	--     "javascriptreact",
	--     "javascript.jsx",
	--     "typescript",
	--     "typescript.tsx",
	--     "typescriptreact"
	--   },
	-- }
	local system_name
	if vim.fn.has("mac") == 1 then
		system_name = "macOS"
	elseif vim.fn.has("unix") == 1 then
		system_name = "Linux"
	elseif vim.fn.has("win32") == 1 then
		system_name = "Windows"
	else
		print("Unsupported system for sumneko")
	end

	local sumneko_root_path = os.getenv("HOME") .. "/programs/lua-language-server"
	local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	nvim_lsp.sumneko_lua.setup({
		cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	})

	nvim_lsp.bashls.setup({
		cmd = { get_node_bin("bash-language-server"), "start" },
	})

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = true,
		virtual_text = false,
		signs = true,
	})
end

return M
