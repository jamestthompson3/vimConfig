local nnore = require("tt.nvim_utils").keys.nnore
local inore = require("tt.nvim_utils").keys.inore
local tnore = require("tt.nvim_utils").keys.tnore
local nmap = require("tt.nvim_utils").keys.nmap
local nmap_cmd = require("tt.nvim_utils").keys.nmap_cmd
local nmap_nocr = require("tt.nvim_utils").keys.nmap_nocr
local xmap = require("tt.nvim_utils").keys.xmap
local xmap_cmd = require("tt.nvim_utils").keys.xmap_cmd
local xnore = require("tt.nvim_utils").keys.xnore
local vnore = require("tt.nvim_utils").keys.vnore

local tools = require("tt.tools")
local git = require("tt.git")

-- INSERT MODE
inore("jj", "<Esc>")
inore("<C-T>", "<C-X><C-]>")
inore("<C-F>", "<C-X><C-F>")
inore("<C-D>", "<C-X><C-D>")
inore("<C-L>", "<C-X><C-L>")

-- TERMINAL MODE
tnore("<Esc>", "<C-\\><C-n>")
-- NORMAL MODE
nnore("<up>", ":m .-2<cr>==", { silent = true, expr = true })
nnore("<down>", ":m .+1<cr>==", { silent = true, expr = true })
nnore("'", "`")
nnore("Y", "y$")
nnore("<leader>p", '"+p')
nnore("<leader>P", '"+P')
nnore("g.", '/\\V\\C<C-r>"<CR>cgn<C-a><Esc>')
nnore("z/", ":let @/='\\<<C-R>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", { silent = true })
nmap({ "<leader>e", ":e <C-R>=expand('%:p:h') . '/'<CR>", { noremap = true, silent = false } })
nmap({
	"<C-J>",
	function()
		tools.winMove("j")
	end,
})
nmap({
	"<C-L>",
	function()
		tools.winMove("l")
	end,
})
nmap({
	"<C-H>",
	function()
		tools.winMove("h")
	end,
})
nmap({
	"<C-K>",
	function()
		tools.winMove("k")
	end,
})
nmap({ "ssb", tools.sourceSession })
nmap({ "<F1>", tools.profile })
nmap({ "<leader>B", git.blame_file })
nmap({ "<leader>b", git.blame })
nmap({
	"<leader>d",
	function()
		tools.openTerminalDrawer()
	end,
})

nmap({
	"n",
	function()
		pcall(vim.cmd, "normal! n")
		require("tt.nvim_utils").hl_search_match(0.15)
	end,
	{ silent = true },
})

nmap({
	"N",
	function()
		pcall(vim.cmd, "normal! N")
		require("tt.nvim_utils").hl_search_match(0.15)
	end,
	{ silent = true },
})

nmap({
	"<Esc>",
	function()
		pcall(vim.cmd, "nohlsearch")
	end,
	{ silent = true },
})
nmap({
	"-",
	function()
		require("oil").setup()
		require("oil").open()
	end,
	silent = true,
})
nmap({
	"<leader>a",
	function()
		vim.cmd("argadd %")
		vim.cmd("argdedupe")
	end,
	silent = true,
})
nmap({
	"<leader>1",
	function()
		vim.cmd("silent! 1argument")
	end,
	silent = true,
})
nmap({
	"<leader>2",
	function()
		vim.cmd("silent! 2argument")
	end,
	silent = true,
})
nmap({
	"<leader>3",
	function()
		vim.cmd("silent! 3argument")
	end,
	silent = true,
})
nmap_cmd("cc", "cclose")
nmap_cmd("cl", "lclose")
nmap_cmd("<leader>h", "call tools#switchSourceHeader()")
nmap_cmd("<leader>-", 'let @+ = expand("%")')
nmap_cmd("<F7>", 'so "%"')
nmap_nocr("S", "%s//g<LEFT><LEFT>")
nmap_nocr("g_", "g//#<Left><Left><C-R><C-W><CR>:")
-- nmap_nocr("<leader>.", "Bs<space>")
nmap_nocr("<C-f>", "silent grep!<space>")
-- VISUAL MODE
xnore("<leader>y", '"+y')
xnore("<leader>d", '"+d')
-- Don't trash current register when pasting in visual mode
xnore("p", "p:if v:register == '\"'<Bar>let @@=@0<Bar>endif<cr>")
xmap({ "I", "(mode()=~#'[vV]'?'<C-v>^o^I':'I')", { noremap = true, expr = true } })
xmap({ "A", "(mode()=~#'[vV]'?'<C-v>0o$A':'A')", { noremap = true, expr = true } })
vnore("<up>", ":m '<-2<cr>gv=gv")
vnore("<down>", ":m '>+1<cr>gv=gv")
-- vmap_nocr("s", "s//g<LEFT><LEFT>")
xmap_cmd("<leader>b", "Gblame")
