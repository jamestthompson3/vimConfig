vim.filetype.add({
	pattern = {
		-- Neovim detects .m as MATLAB and .mm as nroff.
		[".*%.mm"] = "objcpp",
		[".*%.m"] = "objc",

		[".*%.dock"] = "dockerfile",

		-- Use HTML tools for Svelte files.
		[".*%.svelte"] = "html",
		[".*%.pcss"] = "css",

		-- Use JSON instead of Neovim's JSONC detection.
		[".*%.eslintrc"] = "json",
		[".*%.babelrc"] = "json",
		[".*%.huskyrc"] = "json",

		[".*%.sys"] = "dosbatch",
		[".*%.wiki"] = "wiki",
	},
})
