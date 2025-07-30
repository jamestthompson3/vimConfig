local M = {}
vim.cmd("hi link TreesitterContext Pmenu")
vim.cmd("hi link DiagnosticUnnecessary WildMenu")

function M.darkMode()
	vim.cmd("hi Pmenu guifg=#ebdbb2 guibg=#504945")
	vim.cmd("hi Comment guifg=#ff5fff")
	vim.cmd("hi PmenuSel guifg=#504945 guibg=#83a598")
	vim.cmd("hi PmenuMatch gui=bold guifg=none guibg=none")
	vim.cmd("hi PmenuMatchSel gui=bold guifg=none guibg=none")
end

function M.lightMode()
	vim.cmd("hi Pmenu guifg=#000000 guibg=white")
	vim.cmd("hi! link PmenuSel Search")
	vim.cmd("hi! link PmenuMatchSel Visual")
	vim.cmd("hi Comment guifg=#0000ff")
	vim.cmd("hi LineNr guifg=#4f4f4f")
	vim.cmd("hi Cursor gui=none guifg=#e4e4e4 guibg=#2e8b57")
	vim.cmd("hi DiagnosticHint guifg=green")
	vim.cmd("hi DiagnosticUnderlineHint guisp=green")
	vim.cmd("hi @comment.note guifg=DarkCyan")
end

return M
