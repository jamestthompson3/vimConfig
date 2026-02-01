local tools = require("tt.tools")
local git = require("tt.git")

-- INSERT MODE
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })
vim.keymap.set("i", "<C-T>", "<C-X><C-]>", { noremap = true })
vim.keymap.set("i", "<C-F>", "<C-X><C-F>", { noremap = true })
vim.keymap.set("i", "<C-D>", "<C-X><C-D>", { noremap = true })
vim.keymap.set("i", "<C-L>", "<C-X><C-L>", { noremap = true })

-- TERMINAL MODE
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- NORMAL MODE
vim.keymap.set("n", "<up>", ":m .-2<cr>==", { noremap = true, silent = true })
vim.keymap.set("n", "<down>", ":m .+1<cr>==", { noremap = true, silent = true })
vim.keymap.set("n", "'", "`", { noremap = true })
vim.keymap.set("n", "Y", "y$", { noremap = true })
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true })
vim.keymap.set("n", "<leader>P", '"+P', { noremap = true })
vim.keymap.set("n", "g.", '/\\V\\C<C-r>"<CR>cgn<C-a><Esc>', { noremap = true })
vim.keymap.set(
	"n",
	"z/",
	":let @/='\\<<C-R>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>",
	{ noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>e", ":e <C-R>=expand('%:p:h') . '/'<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<C-J>", function()
	tools.winMove("j")
end)
vim.keymap.set("n", "<C-L>", function()
	tools.winMove("l")
end)
vim.keymap.set("n", "<C-H>", function()
	tools.winMove("h")
end)
vim.keymap.set("n", "<C-K>", function()
	tools.winMove("k")
end)
vim.keymap.set("n", "ssb", tools.sourceSession)
vim.keymap.set("n", "<F1>", tools.profile)
vim.keymap.set("n", "<leader>B", git.blame_file)
vim.keymap.set("n", "<leader>b", git.blame)
vim.keymap.set("n", "<leader>d", function()
	tools.openTerminalDrawer()
end)

vim.keymap.set("n", "n", function()
	pcall(vim.cmd, "normal! n")
	require("tt.nvim_utils").hl_search_match(0.15)
end, { silent = true })

vim.keymap.set("n", "N", function()
	pcall(vim.cmd, "normal! N")
	require("tt.nvim_utils").hl_search_match(0.15)
end, { silent = true })

vim.keymap.set("n", "<Esc>", function()
	pcall(vim.cmd, "nohlsearch")
end, { silent = true })

vim.keymap.set("n", "-", function()
	require("oil").open()
end, { silent = true })

vim.keymap.set("n", "<leader>a", function()
	vim.cmd("argadd %")
	vim.cmd("argdedupe")
end, { silent = true })

vim.keymap.set("n", "<leader>1", function()
	vim.cmd("silent! 1argument")
end, { silent = true })

vim.keymap.set("n", "<leader>2", function()
	vim.cmd("silent! 2argument")
end, { silent = true })

vim.keymap.set("n", "<leader>3", function()
	vim.cmd("silent! 3argument")
end, { silent = true })

vim.keymap.set("n", "cc", vim.cmd.cclose, { noremap = true, silent = true })
vim.keymap.set("n", "cl", vim.cmd.lclose, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>h", "<Cmd>call tools#switchSourceHeader()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>m", ":make<CR>", { noremap = true })
vim.keymap.set("n", "<leader>-", '<Cmd>let @+ = expand("%")<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<F7>", '<Cmd>so "%"<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "S", ":%s//g<LEFT><LEFT>", { noremap = true })
vim.keymap.set("n", "g_", ":g//#<Left><Left><C-R><C-W><CR>:", { noremap = true })
vim.keymap.set("n", "<C-f>", ":silent grep!<space>", { noremap = true })

-- VISUAL MODE
vim.keymap.set("x", "<leader>y", '"+y', { noremap = true })
vim.keymap.set("x", "<leader>d", '"+d', { noremap = true })
-- Don't trash current register when pasting in visual mode
vim.keymap.set("x", "p", "p:if v:register == '\"'<Bar>let @@=@0<Bar>endif<cr>", { noremap = true })
vim.keymap.set("x", "I", "(mode()=~#'[vV]'?'<C-v>^o^I':'I')", { noremap = true, expr = true })
vim.keymap.set("x", "A", "(mode()=~#'[vV]'?'<C-v>0o$A':'A')", { noremap = true, expr = true })
vim.keymap.set("v", "<up>", ":m '<-2<cr>gv=gv", { noremap = true })
vim.keymap.set("v", "<down>", ":m '>+1<cr>gv=gv", { noremap = true })
-- vim.keymap.set("v", "s", ":s//g<LEFT><LEFT>", { noremap = true })
vim.keymap.set("x", "<leader>b", "<Cmd>Gblame<CR>", { noremap = true, silent = true })
