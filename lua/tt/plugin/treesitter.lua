local M = {}

M.supported_langs = {
	"comment",
	"fish",
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
	"svelte",
	"typescript",
	"tsx",
}
local function setCustomGroups()
	-- custom syntax since treesitter overrides nvim defaults
	-- Doesn't work... :/
	api.nvim_command([[match Todo /\c@\?\(todo\|fixme\)/]])
	api.nvim_command([[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']])
	-- this one works tho...
	-- @todo: thing
	api.nvim_command([[match ExtraWhitespace /\s\+$/]])
end

local lines = vim.fn.line("$")

function M.init()
	ts_config = require("nvim-treesitter.configs")
	if lines > 30000 then -- skip some settings for large files
		require("nvim-treesitter.configs").setup({ highlight = { enable = enable } })
		return
	end
	require("treesitter-context").setup({
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		max_lines = -1, -- How many lines the window should span. Values <= 0 mean no limit.
		trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
			-- For all filetypes
			-- Note that setting an entry here replaces all other patterns for this entry.
			-- By setting the 'default' entry below, you can control which nodes you want to
			-- appear in the context window.
			default = {
				"class",
				"function",
				"method",
				"for",
				"while",
				"if",
				"switch",
				"case",
			},
			-- Patterns for specific filetypes
			-- If a pattern is missing, *open a PR* so everyone can benefit.
			rust = {
				"impl_item",
				"struct",
				"enum",
			},
			scala = {
				"object_definition",
			},
			markdown = {
				"section",
			},
			json = {
				"pair",
			},
			yaml = {
				"block_mapping_pair",
			},
		},
		exact_patterns = {
			-- Example for a specific filetype with Lua patterns
			-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
			-- exactly match "impl_item" only)
			-- rust = true,
		},

		-- [!] The options below are exposed but shouldn't require your attention,
		--     you can safely ignore them.

		zindex = 20, -- The Z-index of the context window
		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
		-- Separator between context and content. Should be a single character string, like '-'.
		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
		separator = nil,
	})

	ts_config.setup({
		ensure_installed = supported_langs,
		matchup = {
			enable = true,
		},
		autopairs = { enable = true },
		auto_install = true,
		disable = { "prisma" }, -- langs where the plugin is better
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
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
	})
end

return M

-- setCustomGroups()
