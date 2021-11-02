require("impatient")

-- no need to continue if we don't have any plugins loaded, as the config here will throw errors.
if require("tt.bootstrap")() then
	return
end

require("packer_compiled")

require("tt.nvim_utils")
local set = vim.o
local api = vim.api
local fn = vim.fn
local home = os.getenv("HOME")

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
set.number = true
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
set.textwidth = 100
set.conceallevel = 2
set.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly

set.mouse = "nv"
set.foldopen = "search"
set.fileformat = "unix"
set.jumpoptions = "stack"
set.diffopt = "hiddenoff,iwhiteall,algorithm:patience"
set.nrformats = "bin,hex,alpha"
set.grepprg = "rg --smart-case --vimgrep --block-buffered"
set.virtualedit = "block"
set.inccommand = "split"
set.cscopequickfix = "s-,c-,d-,i-,t-,e-"
-- TODO set per project.
set.path = "src/**,libs/**,.config/"
set.completeopt = "menuone,noselect"
set.listchars = "tab:░░,trail:·,space:·,extends:»,precedes:«,nbsp:⣿"
set.formatlistpat = "^\\s*\\[({]\\?\\([0-9]\\+\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\|^\\s*[-–+o*•]\\s\\+"
set.foldlevelstart = 99
set.foldmethod = "syntax"
set.wildignore =
	"*/dist*/*,*/target/*,*/builds/*,*/node_modules/*,*/flow-typed/*,*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf,*.exe,*.o,*.obj,*.dll,*.DS_Store,*.ttf,*.otf,*.woff,*.woff2,*.eot"
set.shortmess = vim.o.shortmess .. "s"
set.undodir = home .. "/.cache/Vim/undofile"

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
set.guicursor = "n:blinkwait60-blinkon175-blinkoff175,i-ci-ve:ver25"

do
	require("tt.globals") -- gutentags can't read cache dir off main loop
	local schedule = vim.schedule
	nvim.command([[colorscheme substrata]])
	schedule(function()
		require("tt.plugins")
		require("tt.core_opts")
		require("tt.autocmds")
		require("tt.mappings").map()
		require("tt.tools").splashscreen()
	end)
end
