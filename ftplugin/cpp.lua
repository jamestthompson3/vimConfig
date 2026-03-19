vim.b.source_ft = { "h", "hpp" }
vim.keymap.set("n", "<leader>h", function()
	require("tt.tools").switchSourceHeader()
end, { buffer = true, silent = true })
vim.bo.define = "^(#s*define|[a-z]*s*consts*[a-z]*)"

require("tt.lsp.efm").init()
vim.lsp.start(vim.lsp.config.efm)
