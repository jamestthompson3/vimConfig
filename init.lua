pcall(require, "impatient")

-- Don't need these, don't load these
vim.g.loaded_matchparen = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_python_provider = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tutor_mode_plugin = 1

local globals = require("tt.nvim_utils").GLOBALS
local vim_utils = require("tt.nvim_utils").vim_util
local git = require("tt.git")
local setPath = function()
	-- If we aren't using git, then we should still put a root marker in the current dir so that we
	-- can index tags with gutentags, and maybe do other stuff.
	if git.branch() == "" and globals.cwd() ~= globals.home and vim.o.ft ~= "gitcommit" then
		vim.loop.fs_open("root_marker", vim.loop.constants.O_CREAT, 438, function(err, fd)
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
local set = vim.o
local api = vim.api
local fn = vim.fn

vim.g.mapleader = " "

set.hidden = true
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
set.fileformat = "unix"
set.jumpoptions = "stack"
set.diffopt = "hiddenoff,iwhiteall,algorithm:patience,internal,closeoff,indent-heuristic,linematch:60"
set.nrformats = "bin,hex,alpha"
set.grepprg = "rg --smart-case --vimgrep --block-buffered"
set.virtualedit = "block"
set.inccommand = "split"
set.path = setPath()
set.completeopt = "menuone,noselect"
set.listchars = "tab:░░,trail:·,space:·,extends:»,precedes:«,nbsp:⣿"
set.formatlistpat = "^\\s*\\[({]\\?\\([0-9]\\+\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\|^\\s*[-–+o*•]\\s\\+"
set.foldlevelstart = 99
set.foldlevel = 1
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.shortmess = vim.o.shortmess .. "s"
set.undodir = globals.home .. "/.cache/Vim/undofile"

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

do
	require("tt.globals") -- gutentags can't read cache dir off main loop
	local schedule = vim.schedule
  local timeOfDay = tonumber(vim.fn.strftime("%H"))
	if  timeOfDay > 20 or timeOfDay < 7 then
		api.nvim_command([[colorscheme lunaperche]])
	else
    -- FIXME: Cursor color is somehow b0rked for all colorschemes
		-- api.nvim_command([[colorscheme tropics-light]])
		api.nvim_command([[colorscheme lunaperche]])
	end
	schedule(function()
		require("tt.core_opts")
		require("tt.mappings")
		require("tt.autocmds")
		require("tt.plugins")
		require("tt.tools").splashscreen()
	end)
end
