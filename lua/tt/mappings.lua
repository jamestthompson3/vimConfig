local nnore = require("tt.nvim_utils").keys.nnore
local inore = require("tt.nvim_utils").keys.inore
local tnore = require("tt.nvim_utils").keys.tnore
local nmap = require("tt.nvim_utils").keys.nmap
local nmap_cmd = require("tt.nvim_utils").keys.nmap_cmd
local nmap_nocr = require("tt.nvim_utils").keys.nmap_nocr
local nmap_call = require("tt.nvim_utils").keys.nmap_call
local xmap = require("tt.nvim_utils").keys.xmap
local xmap_cmd = require("tt.nvim_utils").keys.xmap_cmd
local xnore = require("tt.nvim_utils").keys.xnore
local vnore = require("tt.nvim_utils").keys.vnore
local cmap = require("tt.nvim_utils").keys.cmap

local tools = require("tt.tools")
local git = require("tt.git")

-- INSERT MODE
inore("jj", "<Esc>")
-- TERMINAL MODE
tnore("<Esc>", "<C-\\><C-n>")
-- NORMAL MODE
nnore("<up>", ":m .-2<cr>==", { silent = true, expr = true })
nnore("<down>", ":m .+1<cr>==", { silent = true, expr = true })
nnore("'", "`")
nnore("Y", "y$")
nnore("/", "ms/")
nnore("<leader>p", '"+p')
nnore("<leader>P", '"+P')
nnore("<C-]>", "g<C-]>")
nnore("<C-\\>", "<C-\\><C-n>")
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
		tools.openTerminalDrawer(0)
	end,
})
nmap({
	"<leader>D",
	function()
		tools.openTerminalDrawer(1)
	end,
})
nmap({ "<leader>lt", tools.listTags })
nmap_call("n", "n:call HLNext(0.15)", { silent = true })
nmap_call("<Esc>", ":nohlsearch", { silent = true })
nmap_call("N", "N:call HLNext(0.15)", { silent = true })
nmap_cmd("cc", "cclose")
nmap_cmd("cl", "lclose")
nmap_cmd("gl", "pc")
nmap_cmd("<leader><tab>", "bn")
nmap_cmd("<leader>h", "call tools#switchSourceHeader()")
nmap_cmd("<leader>-", 'echo expand("%")')
nmap_cmd("mks", "mks! ~/sessions/")
nmap_cmd("ss", "so ~/sessions/")
nmap_cmd("M", "silent make")
nmap_cmd("gh", "call symbols#ShowDeclaration(0)")
nmap_cmd("<F7>", 'so "%"')
nmap_cmd("<leader>w", "MatchupWhereAmI")
nmap_cmd("<leader>G", "SearchBuffers")
nmap_cmd("-", "Oil")
nmap_nocr("S", "%s//g<LEFT><LEFT>")
nmap_nocr(",", "find<space>")
nmap_nocr("sb", "g//#<Left><Left>")
nmap_nocr("g_", "g//#<Left><Left><C-R><C-W><CR>:")
nmap_nocr("<leader>.", "Bs<space>")
nmap_nocr("<C-f>", "silent grep!<space>")
nmap_cmd("ts", "FzfLua lsp_workspace_symbols")
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
-- COMMAND MODE
cmap({ "<CR>", "tools#CCR()", { noremap = true, expr = true } })
