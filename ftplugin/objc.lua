local buf_nnoremap = require("tt.nvim_utils").keys.buf_nnoremap

vim.o.path = vim.o.path .. "/System/Library/Frameworks/Foundation.framework/Headers/**"
vim.b.source_ft = { "m", "mm" }
buf_nnoremap({ "<silent><leader>h", ":call tools#switchSourceHeader()<CR>" })
vim.bo.define = "^(#s*define|[a-z]*s*consts*[a-z]*)"
