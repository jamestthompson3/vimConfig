local ls = require("luasnip")

local snippet = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local t = ls.text_node

local M = {
	snippet(
		"twh",
		fmt("content-type: wikitext\ncreated: {}\ntitle: {}\nmodified: {}\nid: {}\ntags: []\n\n", {
			t(string.format("%s", vim.fn.strftime("%Y%m%d%H%M%S"))),
			t(string.format("%s", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r"))),
			t(string.format("%s", vim.fn.strftime("%Y%m%d%H%M%S"))),
			t(string.format("%s", vim.fn.strftime("%Y%m%d%H%M%S"))),
		})
	),
}

return M
