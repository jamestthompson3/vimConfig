require('tt.nvim_utils')
require'tt.user_lsp'.setMappings()

vim.b.ale_fixers = {"prettier"}
vim.b.ale_linters = {}
vim.bo.suffixesadd = ".js",".jsx",".ts",".tsx"
vim.bo.include = "^\\s*[^/]\\+\\(from\\|require(['\"]\\)"
vim.bo.define = "class\\s"
vim.wo.foldlevel = 99

local mappings = {
  ["i<C-l>"]  = {"console.log()<esc>i", noremap = true, buffer = true},
  ["i<C-c>"]  = {"console.log('%c%o', 'color: ;')<esc>F%;la", noremap = true, buffer = true},
  ["id<C-l>"] = {"debugger", noremap = true, buffer = true}
}

nvim_apply_mappings(mappings, {silent = true})
