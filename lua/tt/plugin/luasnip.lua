local ls = require("luasnip")
-- some shorthands...
local types = require("luasnip.util.types")

local ecma = require("tt.snippets.ft.ecmascript")
local ts = require("tt.snippets.ft.typescript")
local lua = require("tt.snippets.ft.lua")
local rust = require("tt.snippets.ft.rust")
local text = require("tt.snippets.ft.text")

local snippets = {}

-- ls.add_snippets("go", shared.make(require("tt.snippets.ft.go")))
ls.add_snippets("javascript", ecma)
ls.add_snippets("typescript", ts)
ls.add_snippets("lua", lua)
ls.add_snippets("rust", rust)
ls.add_snippets("text", text)

ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "typescript", "javascript" })
ls.filetype_extend("javascriptreact", { "javascript" })

ls.snippets = snippets

-- testing
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/tt/plugin/luasnip.lua<CR>")

ls.config.set_config({
	enable_autosnippets = true,
	updateevents = "TextChanged,TextChangedI",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = {
					{ "←", "Error" },
				},
			},
		},
	},
})
