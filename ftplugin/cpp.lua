local buf_nnoremap = require("tt.nvim_utils").keys.buf_nnoremap

vim.b.source_ft = { "h", "hpp" }
buf_nnoremap({ "<silent><leader>h", ":call tools#switchSourceHeader()<CR>" })
vim.bo.define = "^(#s*define|[a-z]*s*consts*[a-z]*)"
