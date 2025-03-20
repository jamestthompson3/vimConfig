require("tt.snippets.ft.lua")
vim.api.nvim_command([[set includeexpr=substitute(v:fname,'\\.','/','g')]])
vim.keymap.set("n", "<leader>f", "<cmd>!stylua %<CR>", { silent = true, buffer = true })
vim.opt_local.suffixesadd:prepend(".lua")
vim.opt_local.suffixesadd:prepend("init.lua")
vim.b.autoformat = true
