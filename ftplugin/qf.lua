vim.keymap.set("n", "<Left>", ":call quickfixed#history(0)<CR>", { buffer = true })
vim.keymap.set("n", "<Right>", ":call quickfixed#history(1)<CR>", { buffer = true })
