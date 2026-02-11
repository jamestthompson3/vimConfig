vim.b.source_ft = { "c" }
vim.opt_local.formatoptions:remove({ "r", "o" })

require("tt.lsp.efm").init()
vim.lsp.start(vim.lsp.config.efm)
