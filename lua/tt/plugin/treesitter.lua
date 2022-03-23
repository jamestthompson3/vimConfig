local ts_config = require("nvim-treesitter.configs")
local function setCustomGroups()
	-- custom syntax since treesitter overrides nvim defaults
	-- Doesn't work... :/
	api.nvim_command([[match Todo /\c@\?\(todo\|fixme\)/]])
	api.nvim_command([[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']])
	-- this one works tho...
	-- @todo: thing
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
		"graphql",
		"rust",
		"typescript",
		"tsx",
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		-- additional_vim_regex_highlighting = true,
	},
})

-- setCustomGroups()
