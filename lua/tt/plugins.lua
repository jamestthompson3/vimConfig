M = {}
local api = vim.api

-- Check if the packer tool exists
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
	-- TODO: Maybe handle windows better?
	if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
		return
	end

	local directory = string.format("%s/pack/packer/opt", vim.fn.stdpath("config"))

	vim.fn.mkdir(directory, "p")

	local out = vim.fn.system(string.format(
		"git clone %s %s",
		"https://github.com/wbthomason/packer.nvim",
		directory .. "/packer.nvim"
	))

	print(out)
	print("Downloading packer.nvim...")

	return
end

return require("packer").startup(function()
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
		"hrsh7th/nvim-compe",
		config = function()
			require("tt.plugin.compe")
		end,
		requires = { { "hrsh7th/vim-vsnip" } },
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
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzy-native.nvim" } },
		config = function()
			require("tt.plugin.telescope")
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("tt.user_lsp").configureLSP()
		end,
	})
	use({ "wbthomason/packer.nvim", opt = true })
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("tt.plugin.treesitter")
		end,
	})
	use({
		"majutsushi/tagbar",
		opt = true,
		ft = { "c", "cpp", "typescript", "typescriptreact", "javascript", "javascriptreact" },
	})
	use({ "norcalli/nvim-colorizer.lua", opt = true, ft = { "html", "css", "vim" } })
	use({ "reedes/vim-wordy", opt = true, ft = { "txt", "md", "markdown", "text" } })
	use({ "dense-analysis/ale", opt = true, ft = { "c", "cpp", "go", "rust", "scala", "python", "objcpp", "objc", "reason" } })
end)
