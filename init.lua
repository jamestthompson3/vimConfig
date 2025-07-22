vim.loader.enable()
-- This needs to be set before plugins so that plugin init codes can read the mapleader key
vim.g.mapleader = " "
require("tt.plugins")
local git = require("tt.git")
local globals = require("tt.nvim_utils").GLOBALS

local setPath = function()
	-- If we aren't using git, then we should still put a root marker in the current dir so that we
	-- can index tags with gutentags, and maybe do other stuff.
	if git.branch() == "" and globals.cwd() ~= globals.home and vim.o.ft ~= "gitcommit" then
		vim.uv.fs_open("root_marker", vim.uv.constants.O_CREAT, 438, function(err)
			if err then
				vim.notify("ERR", err)
			end
		end)
	end
	-- TODO: make the list of dirs we don't index configurable
	if globals.cwd() ~= globals.home then
		return ".,"
			.. table.concat(vim.fn.systemlist("fd . --type d --hidden -E .git -E .yarn"), ","):gsub("%./", "")
			.. ","
			.. table.concat(vim.fn.systemlist("fd --type f --max-depth 1"), ","):gsub("%./", "") -- grab both the dirs and the top level filesystem
	end
end

vim.g.did_install_default_menus = 1
vim.g.remove_whitespace = 1
vim.g.python3_host_prog = globals.python_host
vim.g.autoformat = true
vim.g.loaded_netrwPlugin = 1
vim.g.markdown_fenced_languages = {
	"html",
	"typescript",
	"markdown",
	"javascript",
	"js=javascript",
	"ts=typscript",
	"rust",
	"css",
	"vim",
	"lua",
}

vim.g.gutentags_file_list_command = "fd --type f --hidden -E .git"
vim.g.gutentags_cache_dir = "~/.cache/"
vim.g.gutentags_project_root = { ".git", "root_marker" }
vim.g.gutentags_add_default_project_roots = 1
vim.g.gutentags_generate_on_empty_buffer = 1

local set = vim.o
set.hidden = true
set.exrc = true
set.secure = true
set.title = true
set.lazyredraw = true
set.splitright = true
set.modeline = false
set.wildignorecase = true
set.expandtab = true
set.shiftround = true
set.ignorecase = true
set.smartcase = true
set.undofile = true
set.magic = true
set.relativenumber = true
set.tags = "" -- let gutentags handle this
set.mopt = "hit-enter,history:500"
set.foldenable = false
set.undolevels = 1000
set.ttimeoutlen = 20
set.shiftwidth = 2
set.softtabstop = 2
set.tabstop = 2
set.synmaxcol = 200
set.cmdheight = 2
set.updatetime = 200
-- auto break at 100 chars
-- set.textwidth = 100
set.splitkeep = "topline"
set.conceallevel = 2
set.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly

set.mouse = "nv"
set.foldopen = "search"
set.smartindent = true
set.fileformat = "unix"
set.jumpoptions = "stack"
set.diffopt = "hiddenoff,iwhiteall,algorithm:minimal,internal,closeoff,indent-heuristic,linematch:60,inline:word"
set.nrformats = "bin,hex,alpha"
set.grepprg = "rg --smart-case --vimgrep --block-buffered"
set.virtualedit = "block"
set.inccommand = "split"
set.path = setPath()
function FindFunc(cmdarg)
	local cmd = "fd --color never --full-path --type f " .. cmdarg
	return vim.fn.systemlist(cmd)
end
vim.o.findfunc = "v:lua.FindFunc"

set.completeopt = "menuone,noselect,popup,fuzzy,popup"
set.complete = vim.o.complete .. ",o"
set.completefuzzycollect = "keyword,files,whole_line"
set.listchars = "tab:░░,trail:·,space:·,extends:»,precedes:«,nbsp:⣿"
set.formatlistpat = "^\\s*\\[({]\\?\\([0-9]\\+\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\|^\\s*[-–+o*•]\\s\\+"
set.foldlevelstart = 99
set.foldlevel = 1
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.shortmess = vim.o.shortmess .. "s"
set.undodir = globals.home .. "/.cache/Vim/undofile"
set.laststatus = 2

in_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if in_wsl then
	vim.g.clipboard = {
		name = "wsl clipboard",
		copy = { ["+"] = { "clip.exe" }, ["*"] = { "clip.exe" } },
		paste = { ["+"] = { "nvim_paste" }, ["*"] = { "nvim_paste" } },
		cache_enabled = true,
	}
end

-- UI OPTS
set.termguicolors = true
set.wrap = false
set.cursorline = true
set.fillchars = "stlnc:»,vert:║,fold:·"
set.number = true
set.pumblend = 20
set.pumheight = 15
set.scrolloff = 1
set.sidescrolloff = 5
set.guicursor = "n-ci-c-o:blinkon175-blinkoff175-Cursor/lCursor,i-ci:ver25-Cursor,v-ve:blinkon175-blinkoff175-IncSearch"
vim.cmd("colorscheme quiet-modified")
require("tt.ui").darkMode()
require("tt.core_opts")
require("tt.lsp")
require("tt.mappings")
require("tt.autocmds")
require("tt.snippets")
require("tt.filetypes")
vim.opt.statusline =
	"%f %#Search#%{&mod?'[+]':''}%* %{luaeval('require\"tt.nvim_utils\".vim_util.get_diagnostics()')} %=%r%=%{luaeval('require\"tt.nvim_utils\".vim_util.get_lsp_clients()')}"
local schedule = vim.schedule
schedule(function()
	require("tt.tools").splashscreen()
end)
