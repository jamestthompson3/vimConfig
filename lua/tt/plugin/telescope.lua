local actions = require('telescope.actions')
require('telescope').setup {
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  },
  defaults = {
    winblend = 10,
    color_devicons = true,
    prompt_prefix = "🔎 ",
    results_height = 6,
  },
  mappings = {
    ["<CR>"] = actions.select_default,
    ["<esc>"] = actions.close
  }
}
require('telescope').load_extension('fzy_native')
