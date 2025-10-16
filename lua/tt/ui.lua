local M = {}
vim.cmd("hi link TreesitterContext Pmenu")
vim.cmd("hi link DiagnosticUnnecessary WildMenu")

function M.darkMode()
	vim.cmd("hi Comment guifg=#0c2919 guibg=#a8d4c3")
	vim.cmd("hi Pmenu guifg=#1a1a5a guibg=#d0d5e0")
	vim.cmd("hi PmenuSel guifg=#0c2919 guibg=#a8d4c3")
	vim.cmd("hi PmenuMatch gui=bold guifg=#8b0000 guibg=NONE")
	vim.cmd("hi PmenuMatchSel gui=bold guifg=#8b0000 guibg=NONE")
	vim.cmd("hi StatusLine guifg=#0c2919 guibg=#a8d4c3")
	vim.cmd("hi @markup.raw guibg=NONE")
end

function M.lightMode()
	vim.cmd("hi Comment guifg=#0a1a4a guibg=#c8d8f0")
	vim.cmd("hi Pmenu guifg=#1a1a1a guibg=#e8e8e8")
	vim.cmd("hi PmenuSel guifg=#0a1a4a guibg=#c8d8f0")
	vim.cmd("hi PmenuMatchSel guifg=#8b0000 guibg=NONE gui=bold")
	vim.cmd("hi LineNr guifg=#4f4f4f")
	vim.cmd("hi Cursor gui=none guifg=#3a3a00 guibg=#dab862")
	vim.cmd("hi DiagnosticHint guifg=#0c2919 guibg=#c8e8d8")
	vim.cmd("hi DiagnosticUnderlineHint guisp=#0c2919")
	vim.cmd("hi @comment.note guifg=#0a3a3a guibg=#c8e8e8")
end

return M
