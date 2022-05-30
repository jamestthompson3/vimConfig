return require("packer").startup({
	function()
		-- use("nathom/filetype.nvim")
		use("lewis6991/impatient.nvim")
		use("justinmk/vim-dirvish")
		use("yamatsum/nvim-web-nonicons")
		use("romainl/vim-cool")
		use("tmsvg/pear-tree")
		use("tpope/vim-commentary")
		use("tpope/vim-surround")
		use("tpope/vim-repeat")
		use("ludovicchabant/vim-gutentags")

		use({"andymass/vim-matchup", opt = true})

		use({
			"hrsh7th/nvim-cmp",
			config = function()
				require("tt.plugin.compe").init()
			end,
			opt = true,
			requires = {
				{ "hrsh7th/cmp-nvim-lsp", opt = true },
				{ "hrsh7th/cmp-nvim-lsp-signature-help", opt = true },
				{ "hrsh7th/cmp-buffer", opt = true },
				{ "hrsh7th/cmp-path", opt = true },
				{ "saadparwaiz1/cmp_luasnip", opt = true },
				{ "tzachar/cmp-tabnine", run = "./install.sh", opt = true },
				{ "ray-x/cmp-treesitter", opt = true },
				{ "quangnguyen30192/cmp-nvim-tags", opt = true },
			},
		})

		use({
			"L3MON4D3/LuaSnip",
			config = function()
				require("tt.plugin.luasnip")
			end,
			opt = true,
			after = "nvim-cmp",
		})
		use({
			"neovim/nvim-lspconfig",
			ft = {
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
			},
			config = function()
				require("tt.lsp").configureLSP()
			end,
		})

		use({ "rktjmp/lush.nvim", ft = { "lua" } })
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "wbthomason/packer.nvim", opt = true })
		use({
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("tt.plugin.treesitter").init()
			end,
			ft = require("tt.plugin.treesitter").supported_langs,
		})

		use({
			"majutsushi/tagbar",
			opt = true,
			cmd = "Tagbar",
			ft = { "c", "cpp", "typescript", "typescriptreact", "javascript", "javascriptreact", "rust" },
		})
		use({ "norcalli/nvim-colorizer.lua", opt = true, ft = { "html", "css", "vim" } })
		use({ "reedes/vim-wordy", opt = true, ft = { "txt", "md", "markdown", "text" } })
	end,
})
