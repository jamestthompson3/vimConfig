local g = vim.g
local bootstrap = require("tt.ft.ecma").bootstrap
g.tagbar_type_typescript = {
	{ ctagstype = "typescript" },
	{
		kinds = {
			"f=functions",
			"c=classes",
			"i=interfaces",
			"g=enums",
			"e=enumerators",
			"m=methods",
			"n=namespaces",
			"p=properties",
			"v=variables",
			"C=constants",
			"G=generators",
			"a=aliases",
		},
	},
	{ sro = "." },
	{
		kind2scope = {
			c = "classes",
			a = "aliases",
			f = "functions",
			v = "variables",
			m = "methods",
			i = "interfaces",
			e = "enumerators",
			enums = "g",
		},
	},
	{
		scope2kind = {
			classes = "c",
			aliases = "a",
			functions = "f",
			variables = "v",
			methods = "m",
			interfaces = "i",
			enumerators = "e",
			enums = "g",
		},
	},
}

g.tagbar_type_typescriptreact = 1

-- For andymass/vim-matchup plugin
if vim.g.loaded_matchup then
	vim.b.matchpairs = "(:),{:},[:],<:>"
	vim.b.match_words = "<@<=([^/][^ \t>]*)g{hlend}[^>]*%(/@<!>|$):<@<=/\1>"
	vim.b.match_skip = "s:comment|string"
end
bootstrap()
