require'tt.user_lsp'.setMappings()
require('tt.nvim_utils')

vim.b.ale_fixers = {'rustfmt'}


local mappings = {
  ["i<C-l>"]  = {'println!("{}")<esc>i', noremap = true, buffer = true},
}

vim.compiler = "cargo"


nvim_apply_mappings(mappings, {silent = true})
