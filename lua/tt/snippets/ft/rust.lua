local ls = require("luasnip")

local snippet = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local i = ls.insert_node
local t = ls.text_node

local M = {
	snippet("l", fmt('println!("{}");', { i(1) })),
	snippet("fn", fmt("fn {}({}) -> {} {{\n\t{}\n}}", { i(1), i(2), i(3), i(4) })),
	snippet("modtest", fmt("#[cfg(test)]\nmod tests {{\nuse super::*;\n\n#[test]\nfn {}() {{\n\t{}\n}}}}", { i(1), i(2) })),
	snippet("tst", fmt("#[test]\nfn {}() {{\n\t{}\n}}", { i(1), i(2) })),
}

return M
