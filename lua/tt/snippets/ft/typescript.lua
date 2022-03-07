local ls = require("luasnip")

local snippet = ls.s
local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local t = ls.text_node

local M = {
	snippet("fn", fmt("function {} ({}): {} {{\n\t{}\n}}", { i(1), i(2), i(3), i(4) })),
	snippet("cn", fmt("const {} = ({}): {} => {{\n\t{}\n}}", { i(1), i(2), i(3), i(4) })),
}

return M
