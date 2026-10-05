return {
	filetypes = { "go" },
	cmd = { "gopls" },
	settings = {
		gopls = {
			staticcheck = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
}
