local ls = require("luasnip")

local snippet = ls.s
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local t = ls.text_node

local M = {
	snippet("l", fmt("log({})", { i(1) })),
	snippet("req", fmt('local {} = require("{}")', { i(1), i(2) })),
}

return M
