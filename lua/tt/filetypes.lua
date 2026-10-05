vim.filetype.add({
	pattern = {
		-- Objective-C/C++ (builtin detects .m as matlab, .mm as nroff)
		[".*%.mm"] = "objc",
		[".*%.m"] = "objc",

		-- Dockerfile (.dock extension is not builtin)
		[".*%.dock"] = "dockerfile",

		-- Web Development (.svelte -> html on purpose; builtin gives svelte)
		[".*%.svelte"] = "html",
		[".*%.pcss"] = "css",

		-- Configuration files (builtin detects these as jsonc, not json)
		[".*%.eslintrc"] = "json",
		[".*%.babelrc"] = "json",
		[".*%.huskyrc"] = "json",

		-- Others (builtin detects .sys as bat, .wiki as mediawiki)
		[".*%.sys"] = "dosbatch",
		[".*%.wiki"] = "wiki",
	},
})
