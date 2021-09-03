local ts_config = require("nvim-treesitter.configs")
local function setCustomGroups()
	-- custom syntax
	api.nvim_command([[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']])
	api.nvim_command([[match ExtraWhitespace /\s\+$/]])
end

ts_config.setup({
	ensure_installed = {
    "comment",
		"bash",
		"c",
		"cpp",
		"lua",
		"go",
		"css",
		"html",
		"javascript",
		"json",
		"java",
		"scala",
		"python",
		"rust",
		"typescript",
		"tsx",
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		-- additional_vim_regex_highlighting = true,
	},
})

-- setCustomGroups()
