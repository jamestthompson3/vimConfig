vim.cmd.packadd("cfilter")

vim.keymap.set("n", "ra", ":ReplaceAll<CR>", { buf = 0, silent = true })
vim.keymap.set("n", "R", ":Cfilter!<space>", { buf = 0 })
vim.keymap.set("n", "K", ":Cfilter<space>", { buf = 0 })
