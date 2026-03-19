vim.o.path = vim.o.path .. "/System/Library/Frameworks/Foundation.framework/Headers/**"
vim.b.source_ft = { "m", "mm" }
vim.keymap.set("n", "<leader>h", function()
	require("tt.tools").switchSourceHeader()
end, { buffer = true, silent = true })
vim.bo.define = "^(#s*define|[a-z]*s*consts*[a-z]*)"
