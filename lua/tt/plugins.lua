local function gh(pkg)
	return "https://github.com/" .. pkg
end

vim.pack.add({
	gh("nvim-mini/mini.surround"),
	gh("stevearc/oil.nvim"),
	gh("ludovicchabant/vim-gutentags"),
	gh("windwp/nvim-ts-autotag"),
	gh("windwp/nvim-autopairs"),
	gh("ibhagwan/fzf-lua"),
	gh("dmmulroy/ts-error-translator.nvim"),
	gh("nvim-treesitter/nvim-treesitter"),
	gh("nvim-treesitter/nvim-treesitter-context"),
	gh("norcalli/nvim-colorizer.lua"),
	gh("reedes/vim-wordy"),
})

local disabled_plugins = {
	"gzip",
	"netrwPlugin",
	"rplugin",
	"tarPlugin",
	"tohtml",
	"tutor",
	"zipPlugin",
	"getscript",
	"vimball",
	"logiPat",
	"rrhelper",
	"python_provider",
}

for _, p in ipairs(disabled_plugins) do
	vim.g["loaded_" .. p] = 1
end

local lazy_load = vim.api.nvim_create_augroup("Plugins", { clear = true })
require("tt.plugin.find").init()

vim.api.nvim_create_autocmd("InsertEnter", {
	group = lazy_load,
	pattern = "*",
	callback = function()
		require("nvim-autopairs").setup()
		vim.api.nvim_clear_autocmds({ group = "Plugins", event = "InsertEnter" })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = lazy_load,
	pattern = "*",
	callback = function()
		require("tt.plugin.treesitter").init()
		require("mini.surround").setup()
		vim.cmd("packadd vim-gutentags")
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
		})
		require("nvim-ts-autotag").setup({
			aliases = {
				["astro"] = "html",
			},
		})
		vim.api.nvim_clear_autocmds({ group = "Plugins", event = "BufReadPost" })
	end,
})

vim.api.nvim_create_user_command("Update", function()
	vim.pack.update()
end, {})
