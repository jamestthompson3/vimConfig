local M = {}
local fmt = string.format
local icons = require("nvim-nonicons")

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

function M.autocompleteSymbols()
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
end

local sign_defined = false
function M.diagnosticSigns()
	if not sign_defined then
		vim.fn.sign_define("LspDiagnosticsSignError", {
			text = "",
			texthl = "LspDiagnosticsSignError",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("LspDiagnosticsSignWarning", {
			text = "",
			texthl = "LspDiagnosticsSignWarning",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("LspDiagnosticsSignInfo", {
			text = "",
			texthl = "LspDiagnosticsSignInfo",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("LspDiagnosticsSignHint", {
			text = "",
			texthl = "LspDiagnosticsSignHint",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("LspDiagnosticsSignOther", {
			text = "﫠",
			texthl = "LspDiagnosticsSignOther",
			linehl = "",
			numhl = "",
		})
		sign_defined = true
	end
end

return M
