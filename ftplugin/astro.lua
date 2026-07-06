vim.bo.formatoptions = vim.bo.formatoptions .. "o"
require("tt.ft.ecma").bootstrap()

vim.cmd("hi! astroFence guifg=magenta")
