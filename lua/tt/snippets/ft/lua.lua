local ls = require("luasnip")

local snippet = ls.s
local fmt = require("luasnip.extras.fmt").fmt

local i, t, f = ls.insert_node, ls.text_node, ls.function_node

local M = {
	snippet("l", fmt("log({})", { i(1) })),
	snippet(
		"req",
		fmt('local {} = require("{}")', {
			f(function(import_name)
				local parts = vim.split(import_name[1][1], ".", true)
				return parts[#parts] or ""
			end, {
				1,
			}),
			i(1),
		})
	),
}

return M
