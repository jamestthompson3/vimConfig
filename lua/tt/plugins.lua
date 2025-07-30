local function gh(pkg)
	return "https://github.com/" .. pkg
end

vim.pack.add({
	gh("echasnovski/mini.surround"),
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
	gh("stevearc/oil.nvim"),
	-- gh("ludovicchabant/vim-gutentags"),
	-- , lazy = true, event = "VimEnter"
	gh("windwp/nvim-ts-autotag"),
	gh("windwp/nvim-autopairs"),
	gh("ibhagwan/fzf-lua"),
	-- gh("stevearc/profile.nvim"),
	gh("prisma/vim-prisma"),
	gh("nvim-treesitter/nvim-treesitter"),
	gh("nvim-treesitter/nvim-treesitter-context"),
	gh("norcalli/nvim-colorizer.lua"),
	gh("reedes/vim-wordy"),
})

local disabled_plugins = {
	"gzip",
	"matchparen",
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

table.foreach(disabled_plugins, function(_, p)
	local loaded = "loaded_" .. p
	vim.g[loaded] = 1
end)

local lazy_load = vim.api.nvim_create_augroup("Plugins", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
	group = lazy_load,
	pattern = "*",
	callback = function()
		require("nvim-autopairs").setup()
		require("blink.cmp").setup({
			fuzzy = { implementation = "prefer_rust" },
		})
		vim.api.nvim_clear_autocmds({ group = "Plugins", event = "InsertEnter" })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = lazy_load,
	pattern = "*",
	callback = function()
		require("tt.plugin.find").init()
		require("tt.plugin.treesitter").init()
		require("mini.surround").setup()
		require("nvim-ts-autotag").setup({
			aliases = {
				["astro"] = "html",
			},
		})
		vim.api.nvim_clear_autocmds({ group = "Plugins", event = "BufReadPost" })
	end,
})
