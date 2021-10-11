M = {}

-- Check if the packer tool exists
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
	-- TODO: Maybe handle windows better?
	if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
		return
	end

	local directory = string.format("%s/pack/packer/opt", vim.fn.stdpath("config"))

	vim.fn.mkdir(directory, "p")

	local out = vim.fn.system(
		string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", directory .. "/packer.nvim")
	)

	print(out)
	print("Downloading packer.nvim...")

	return
end

return require("packer").startup(function()
	-- use("nathom/filetype.nvim")
	use("justinmk/vim-dirvish")
	use("yamatsum/nvim-web-nonicons")
	use("romainl/vim-cool")
	use("tmsvg/pear-tree")
	use("tpope/vim-apathy")
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
			{ "hrsh7th/cmp-nvim-lsp",  module = "cmp_nvim_lsp" },
			{ "hrsh7th/cmp-buffer",  module_pattern = "cmp*" },
			{ "hrsh7th/cmp-path", module_pattern = "cmp*" },
			{ "ray-x/cmp-treesitter", module_pattern = "cmp*" },
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
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
		config = function()
			require("tt.plugin.telescope")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({
		"neovim/nvim-lspconfig",
		-- ft = {
		-- 	"typescript",
		-- 	"typescriptreact",
		-- 	"javascript",
		-- 	"javascriptreact",
		-- 	"rust",
		-- 	"html",
		-- 	"css",
		-- 	"json",
		-- 	"go",
		-- 	"bash",
		-- 	"yaml",
		-- 	"markdown",
		-- 	"lua",
		-- },
		config = function()
			require("tt.lsp").configureLSP()
		end,
	})
	use({ "wbthomason/packer.nvim", opt = true })
	-- use("nvim-treesitter/playground")
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
end)
