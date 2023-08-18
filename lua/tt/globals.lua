local globals = require("tt.nvim_utils").GLOBALS
--
-- Do not source the default filetype.vim
-- vim.g.did_load_filetypes = 1
--
vim.g.did_install_default_menus = 1
vim.g.remove_whitespace = 1
vim.g.python3_host_prog = globals.python_host
vim.g.autoformat = true
vim.g.netrw_localrmdir = "rm -rf"
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 45
vim.g.netrw_liststyle = 3
vim.g.markdown_fenced_languages = {
	"html",
	"typescript",
	"javascript",
	"js=javascript",
	"ts=typscript",
	"rust",
	"css",
	"vim",
	"lua",
}

vim.g.dirvish_relative_paths = 1

vim.g.gutentags_file_list_command = "fd --type f --hidden -E .git"
vim.g.gutentags_cache_dir = "~/.cache/"
vim.g.gutentags_project_root = { ".git", "root_marker" }
vim.g.gutentags_add_default_project_roots = 1
vim.g.gutentags_generate_on_empty_buffer = 1
