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
	-- "bash",
	"yaml",
	"markdown",
	"lua",
}
return require("packer").startup({
	function()
		-- use("nathom/filetype.nvim")
		-- use('ja-ford/delaytrain.nvim')
		use("lewis6991/impatient.nvim")
		use("justinmk/vim-dirvish")
		use("romainl/vim-cool")
		use("windwp/nvim-autopairs")
		use("tpope/vim-commentary")
		use("tpope/vim-surround")
		use("tpope/vim-repeat")
		use("ludovicchabant/vim-gutentags")
		-- use("ggandor/leap.nvim")

		use("andymass/vim-matchup")
		use({
			"hrsh7th/nvim-cmp",
			config = function()
				require("tt.plugin.compe").init()
			end,
			requires = {
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-nvim-lsp-signature-help" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-path" },
				{ "saadparwaiz1/cmp_luasnip" },
				{ "tzachar/cmp-tabnine", run = "./install.sh" },
				{ "ray-x/cmp-treesitter" },
				{ "quangnguyen30192/cmp-nvim-tags" },
			},
		})
		use({
			"akinsho/git-conflict.nvim",
			tag = "*",
			config = function()
				require("git-conflict").setup()
			end,
		})

		use({
			"L3MON4D3/LuaSnip",
			config = function()
				require("tt.plugin.luasnip")
			end,
		})
		use({
			"neovim/nvim-lspconfig",
			ft = lsp_supported_files,
			config = function()
				require("tt.lsp").configureLSP()
			end,
		})

		use({ "rktjmp/lush.nvim", ft = { "lua" } })
		use({ "rktjmp/shipwright.nvim", ft = { "lua" } })
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "wbthomason/packer.nvim", opt = true })
		use({
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("tt.plugin.treesitter").init()
			end,
			ft = require("tt.plugin.treesitter").supported_langs,
			requires = {
				{ "nvim-treesitter/nvim-treesitter-context" },
			},
		})

		use({
			"simrat39/symbols-outline.nvim",
			opt = true,
			ft = lsp_supported_files,
			config = function()
				require("symbols-outline").setup()
			end,
		})
		use({ "norcalli/nvim-colorizer.lua", opt = true, ft = { "html", "css", "vim" } })
		use({ "reedes/vim-wordy", opt = true, ft = { "txt", "md", "markdown", "text" } })
	end,
})
