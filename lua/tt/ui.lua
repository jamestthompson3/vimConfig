local M = {}
vim.cmd("hi link TreesitterContext Pmenu")
vim.cmd("hi link DiagnosticUnnecessary WildMenu")

function M.darkMode()
	-- Comments: light sage background with dark green foreground (high contrast)
	vim.cmd("hi Comment guifg=#0c2919 guibg=#a8d4c3")
	
	-- Popup menu: light background with dark blue foreground
	vim.cmd("hi Pmenu guifg=#1a1a5a guibg=#d0d5e0")
	vim.cmd("hi PmenuSel guifg=#0c2919 guibg=#a8d4c3")  -- Match comment style for selection
	vim.cmd("hi PmenuMatch gui=bold guifg=#8b0000 guibg=NONE")  -- Dark red for matches
	vim.cmd("hi PmenuMatchSel gui=bold guifg=#8b0000 guibg=NONE")  -- Dark red for selected matches
	
	-- Status line: dark green on light sage (matching comment style)
	vim.cmd("hi StatusLine guifg=#0c2919 guibg=#a8d4c3")
	
	-- Markup: keep colorless
	vim.cmd("hi @markup.raw guibg=NONE")
end

function M.lightMode()
	-- Comments: light blue background with dark blue foreground
	vim.cmd("hi Comment guifg=#0a1a4a guibg=#c8d8f0")
	
	-- Popup menu: light background with dark foreground
	vim.cmd("hi Pmenu guifg=#1a1a1a guibg=#e8e8e8")
	vim.cmd("hi PmenuSel guifg=#0a1a4a guibg=#c8d8f0")  -- Light blue background with dark blue
	vim.cmd("hi PmenuMatchSel guifg=#8b0000 guibg=NONE gui=bold")  -- Dark red for matches
	
	-- Line numbers: dark gray (colorless)
	vim.cmd("hi LineNr guifg=#4f4f4f")
	
	-- Cursor: light yellow background with dark foreground
	vim.cmd("hi Cursor gui=none guifg=#3a3a00 guibg=#f0f0c8")
	
	-- Diagnostics: light green background with dark green foreground
	vim.cmd("hi DiagnosticHint guifg=#0c2919 guibg=#c8e8d8")
	vim.cmd("hi DiagnosticUnderlineHint guisp=#0c2919")
	
	-- Comment notes: light cyan background with dark cyan foreground
	vim.cmd("hi @comment.note guifg=#0a3a3a guibg=#c8e8e8")
end

return M
