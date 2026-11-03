local M = {}
local namespace = vim.api.nvim_create_namespace("tt_acp_highlights")
local groups = {
	AcpUser = "DiagnosticInfo",
	AcpAssistant = "Title",
	AcpInput = "DiagnosticWarn",
	AcpPending = "Comment",
	AcpRunning = "DiagnosticInfo",
	AcpSuccess = "DiagnosticOk",
	AcpFailure = "DiagnosticError",
	AcpMuted = "Comment",
	AcpAttachment = "DiagnosticInfo",
	AcpHeading = "Title",
	AcpNotice = "DiagnosticWarn",
	AcpSeparator = "NonText",
}

function M.setup()
	for name, link in pairs(groups) do
		vim.api.nvim_set_hl(0, name, { link = link, default = true })
	end
end

function M.apply(buf, spans)
	vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
	for _, span in ipairs(spans) do
		vim.api.nvim_buf_set_extmark(buf, namespace, span.row - 1, span.first, {
			end_col = span.last,
			hl_group = span.group,
			hl_mode = "combine",
			priority = 110,
			right_gravity = true,
			end_right_gravity = false,
		})
	end
end

M.setup()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("tt_acp_highlights", { clear = true }),
	callback = M.setup,
})

return M
