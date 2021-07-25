local actions = require("telescope.actions")
require("telescope").setup({
  config = {
    winblend = 15,
    color_devicons = true,
    prompt_prefix = require("nvim-nonicons").get("telescope") .. " ",
    entry_prefix = "   ",
    shorten_path = true,
    results_height = 6,
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  },
  mappings = {
    ["<CR>"] = actions.select_default,
    ["<esc>"] = actions.close,
  },
})
require("telescope").load_extension("fzf")
