local M = {}


-- function M.init()
--   local kind_symbols = require("tt.tools").kind_symbols()
--   require("mini.completion").setup({
--     window = {
--       info = { height = 45, width = 80, border = 'rounded' },
--       signature = { height = 45, width = 80, border = 'rounded' },
--     },
--     -- lsp_completion = {
--     -- 	process_items = function(items, base)
--     -- 		items = MiniCompletion.default_process_items(items, base)
--     -- 		symbol_items = vim.tbl_map(function(x)
--     -- 			local lsp_kind = vim.lsp.protocol.CompletionItemKind[x.kind]
--     -- 			local completeKind = kind_symbols[lsp_kind]
--     -- 			x.kind = completeKind
--     -- 			return x
--     -- 		end, items)
--     -- 		return symbol_items
--     -- 	end,
--     -- },
--     fallback_action = "<C-x><C-]>",
--   })
--   require("nvim-autopairs").setup()
-- end

local cmp = require("cmp")
local luasnip = require("luasnip")
local kind_symbols = require("tt.tools").kind_symbols()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.init()
  cmp.setup({
    mapping = {
      ["<C-n>"] = cmp.mapping(function(fallback)
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
      ["<C-p>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<C-y>"] = cmp.mapping.confirm({
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
      { name = "supermaven" },
      { name = "buffer" },
      { name = "luasnip",                 priority = 15 },
      { name = "tags",                    priority = 5 },
      { name = "nvim_lsp_signature_help", priority = 12 },
      { name = "nvim_lsp",                priority = 10 },
      -- { name = "cmp_tabnine", priority = 11 },
      { name = "treesitter" },
      { name = "path",                    priority = 3 },
    },

    window = {
      documentation = cmp.config.window.bordered(),
      completion = cmp.config.window.bordered(),
      --{ "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
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
      -- native_menu = true,
    },
  })
  require("nvim-autopairs").setup()
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  -- local tabnine = require("cmp_tabnine.config")
  -- tabnine:setup({
  -- 	max_lines = 1000,
  -- 	max_num_results = 20,
  -- 	sort = true,
  -- 	run_on_every_keystroke = true,
  -- 	snippet_placeholder = "~>",
  -- 	show_prediction_strength = true,
  -- })
end

return M
