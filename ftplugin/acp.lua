vim.bo.autoindent = false
vim.bo.smartindent = false
vim.bo.formatoptions = ""
vim.bo.textwidth = 0
vim.bo.syntax = ""
require("tt.plugin.acp_view").setup_window(0)
vim.b.undo_ftplugin =
	"setlocal autoindent< smartindent< formatoptions< textwidth< syntax< wrap< linebreak< breakindent< number< relativenumber< signcolumn< foldcolumn< foldmethod< foldenable< conceallevel< spell< list<"
