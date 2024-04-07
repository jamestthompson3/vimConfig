local lsp_supported_files = {
	"typescript",
	"typescriptreact",
	"javascript",
	"javascriptreact",
	"rust",
	"html",
	"css",
	"json",
	"go",
	"cpp",
	"c",
	"objc",
	"obcpp",
	"tsx",
	"prisma",
	-- "bash",
	"yaml",
	"markdown",
	"lua",
}
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"lewis6991/impatient.nvim",
	"justinmk/vim-dirvish",
	"romainl/vim-cool",
	"windwp/nvim-autopairs",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	{ "rafamadriz/friendly-snippets", lazy = true },
	{ "ludovicchabant/vim-gutentags", lazy = true, event = "VimEnter" },
  -- TODO: See if I can get this working with LSP...
	{ "echasnovski/mini.completion", version = "*", config = function() require("tt.plugin.compe").init() end },
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	config = function()
	-- 		require("tt.plugin.compe").init()
	-- 	end,
	-- 	dependencies = {
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-nvim-lsp-signature-help",
	-- 		"hrsh7th/cmp-buffer",
	-- 		"hrsh7th/cmp-path",
	-- 		{ "saadparwaiz1/cmp_luasnip", build = "make install_jsregexp" },
	-- 		-- { "tzachar/cmp-tabnine", build = "./install.sh" },
	-- 		"ray-x/cmp-treesitter",
	-- 		"quangnguyen30192/cmp-nvim-tags",
	-- 	},
	-- },
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		lazy = true,
		config = function()
			require("git-conflict").setup()
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		config = function()
			require("tt.plugin.luasnip")
			-- require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("tt.plugin.find").init()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		ft = lsp_supported_files,
		config = require("tt.lsp").configureLSP,
	},
	{ "prisma/vim-prisma", lazy = true, ft = { "prisma" } },
	{ "rktjmp/lush.nvim", lazy = true, ft = { "lua" } },
	{ "rktjmp/shipwright.nvim", ft = { "lua" } },
	{ "rust-lang/rust.vim", ft = { "rust" } },
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		ft = { "c", "cpp" },
		config = function()
			require("tt.plugin.dap").init()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("tt.plugin.treesitter").init()
		end,
		ft = require("tt.plugin.treesitter").supported_langs,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-context" },
		},
	},

	{
		"simrat39/symbols-outline.nvim",
		lazy = true,
		ft = lsp_supported_files,
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{ "norcalli/nvim-colorizer.lua", ft = { "html", "css", "vim" } },
	{ "reedes/vim-wordy", lazy = true, ft = { "txt", "md", "markdown", "text" } },
}, {
	-- defaults = { lazy = true },
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
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
			},
		},
	},
})
