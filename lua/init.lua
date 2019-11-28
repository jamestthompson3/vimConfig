-- require 'nvim_utils'

local nvim_options = setmetatable({}, {
	__index = function(_, k)
		return vim.api.nvim_get_option(k)
	end;
	__newindex = function(_, k, v)
		return vim.api.nvim_set_option(k, v)
	end
});

local M = {}

function M.core_options()
	local options = {
		hidden          = true;
		secure          = true;
		title           = true;
		lazyredraw      = true;
		splitright      = true;
		modeline        = false;
		ttimeout        = true;
		wildignorecase  = true;
		expandtab       = true;
		shiftround      = true;
		ignorecase      = true;
		smartcase       = true;
		undofile        = true;
		backup          = true;
		magic           = true;

		undolevels      = 1000;
		ttimeoutlen     = 20;
		shiftwidth      = 2;
		softtabstop     = 2;
		tabstop         = 2;
		synmaxcol       = 200;
		cmdheight       = 2;
		updatetime      = 200;
		conceallevel    = 2;
		cscopetagorder  = 0;
		cscopepathcomp  = 3;

		mouse           = "nv";
		wildmode        = "list:longest,full";
		grepprg         = "rg --smart-case --vimgrep";
		virtualedit     = "block";
		inccommand      = "split";
		wildoptions     = "pum";
	}
	for k, v in pairs(options) do nvim_options[k] = v end
end

return M
