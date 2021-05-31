local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    winblend = 15,
    color_devicons = true,
    prompt_prefix = require "nvim-nonicons".get("telescope") .. " ",
    entry_prefix = "   ",
    shorten_path = true,
    results_height = 6,
  },
  mappings = {
    ["<CR>"] = actions.select_default,
    ["<esc>"] = actions.close
  }
}
require('telescope').load_extension('fzy_native')
