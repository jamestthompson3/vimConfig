local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

local shared = require("tt.snippets")
local ecma = require("tt.snippets.ft.ecmascript")
local ts = require("tt.snippets.ft.typescript")
local lua = require("tt.snippets.ft.lua")
local rust = require("tt.snippets.ft.rust")

local snippets = {}

ls.add_snippets("go", shared.make(require("tt.snippets.ft.go")))
ls.add_snippets("javascript", ecma)
ls.add_snippets("typescript", ts)
ls.add_snippets("lua", lua)
ls.add_snippets("rust", rust)

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
