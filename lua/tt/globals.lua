local globals = require("tt.nvim_utils").GLOBALS
--
-- Do not source the default filetype.vim
-- vim.g.did_load_filetypes = 1
--
vim.g.did_install_default_menus = 1
vim.g.remove_whitespace = 1
vim.g.python3_host_prog = globals.python_host
vim.g.autoformat = true
vim.g.loaded_netrwPlugin = 1
vim.g.markdown_fenced_languages = {
	"html",
	"typescript",
  "markdown",
	"javascript",
	"js=javascript",
	"ts=typscript",
	"rust",
	"css",
	"vim",
	"lua",
}

vim.g.autoformat_ft = {
			"css",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"markdown",
			"typescript",
      "astro",
			"typescriptreact",
			"yaml",
			"rust",
			-- "lua",
			"go",
}

vim.g.dirvish_relative_paths = 1

vim.g.gutentags_file_list_command = "fd --type f --hidden -E .git"
vim.g.gutentags_cache_dir = "~/.cache/"
vim.g.gutentags_project_root = { ".git", "root_marker" }
vim.g.gutentags_add_default_project_roots = 1
vim.g.gutentags_generate_on_empty_buffer = 1
