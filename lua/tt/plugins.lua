local function gh(pkg)
	return "https://github.com/" .. pkg
end

vim.pack.add({
	gh("nvim-mini/mini.surround"),
	-- The main branch installs parsers but does not enable highlighting.
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
})

-- A parser can be absent. Keep syntax highlighting if Treesitter cannot start.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
	callback = function(ev)
		if vim.bo[ev.buf].filetype ~= "acp" and not require("tt.buffer").is_large(ev.buf) then
			pcall(vim.treesitter.start, ev.buf)
		end
	end,
})
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	group = vim.api.nvim_create_augroup("tt_large_highlight", { clear = true }),
	callback = function(ev)
		if require("tt.buffer").is_large(ev.buf) then
			vim.treesitter.stop(ev.buf)
		end
	end,
})

require("tt.dir").setup()

-- An empty load callback keeps these plugins off runtimepath until packadd.
vim.pack.add({
	gh("windwp/nvim-autopairs"),
	gh("catgoose/nvim-colorizer.lua"),
	gh("nvim-treesitter/nvim-treesitter-context"),
	gh("windwp/nvim-ts-autotag"),
	gh("J-Cowsert/classlayout.nvim"),
	gh("dmmulroy/ts-error-translator.nvim"),
	gh("reedes/vim-wordy"),
}, { load = function() end })

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

-- Surround mappings must work before Insert mode is entered.
require("mini.surround").setup()
local lazy_load = vim.api.nvim_create_augroup("Plugins", { clear = true })
require("tt.plugin.find").init()
local lazy = require("tt.lazy")
lazy.commands({
	Agent = {},
	AgentChats = {},
	AgentStatus = {},
	AgentStop = {},
	AgentLog = {},
	AgentDebug = {},
	AgentAccept = {},
	AgentVerbose = {},
	AgentRef = {},
	AgentPersist = {},
	AgentSessions = {},
	AgentPing = {},
	AgentSend = { range = true },
	AgentSave = { bang = true, nargs = "?", complete = "file" },
}, function()
	require("tt.plugin.acp").init()
end)
lazy.commands({
	PrList = { nargs = "*" },
	PrView = { nargs = "?" },
	PrCheckout = { nargs = 1 },
	PrDiff = { nargs = "?" },
	PrMine = { nargs = "?" },
	PrReviews = { nargs = "?" },
}, function()
	require("tt.plugin.pr").init()
end)

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

local load_context = lazy.commands({ TSContext = { nargs = "*" } }, function()
	vim.cmd.packadd("nvim-treesitter-context")
	require("tt.plugin.treesitter").init()
end)
vim.api.nvim_create_autocmd("WinScrolled", {
	group = lazy_load,
	callback = function(ev)
		local win = tonumber(ev.match)
		if not win or not vim.api.nvim_win_is_valid(win) or vim.fn.line("w0", win) <= 1 then
			return
		end
		local buf = vim.api.nvim_win_get_buf(win)
		if
			vim.bo[buf].buftype ~= ""
			or vim.bo[buf].filetype == ""
			or vim.bo[buf].filetype == "acp"
			or require("tt.buffer").is_large(buf)
		then
			return
		end
		vim.api.nvim_win_call(win, load_context)
		return true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = lazy_load,
	pattern = { "html", "xml", "javascriptreact", "typescriptreact", "astro", "svelte", "vue" },
	callback = function(ev)
		if require("tt.buffer").is_large(ev.buf) then
			return
		end
		vim.cmd.packadd("nvim-ts-autotag")
		require("nvim-ts-autotag").setup({ aliases = { astro = "html" } })
		return true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = lazy_load,
	pattern = {
		"c",
		"cpp",
		"css",
		"scss",
		"html",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"lua",
	},
	callback = function(ev)
		if require("tt.buffer").is_large(ev.buf) then
			return
		end
		vim.cmd.packadd("nvim-colorizer.lua")
		require("tt.plugin.colorizer").setup()
		return true
	end,
})
