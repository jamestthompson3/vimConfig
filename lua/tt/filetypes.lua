vim.filetype.add({
	pattern = {
		-- Nginx
		["[nN]ginx.*%.conf"] = "nginx",
		["*/etc/nginx/*"] = "nginx",
		["*/usr/local/nginx/conf/*"] = "nginx",
		["*/nginx/.*%.conf"] = "nginx",
		[".*%.nginx"] = "nginx",

		-- Objective-C/C++
		[".*%.mm"] = "objc",
		[".*%.m"] = "objc",

		-- Dockerfile
		["[Dd]ockerfile.*"] = "dockerfile",
		[".*%.dock"] = "dockerfile",

		-- Web Development
		[".*%.svelte"] = "html",
		[".*%.pcss"] = "css",

		-- Configuration files
		[".*%.eslintrc"] = "json",
		[".*%.babelrc"] = "json",
		[".*%.prettierrc"] = "json",
		[".*%.huskyrc"] = "json",
		[".*%.swcrc"] = "json",
		["%.swcrc"] = "json",

		-- Others
		[".*%.bat"] = "dosbatch",
		[".*%.sys"] = "dosbatch",
		[".*%.wiki"] = "wiki",
	},
})
