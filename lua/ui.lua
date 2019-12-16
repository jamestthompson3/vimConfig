require 'nvim_utils'
local function highlight(group, guifg, guibg, attr, ctermfg, ctermbg, guisp)
	local parts = {group}
	if guifg then table.insert(parts, "guifg="..guifg) end
	if guibg then table.insert(parts, "guibg="..guibg) end
	if ctermfg then table.insert(parts, "ctermfg="..ctermfg) end
	if ctermbg then table.insert(parts, "ctermbg="..ctermbg) end
	if attr then
		table.insert(parts, "gui="..attr)
		table.insert(parts, "cterm="..attr)
	end
	if guisp then table.insert(parts, "guisp=#"..guisp) end
	-- nvim_print(parts)
	-- nvim.ex.highlight(parts)
	vim.api.nvim_command('highlight '..table.concat(parts, ' '))
end

nvim.command [[hi clear]]
nvim.command [[syntax reset]]

highlight("Comment",          "#f5ac46",  "NONE",     "italic",      "215",  "NONE", "NONE")
highlight("VertSplit",        "#5e5959",  "NONE",     "NONE",        "240",  "NONE", "NONE")
highlight("CursorLineNR",     "#9c9695",  "#222020",  "NONE",        "247",  "236",  "NONE")
highlight("CursorLine",       "NONE",     "#222020",  "NONE",        "NONE", "236",  "NONE")
highlight("LineNR",           "#5e5959",  "NONE",     "NONE",        "238",  "NONE", "NONE")
highlight("Search",           "#16161d",  "#ff9966",  "italic",      "0",    "172",  "NONE")
highlight("MatchParen",       "#66ccff",  "#16161d",  "bold",        "81",   "NONE", "NONE")
highlight("NormalFloat",      "#66ccff",  "#16161d",  "NONE",        "81",   "NONE", "NONE")
highlight("Normal",           "#d2cfcf",  "#16161d",  "NONE",        "255",  "NONE", "NONE")
highlight("TabLineFill",      "#d2cfcf",  "#000000",  "NONE",        "255",  "NONE", "NONE")
highlight("StatusLineNC",     "#5e5959",  "NONE",     "underline",   "238",  "NONE", "NONE")
highlight("StatusLine",       "#d2cfcf",  "#16161d",  "NONE",        "255",  "0",    "NONE")
highlight("TabLine",          "#d2cfcf",  "#000000",  "NONE",        "255",  "0",    "NONE")
highlight("Visual",           "#16161d",  "#d2cfcf",  "NONE",        "NONE", "NONE", "NONE")
highlight("Todo",             "White",    "Magenta",  "bold",        "15",   "201",  "NONE")
highlight("Pmenu",            "#9c9695",  "#171616",  "NONE",        "249",  "232",  "NONE")
highlight("PmenuSel",         "#393636",  "#787271",  "NONE",        "237",  "250",  "NONE")
highlight("PmenuThumb",       "NONE",     "#393636",  "NONE",        "NONE", "NONE", "NONE")
highlight("NormalNC",         "#5e5959",  "NONE",     "NONE",        "240",  "NONE", "NONE")
highlight("NonText",          "#353535",  "NONE",     "NONE",        "237",  "NONE", "NONE")
highlight("Whitespace",       "#353535",  "NONE",     "NONE",        "237",  "NONE", "NONE")
highlight("WildMenu",         "#16161d",  "#d2cfcf",  "NONE",        "NONE", "NONE", "NONE")
highlight("SpellBad",         "Red",      "NONE",     "NONE",        "9",    "NONE", "NONE")
highlight("SpellRare",        "#198cff",  "NONE",     "NONE",        "12",   "NONE", "NONE")

highlight("Function",         "NONE",     "NONE",     "italic",     "NONE",  "NONE",  "NONE")
highlight("Identifier",       "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("Include",          "NONE",     "NONE",     "italic",     "NONE",  "NONE",  "NONE")
highlight("Keyword",          "NONE",     "NONE",     "bold",       "NONE",  "NONE",  "NONE")
highlight("PreProc",          "NONE",     "NONE",     "bold",       "NONE",  "NONE",  "NONE")
highlight("Question",         "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("Number",           "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("String",           "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("Constant",         "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("SignColumn",       "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("FoldColumn",       "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("Statement",        "NONE",     "NONE",     "NONE",       "NONE",  "NONE",  "NONE")
highlight("Type",             "NONE",     "NONE",     "bold",       "NONE",  "NONE",  "NONE")
highlight("Directory",        "NONE",     "NONE",     "bold",       "NONE",  "NONE",  "NONE")
highlight("Underlined",       "NONE",     "NONE",     "underline",  "NONE",  "NONE",  "NONE")
highlight("Title",            "NONE",     "NONE",     "bold",       "NONE",  "NONE",  "NONE")
highlight("Special",          "NONE",     "NONE",     "italic",     "NONE",  "NONE",  "NONE")
highlight("ConstStrings",     "#198cff",  "NONE",     "bold",       "NONE",  "NONE",  "NONE")
highlight("ReturnStatement",  "#198cff",  "NONE",     "NONE",       "NONE",  "NONE",  "NONE")


highlight("IncSearch",        "#d81a4c", "NONE",      "NONE",       "161",  "NONE", "NONE")
highlight("QuickFixLine",     "#353535",  "NONE",     "NONE",       "249",  "239",  "NONE")
highlight("QFNormal",         "#222222",  "NONE",     "NONE",       "NONE", "235",  "NONE")
highlight("QFEndOfBuffer",    "#222222",  "NONE",     "NONE",       "NONE", "235",  "NONE")
highlight("Callout",          "#198cff",  "NONE",     "NONE",       "12",   "NONE", "NONE")

highlight("DiffAdd",          "#88aa77", "NONE",  "NONE",           "107", "NONE",  "NONE")
highlight("DiffDelete",       "#aa7766", "NONE",  "NONE",           "137", "NONE",  "NONE")
highlight("DiffChange",       "#7788aa", "NONE",  "NONE",           "67",  "NONE",  "NONE")
highlight("DiffText",         "#7788aa", "NONE",  "underline",      "67",  "NONE",  "NONE")

highlight("ALEError",         "#ff4444", "NONE", "undercurl", "203", "NONE", "NONE")
highlight("ALEWarning",       "#dd9922", "NONE", "undercurl", "214", "NONE", "NONE")
highlight("LspDiagnosticsError",        "#ff4444", "NONE", "NONE",  "203", "NONE",  "NONE")
highlight("LspDiagnosticsWarning",      "#dd9922", "NONE", "NONE",  "214", "NONE",  "NONE")
highlight("LspDiagnosticsInformation",  "#0000ff", "NONE", "NONE",  "12",  "NONE",  "NONE")
highlight("LspDiagnosticsHint",         "#00afaf", "NONE", "NONE",  "37",  "NONE",  "NONE")
highlight("ALEErrorSign",               "#ff4444", "NONE", "NONE",  "203", "NONE",  "NONE")
highlight("ALEWarningSign",             "#dd9922", "NONE", "NONE",  "214", "NONE",  "NONE")
highlight("ALEVirtualTextError",        "#ff4444", "NONE", "NONE",  "203", "NONE",  "NONE")

nvim.command [[hi! link ALEVirtualTextInfo  Comment]]
nvim.command [[hi! link StatusLineModified Todo]]
nvim.command [[hi! link Folded DiffChange]]
