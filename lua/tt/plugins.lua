local function gh(pkg)
	return "https://github.com/" .. pkg
end

vim.pack.add({
	gh("OXY2DEV/markview.nvim"),
	-- Kept only as a parser installer / query provider (`:TSInstall`, `:TSUpdate`).
	-- The `main` branch does not auto-enable highlighting; we call
	-- vim.treesitter.start() ourselves (see below), so nothing here forces its
	-- highlighter on.
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
})

-- nvim-treesitter (main) only installs parsers; starting the highlighter is
-- ours to do. pcall so filetypes without an installed parser fall back to
-- regex 'syntax' silently instead of erroring.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- Buffer-local create/rename/delete on the builtin |dir| browser (`a`/`r`/`dd`).
require("tt.dir").setup()

-- markview does its own internal filetype-gated lazy loading (it only attaches
-- to buffers matching its `preview.filetypes`), so it must be loaded eagerly
-- and configured up front.
require("markview").setup({
	markdown = {
		block_quotes = { enable = false },
		headings = { enable = false },
		horizontal_rules = { enable = false },
		list_items = { enable = false },
		metadata_minus = { enable = false },
		metadata_plus = { enable = false },
		reference_definitions = { enable = false },
	},
	markdown_inline = { enable = false },
	asciidoc = { enable = false },
	asciidoc_inline = { enable = false },
	comment = { enable = false },
	html = { enable = false },
	latex = { enable = false },
	typst = { enable = false },
	yaml = { enable = false },
})

-- Installed by vim.pack but loaded later via packadd
vim.pack.add({
	gh("nvim-mini/mini.surround"),
	gh("windwp/nvim-autopairs"),
	gh("catgoose/nvim-colorizer.lua"),
	gh("nvim-treesitter/nvim-treesitter-context"),
	gh("windwp/nvim-ts-autotag"),
	gh("J-Cowsert/classlayout.nvim"),
	gh("dmmulroy/ts-error-translator.nvim"),
	gh("reedes/vim-wordy"),
}, { load = function() end })

-- vim-wordy: load on the first use of one of its commands.
local wordy_cmds = { "Wordy", "NoWordy", "NextWordy", "PrevWordy" }
for _, name in ipairs(wordy_cmds) do
	vim.api.nvim_create_user_command(name, function(opts)
		for _, n in ipairs(wordy_cmds) do
			vim.api.nvim_del_user_command(n)
		end
		vim.cmd.packadd("vim-wordy")
		vim.cmd(name .. " " .. opts.args)
	end, { nargs = "*" })
end

local disabled_plugins = {
	"gzip",
	"netrwPlugin",
	"rplugin",
	"tarPlugin",
	"tutor",
}

for _, p in ipairs(disabled_plugins) do
	vim.g["loaded_" .. p] = 1
end

local lazy_load = vim.api.nvim_create_augroup("Plugins", { clear = true })
require("tt.plugin.find").init()
require("tt.plugin.acp").init()
require("tt.plugin.pr").init()

vim.api.nvim_create_autocmd("InsertEnter", {
	group = lazy_load,
	once = true,
	callback = function()
		vim.cmd.packadd("nvim-autopairs")
		require("nvim-autopairs").setup()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = lazy_load,
	pattern = { "c", "cpp", "objc", "objcpp" },
	once = true,
	callback = function()
		vim.cmd.packadd("classlayout.nvim")
		require("classlayout").setup({ keymap = false, compiler = "clang" })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = lazy_load,
	once = true,
	callback = function()
		vim.cmd.packadd("nvim-treesitter-context")
		vim.cmd.packadd("nvim-ts-autotag")
		require("tt.plugin.treesitter").init()
		vim.cmd.packadd("mini.surround")
		require("mini.surround").setup()
		require("nvim-ts-autotag").setup({
			aliases = {
				["astro"] = "html",
			},
		})
		vim.cmd.packadd("nvim-colorizer.lua")
		require("colorizer").setup({
			filetypes = { "c", "cpp", "css", "scss", "html", "javascript", "typescript", "lua" },
			parsers = { css = true },
		})
	end,
})
