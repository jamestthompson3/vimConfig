local gl = require("galaxyline")
local gls = gl.section
local fileinfo = require("galaxyline.provider_fileinfo")
local iconz = require("nvim-nonicons")

gl.short_line_list = { "packer" }

local icons = {
	sep = {
		right = "",
		left = "",
	},
	diagnostic = {
		-- error = " ",
		error = iconz.get("x-circle-fill"),
		-- warn = " ",
		warn = iconz.get("alert"),
		-- info = " "
		info = iconz.get("info"),
	},
	diff = {
		added = iconz.get("diff-added"),
		modified = iconz.get("diff-modified"),
		removed = iconz.get("diff-removed"),
		-- add = " ",
		-- modified = " ",
		-- remove = " "
	},
	git = iconz.get("git-branch"),
	line_nr = iconz.get("list-ordered"),
	file = {
		read_only = "",
		-- modified = '⨁ ',
		-- modified = '✎',
		modified = iconz.get("pencil"),
	},
	normal = iconz.get("vim-normal-mode"),
	insert = iconz.get("vim-insert-mode"),
	command = iconz.get("vim-command-mode"),
	visual = iconz.get("vim-visual-mode"),
	replace = iconz.get("vim-replace-mode"),
	selection = iconz.get("vim-select-mode"),
	terminal = iconz.get("terminal"),
	visual_block = iconz.get("field"),
	-- terminal  = iconz.get("vim-terminal-mode")
}

local colors = {
	main = "#ff87ff",
	main_bg = "#121217",
	grey = "#3c4048",
	lightblue = "#81a1c1",
	blue = "#61afef",
	green = "#7ed491",
	yellow = "#cccc00",
	creamyorange = "#ff8800",
	orange = "#FF8800",
	bg = "#000B0C15",
	fg = "#D8DEE9",
	magenta = "#c678dd",
	red = "#df8890",
	crimsonRed = "#990000",
	crimsonRed2 = "#ff4d4d",
	greenYel = "#EBCB8B",
	white = "#d8dee9",
	brown = "#91684a",
	blue2 = "#093B61",
	icon_inactive = "#9896AA",
}

local mode_map = {
	-- n      = {" NORMAL  ", colors.red},
	-- i      = {" INSERT  ", colors.green},
	-- c      = {" COMMAND ", colors.orange},
	-- v      = {" VISUAL  ", colors.lightblue},
	n = { icons.normal .. "  NORMAL  ", colors.red },
	no = { icons.normal .. "  NORMAL  ", colors.red },
	i = { icons.insert .. "  INSERT  ", colors.green },
	ic = { icons.insert .. "  INSERT  ", colors.green },
	c = { icons.command .. "  COMMAND ", colors.orange },
	ce = { icons.command .. "  COMMAND ", colors.orange },
	cv = { icons.command .. "  COMMAND ", colors.orange },
	v = { icons.visual .. "  VISUAL  ", colors.lightblue },
	V = { icons.visual .. "  VISUAL  ", colors.lightblue },
	[""] = { icons.visual .. "  VISUAL" .. icons.visual_block .. " ", colors.brown },
	R = { icons.replace .. "  REPLACE ", colors.crimsonRed2 },
	["r?"] = { icons.replace .. "  REPLACE ", colors.lightblue },
	Rv = { icons.replace .. "  REPLACE ", colors.crimsonRed2 },
	r = { icons.replace .. "  REPLACE ", colors.blue2 },
	rm = { icons.replace .. "  REPLACE ", colors.blue2 },
	s = { icons.selection .. "  SELECT  ", colors.greenYelenYel },
	S = { icons.selection .. "  SELECT  ", colors.greenYelenYel },
	[""] = { icons.selection .. "  SELECT  ", colors.greenYelenYel },
	t = { icons.terminal .. "  TERMINAL ", colors.magenta },
	["!"] = { "  !        ", colors.crimsonRed },
}

----------------------------=== Funcs ===--------------------------

local function mode_label()
	return mode_map[vim.fn.mode()][1] or "N/A"
end
local function mode_hl()
	return mode_map[vim.fn.mode()][2] or colors.main
end

local function highlight1(group, fg, gui)
	local cmd = string.format("highlight %s guifg=%s", group, fg)
	if gui ~= nil then
		cmd = cmd .. " gui=" .. gui
	end
	vim.cmd(cmd)
end

local function highlight2(group, bg, fg, gui)
	local cmd = string.format("highlight %s guibg=%s guifg=%s", group, bg, fg)
	if gui ~= nil then
		cmd = cmd .. " gui=" .. gui
	end
	vim.cmd(cmd)
end

local checkwidth = function()
	local squeeze_width = vim.fn.winwidth(0) / 2
	if squeeze_width > 40 then
		return true
	end
	return false
end

local function file_name(is_active, highlight_group)
	local normal_fg = is_active and fileinfo.get_file_icon_color() or colors.blue
	local modified_fg = is_active and "#ff0000" or "#cc8800"
	if vim.bo.modifiable then
		if vim.bo.modified then
			vim.api.nvim_command("hi " .. highlight_group .. " guifg=" .. modified_fg .. " gui=bold")
		else
			vim.api.nvim_command("hi " .. highlight_group .. " guifg=" .. normal_fg .. " gui=NONE")
		end
	end
	local fname = fileinfo.get_current_file_name(icons.file.modified, icons.file.read_only)
	if (require("galaxyline.condition").check_git_workspace()) and checkwidth() then
		local git_dir = require("galaxyline.provider_vcs").get_git_dir(vim.fn.expand("%:p"))
		local current_dir = vim.fn.expand("%:p:h")
		if git_dir == current_dir .. "/.git" or git_dir == nil then
			return fname
		end
		local get_path_from_git_root = current_dir:sub(#git_dir - 3)
		return get_path_from_git_root .. "/" .. fname
	end
	return fname
end

local white_space = function()
	return " "
end

local function trailing_whitespace()
	local trail = vim.fn.search("\\s$", "nw")
	if trail ~= 0 then
		return " "
	else
		return nil
	end
end

local TrailingWhiteSpace = trailing_whitespace

local check_git_width = function()
	return checkwidth() and require("galaxyline.condition").check_git_workspace()
end

local check_git_terminal_workspace = function()
	return not (vim.fn.mode() == "t") and require("galaxyline.condition").check_git_workspace()
end

----------------------------=== Components ===--------------------------

----------------------------=== Left ===--------------------------

local i = 1
gls.left[i] = {
	ViMode = {
		provider = function()
			highlight2("GalaxyViMode", colors.main_bg, mode_hl(), "bold")
			highlight1("GalaxyViModeInv", mode_hl(), "bold")
			return string.format(" %s", mode_label())
		end,
	},
}

i = i + 1
gls.left[i] = {
	FileIcon = {
		provider = "FileIcon",
		separator = " ",
		separator_highlight = { colors.main_bg, colors.main_bg },
		highlight = { fileinfo.get_file_icon_color, colors.main_bg },
	},
}

i = i + 1
gls.left[i] = {
	FileName = {
		provider = function()
			return file_name(true, "GalaxyFileName")
		end,
		condition = require("galaxyline.condition").buffer_not_empty,
		highlight = { fileinfo.get_file_icon_color, colors.main_bg },
	},
}

i = i + 1
gls.left[i] = {
	Space = {
		provider = white_space,
		highlight = { colors.bg, colors.main_bg },
	},
}
i = i + 1
gls.left[i] = {
	DiagnosticError = {
		provider = "DiagnosticError",
		-- icon = "   ",
		icon = "  " .. icons.diagnostic.error .. "  ",
		highlight = { colors.red, colors.main_bg },
	},
}

i = i + 1
gls.left[i] = {
	Space = {
		provider = white_space,
		highlight = { colors.bg, colors.main_bg },
		condition = function()
			return require("galaxyline.provider_diagnostic").get_diagnostic_error() ~= ""
		end,
	},
}

i = i + 1
gls.left[i] = {
	DiagnosticWarn = {
		provider = "DiagnosticWarn",
		-- icon = "   ",
		icon = "  " .. icons.diagnostic.warn .. "  ",
		highlight = { colors.yellow, colors.main_bg },
	},
}

i = i + 1
gls.left[i] = {
	Space = {
		provider = white_space,
		highlight = { colors.bg, colors.main_bg },
		condition = function()
			return require("galaxyline.provider_diagnostic").get_diagnostic_warn() ~= ""
		end,
	},
}

i = i + 1
gls.left[i] = {
	DiagnosticInfo = {
		provider = "DiagnosticInfo",
		-- icon = "   ",
		icon = "  " .. icons.diagnostic.info .. "  ",
		highlight = { colors.blue, colors.main_bg },
	},
}

i = i + 1
gls.left[i] = {
	Space = {
		provider = white_space,
		highlight = { colors.bg, colors.main_bg },
		condition = function()
			return require("galaxyline.provider_diagnostic").get_diagnostic_info() ~= ""
		end,
	},
}

i = i + 1
gls.left[i] = {
	DiagnosticHint = {
		provider = "DiagnosticHint",
		icon = "    ",
		highlight = { colors.blue, colors.main_bg },
	},
}

----------------------------=== Right ===--------------------------
i = 1
gls.right[i] = {
	DiffAdd = {
		provider = "DiffAdd",
		condition = check_git_width,
		-- icon = "   ",
		icon = "  " .. icons.diff.added .. " ",
		highlight = { colors.greenYel, colors.main_bg },
	},
}

i = i + 1
gls.right[i] = {
	DiffModified = {
		provider = "DiffModified",
		condition = check_git_width,
		-- icon = "  柳",
		icon = "  " .. icons.diff.modified .. " ",
		highlight = { colors.creamyorange, colors.main_bg },
	},
}
i = i + 1
gls.right[i] = {
	DiffRemove = {
		provider = "DiffRemove",
		condition = check_git_width,
		-- icon = "   ",
		icon = "  " .. icons.diff.removed .. " ",
		highlight = { colors.red, colors.main_bg },
	},
}

i = i + 1
gls.right[i] = {
	ShowLspClient = {
		provider = "GetLspClient",
		condition = function()
			local tbl = { ["dashboard"] = true, [""] = true }

			if tbl[vim.bo.filetype] then
				return false
			end
			return true
		end,
		icon = " ",
		highlight = { colors.white, colors.main_bg },
	},
}

i = i + 1
gls.right[i] = {
	right_LeftRounded1 = {
		separator = " ",
		separator_highlight = { colors.main_bg, colors.main_bg },
		provider = function()
			return ""
		end,
		condition = require("galaxyline.condition").check_git_workspace,
		highlight = { colors.blue2, colors.main_bg },
	},
}

i = i + 1
gls.right[i] = {
	GitIcon = {
		provider = function()
			return icons.git .. " "
		end,
		condition = check_git_terminal_workspace,
		highlight = { colors.white, colors.blue2 },
	},
}

i = i + 1
gls.right[i] = {
	GitBranch = {
		provider = "GitBranch",
		condition = require("galaxyline.condition").check_git_workspace,
		highlight = { colors.white, colors.blue2 },
	},
}

i = i + 1
gls.right[i] = {
	Space2 = {
		provider = white_space,
		condition = require("galaxyline.condition").check_git_workspace,
		highlight = { colors.blue2, colors.blue2 },
	},
}

-- -------------------------Short status line---------------------------------------

local k = 1
gls.short_line_left[k] = {
	SFirstElement = {
		provider = function()
			return icons.sep.right
		end,
		highlight = { colors.grey, "NONE" },
	},
}

k = k + 1
gls.short_line_left[k] = {
	SFileIcon = {
		provider = "FileIcon",
		highlight = { colors.icon_inactive, colors.grey },
	},
}

k = k + 1
gls.short_line_left[k] = {
	SMyFileName = {
		provider = function()
			return file_name(false, "GalaxySMyFileName")
		end,
		highlight = { colors.red, colors.grey },
		separator = icons.sep.left,
		separator_highlight = { colors.grey, colors.main_bg },
	},
}
