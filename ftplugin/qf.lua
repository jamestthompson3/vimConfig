local buf_nnoremap = require("tt.nvim_utils").keys.buf_nnoremap

buf_nnoremap({"<Left>", ":call quickfixed#history(0)<CR>"})
buf_nnoremap({"<Right>", ":call quickfixed#history(1)<CR>"})
