vim.b.source_ft = { "c" }
vim.opt_local.formatoptions:remove({ "r", "o" })

require("tt.lsp.efm").init()
vim.lsp.start(vim.lsp.config.efm)

-- Auto-insert include guard for new files
if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
  local guard = vim.fn.expand("%:t"):upper():gsub("[^%w]", "_")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, {
    "#ifndef " .. guard,
    "#define " .. guard,
    "",
    "",
    "#endif /* " .. guard .. " */",
  })
  vim.api.nvim_win_set_cursor(0, { 4, 0 })
end
