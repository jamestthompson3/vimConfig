vim.bo.formatoptions = vim.bo.formatoptions .. "o"
local bootstrap = require("tt.ft.ecma").bootstrap

--TAGBAR:
if vim.g.tagbar_type_typescript == nil then
	vim.g.tagbar_type_typescript = {
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

	vim.g.tagbar_type_typescriptreact = vim.g.tagbar_type_typescript
end

bootstrap()
