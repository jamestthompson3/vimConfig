return {
	filetypes = { "go" },
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				staticcheck = true,
			},
		},
	},
}
