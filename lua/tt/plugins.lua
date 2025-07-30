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
	-- {
	--   "supermaven-inc/supermaven-nvim",
	--   config = function()
	--     require("supermaven-nvim").setup({
	--       color = {
	--         suggestion_color = "#BADA55",
	--         cterm = 244
	--       }
	--     })
	--   end,
	-- },
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

-- load immediately
require("tt.plugin.find").init()
require("tt.plugin.treesitter").init()
require("oil").setup()
require("mini.surround").setup()
require("nvim-autopairs").setup()
require("nvim-ts-autotag").setup({
	aliases = {
		["astro"] = "html",
	},
})
require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust" },
})
