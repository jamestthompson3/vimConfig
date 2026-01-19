vim.loader.enable()
-- This needs to be set before plugins so that plugin init codes can read the mapleader key
vim.g.mapleader = " "
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site/pack/*")
require("tt.plugins")
local globals = require("tt.nvim_utils").GLOBALS

vim.g.did_install_default_menus = 1
vim.g.python3_host_prog = globals.python_host
vim.g.markdown_fenced_languages = {
	"html",
	"typescript",
	"markdown",
	"javascript",
	"js=javascript",
	"ts=typescript",
	"rust",
	"css",
	"vim",
	"lua",
}

vim.g.gutentags_file_list_command = "fd --type f --hidden -E .git"
vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/")
vim.g.gutentags_project_root = { ".git" }
vim.g.gutentags_add_default_project_roots = 0
vim.g.gutentags_generate_on_empty_buffer = 1
vim.g.gutentags_ctags_exclude_wildignore = 1

local set = vim.o
set.exrc = true
set.secure = true
set.title = true
set.splitright = true
set.modeline = false
set.wildignorecase = true
set.wildignore =
	"*/node_modules/*,*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf,*.exe,*.o,*.obj,*.dll,*.DS_Store,*.ttf,*.otf,*.woff,*.woff2,*.eot"
set.expandtab = true
set.shiftround = true
set.ignorecase = true
set.smartcase = true
set.undofile = true
set.relativenumber = true
set.tags = "" -- let gutentags handle this
set.foldenable = false
set.undolevels = 1000
set.ttimeoutlen = 20
set.shiftwidth = 2
set.softtabstop = 2
set.tabstop = 2
set.synmaxcol = 200
set.cmdheight = 2
set.splitkeep = "topline"
set.conceallevel = 2
set.showbreak = string.rep(".", 3) -- Make it so that long lines wrap smartly

set.smartindent = true
set.fileformat = "unix"
set.jumpoptions = "stack,view"
set.diffopt = "hiddenoff,iwhiteall,algorithm:minimal,internal,closeoff,indent-heuristic,linematch:60,inline:word"
set.nrformats = "bin,hex,alpha"
set.grepprg = "rg --smart-case --vimgrep --block-buffered"
set.virtualedit = "block"
set.inccommand = "split"
set.completeopt = "menuone,noselect,popup,fuzzy,nearest"
set.autocomplete = true
set.complete = ".,w,b,u,o,F"
set.listchars = "tab:░░,trail:·,space:·,extends:»,precedes:«,nbsp:⣿"
set.formatlistpat = "^\\s*\\[({]\\?\\([0-9]\\+\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\|^\\s*[-–+o*•]\\s\\+"
set.foldlevelstart = 99
set.foldlevel = 1
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.shortmess = vim.o.shortmess .. "s"
set.undodir = globals.home .. "/.cache/Vim/undofile"

local in_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if in_wsl then
	vim.g.clipboard = {
		name = "wsl clipboard",
		copy = { ["+"] = { "clip.exe" }, ["*"] = { "clip.exe" } },
		paste = { ["+"] = { "nvim_paste" }, ["*"] = { "nvim_paste" } },
		cache_enabled = true,
	}
end

-- UI OPTS
set.wrap = false
set.cursorline = true
set.fillchars = "stlnc:»,vert:║,fold:·"
set.number = true
set.pumblend = 5
set.pumheight = 15
set.scrolloff = 1
set.sidescrolloff = 5
set.guicursor = "n-ci-c-o:blinkon175-blinkoff175-Cursor/lCursor,i-ci:ver25-Cursor,v-ve:blinkon175-blinkoff175-Cursor"
vim.cmd("colorscheme quiet-modified")
require("tt.core_opts")
require("tt.lsp")
require("tt.mappings")
require("tt.autocmds")
require("tt.snippets")
require("tt.filetypes")
require("tt.format")
vim.opt.statusline =
	"%f %#Search#%{&mod?'[+]':''}%* %{%luaeval('vim.diagnostic.status()')%} %{&busy>0?'◐':''} %=%r%=%{luaeval('require\"tt.nvim_utils\".vim_util.get_lsp_clients()')}"
local schedule = vim.schedule
schedule(function()
	require("tt.tools").splashscreen()
end)
