local M = {}
local fmt = string.format

function M.diagnosticSigns()
	vim.fn.sign_define("DiagnosticSignError", {
		text = "",
		texthl = "LspDiagnosticsSignError",
		linehl = "",
		numhl = "LspDiagnosticsUnderlineError",
	})
	vim.fn.sign_define("DiagnosticSignWarning", {
		text = "",
		texthl = "LspDiagnosticsSignWarning",
		linehl = "",
		numhl = "",
	})
	vim.fn.sign_define("DiagnosticSignInfo", {
		text = "",
		texthl = "LspDiagnosticsSignInfo",
		linehl = "",
		numhl = "",
	})
	vim.fn.sign_define("DiagnosticSignHint", {
		text = "",
		texthl = "LspDiagnosticsSignHint",
		linehl = "",
		numhl = "",
	})
	vim.fn.sign_define("DiagnosticSignOther", {
		text = "﫠",
		texthl = "LspDiagnosticsSignOther",
		linehl = "",
		numhl = "",
	})
end

return M
