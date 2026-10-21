vim.cmd.packadd("cfilter")

vim.keymap.set("n", "ra", ":ReplaceAll<CR>", { buffer = true, silent = true })
vim.keymap.set("n", "R", ":Cfilter!<space>", { buffer = true })
vim.keymap.set("n", "K", ":Cfilter<space>", { buffer = true })
