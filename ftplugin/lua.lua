require("tt.snippets.ft.lua").init()
vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
vim.opt_local.suffixesadd:prepend(".lua")
vim.opt_local.suffixesadd:prepend("init.lua")
vim.b.autoformat = true
