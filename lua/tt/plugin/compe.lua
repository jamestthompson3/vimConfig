local cmp = require("cmp")
local luasnip = require("luasnip")
local kind_symbols = require("tt.tools").kind_symbols()

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "buffer" },
		{ name = "luasnip", priority = 15 },
		{ name = "tags", priority = 5 },
		{ name = "nvim_lsp_signature_help", priority = 12 },
		{ name = "nvim_lsp", priority = 10 },
		{ name = "cmp_tabnine" },
		{ name = "treesitter" },
		{ name = "path" },
	},

	documentation = {
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		-- 	winhighlight = "FloatBorder",
	},

	formatting = {
		format = function(entry, vim_item)
			local completeKind = kind_symbols[vim_item.kind]
			vim_item.kind = completeKind
			vim_item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }
			return vim_item
		end,
	},

	experimental = {
		native_menu = false,
	},
})
local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "~>",
	show_prediction_strength = true,
})
