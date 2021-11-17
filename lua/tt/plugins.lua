M = {}

return require("packer").startup({
	function()
		-- use("nathom/filetype.nvim")
		use("lewis6991/impatient.nvim")
		use("justinmk/vim-dirvish")
		use("yamatsum/nvim-web-nonicons")
		use("romainl/vim-cool")
		use("tmsvg/pear-tree")
		-- use("tpope/vim-apathy")
		use("tpope/vim-commentary")
		use("rktjmp/lush.nvim")
		use("tpope/vim-surround")
		use("tpope/vim-repeat")
		use("andymass/vim-matchup")
		use("ludovicchabant/vim-gutentags")

		use({
			"hrsh7th/nvim-cmp",
			config = function()
				require("tt.plugin.compe")
			end,
			requires = {
				{ "hrsh7th/cmp-vsnip", module_pattern = "cmp*" },
				{ "hrsh7th/cmp-nvim-lsp", module_pattern = "cmp*" },
				{ "hrsh7th/cmp-buffer", module_pattern = "cmp*" },
				{ "hrsh7th/cmp-path", module_pattern = "cmp*" },
				{ "tzachar/cmp-tabnine", run = "./install.sh", module_pattern = "cmp*" },
				{ "ray-x/cmp-treesitter", module_pattern = "cmp*" },
				{ "quangnguyen30192/cmp-nvim-tags", module_pattern = "cmp*" },
				{ "hrsh7th/vim-vsnip", module_pattern = "cmp*" },
			},
		})

		use({
			"mfussenegger/nvim-dap",
			opt = true,
			ft = { "typescript", "javascript" },
			config = function()
				local dap = require("dap")
				dap.adapters.node2 = {
					type = "executable",
					command = "node",
					args = { os.getenv("HOME") .. "/.config/nvim/langservers/vscode-node-debug2/out/src/nodeDebug.js" },
				}
				dap.configurations.javascript = {
					{
						type = "node2",
						request = "launch",
						program = "${file}",
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
					},
				}
				dap.configurations.typescript = {
					{
						type = "node2",
						request = "launch",
						program = "${file}",
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
					},
				}
			end,
		})
		use({
			"glepnir/galaxyline.nvim",
			branch = "main",
			config = function()
				require("tt.statusline")
			end,
		})
		use({
			"nvim-telescope/telescope.nvim",
			module_pattern = "telescope.*",
			requires = {
				{ "nvim-lua/popup.nvim" },
				{ "nvim-lua/plenary.nvim" },
			},
			config = function()
				require("tt.plugin.telescope")
			end,
		})
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
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
				"bash",
				"yaml",
				"markdown",
				"lua",
			},
			config = function()
				require("tt.lsp").configureLSP()
			end,
		})
		use({ "rust-lang/rust.vim", ft = { "rust" } })
		use({ "wbthomason/packer.nvim", opt = true })
		use("nvim-treesitter/playground")
		use({
			"nvim-treesitter/nvim-treesitter",
			module_pattern = "nvim-treesitter.*",
			config = function()
				require("tt.plugin.treesitter")
			end,
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
