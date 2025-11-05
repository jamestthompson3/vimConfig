vim.b.source_ft = { "h", "hpp" }
vim.keymap.set("n", "<leader>h", ":call tools#switchSourceHeader()<CR>", { buffer = true, silent = true })
vim.bo.define = "^(#s*define|[a-z]*s*consts*[a-z]*)"
