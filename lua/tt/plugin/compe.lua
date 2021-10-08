local cmp = require("cmp")

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end


cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
        log("gotcha!")
				if vim.fn["vsnip#available"]() == 1 then
					return vim.api.nvim_feedkeys(t("<Plug>(vsnip-expand-or-jump)"), "i")
				end
				cmp.select_next_item()
			elseif check_back_space() then
				vim.fn.feedkeys(t("<tab>"), "n")
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
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
		{ name = "treesitter" },
		{ name = "path" },
		{ name = "buffer" },
	},
})
