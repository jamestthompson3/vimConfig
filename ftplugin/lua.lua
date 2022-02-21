vim.api.nvim_command([[set includeexpr=substitute(v:fname,'\\.','/','g')]])
vim.keymap.set("n", "<leader>f", "<cmd>!stylua %<CR>", { silent = true, buffer = true })
vim.bo.suffixesadd = ".lua"
