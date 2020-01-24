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
nvim.command [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]

local highlighMd = "#f5ac46"
local nontext = "#FFCE5B"
local match = "#2de2e6"
local unfinished = "#FB7DA7"
local search = "#1fff5c"
local neutralAdd = "#88aa77"
local neutralDelete = "#aa7766"
local neutralDiff = "#7788aa"
local neutralBlock = "#648c9c"
local attention = "#198cff"
local title = "Magenta"
local background = "#2F343F"
local normal = "#d2cfcf"
local mdDark = "#818e8e"

highlight("Comment",          highlighMd, "NONE",     "italic",      "215",  "NONE", "NONE")
highlight("VertSplit",        mdDark,     "NONE",     "NONE",        "240",  "NONE", "NONE")
highlight("CursorLineNR",     "NONE",    "NONE",     "NONE",        "247",  "236",  "NONE")
highlight("CursorLine",       "NONE",     background,  "NONE",        "NONE", "236",  "NONE")
highlight("LineNR",           mdDark,     "NONE",     "NONE",        "238",  "NONE", "NONE")
highlight("Search",           "#16161d",  search,     "italic",      "0",    "172",  "NONE")
highlight("MatchParen",       match,      "#16161d",  "bold",        "81",   "NONE", "NONE")
highlight("MatchWord",        match,      "#16161d",  "bold",        "81",   "NONE", "NONE")
highlight("NormalFloat",      normal,      "#16161d",  "NONE",        "81",   "NONE", "NONE")
highlight("Normal",           normal,     "#16161d",  "NONE",        "255",  "NONE", "NONE")
highlight("TabLineFill",      normal,     "#000000",  "NONE",        "255",  "NONE", "NONE")
highlight("StatusLineNC",     mdDark,     "NONE",     "underline",   "238",  "NONE", "NONE")
highlight("StatusLine",       normal,     "#16161d",  "NONE",        "255",  "0",    "NONE")
highlight("TabLine",          normal,     "#000000",  "NONE",        "255",  "0",    "NONE")
highlight("Visual",           highlighMd, "#787271",  "NONE",        "NONE", "NONE", "NONE")
highlight("Todo",             "White",     unfinished,"bold",        "15",   "201",  "NONE")
highlight("Pmenu",            "#9c9695",  "#171616",  "NONE",        "249",  "232",  "NONE")
highlight("PmenuSel",         "#393636",  "#787271",  "NONE",        "237",  "250",  "NONE")
highlight("PmenuThumb",       "NONE",     "#393636",  "NONE",        "NONE", "NONE", "NONE")
highlight("NormalNC",         mdDark,     "NONE",     "NONE",        "240",  "NONE", "NONE")
highlight("NonText",          nontext,    "NONE",     "NONE",        "237",  "NONE", "NONE")
highlight("Whitespace",       background, "NONE",     "NONE",        "237",  "NONE", "NONE")
highlight("WildMenu",         "#16161d",  normal,     "NONE",        "NONE", "NONE", "NONE")
highlight("SpellBad",         "Red",      "NONE",     "NONE",        "9",    "NONE", "NONE")
highlight("SpellRare",        attention,  "NONE",     "NONE",        "12",   "NONE", "NONE")

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
highlight("Title",            title,      "NONE",     "bold",       "15",    "NONE",  "NONE")
highlight("Special",          "NONE",     "NONE",     "italic",     "NONE",  "NONE",  "NONE")
highlight("ConstStrings",     attention,  "NONE",     "bold",       "NONE",  "NONE",  "NONE")
highlight("ReturnStatement",  attention,  "NONE",     "NONE",       "NONE",  "NONE",  "NONE")


highlight("IncSearch",        search,     "NONE",     "NONE",       "161",  "NONE", "NONE")
highlight("QuickFixLine",     "#bc6b01",  "NONE",     "NONE",       "249",  "239",  "NONE")
highlight("QFNormal",         "#222222",  "NONE",     "NONE",       "NONE", "235",  "NONE")
highlight("QFEndOfBuffer",    "#222222",  "NONE",     "NONE",       "NONE", "235",  "NONE")

highlight("DiffAdd",          neutralAdd,    "NONE",  "NONE",           "107", "NONE",  "NONE")
highlight("DiffDelete",       neutralDelete, "NONE",  "NONE",           "137", "NONE",  "NONE")
highlight("DiffChange",       neutralDiff,   "NONE",  "NONE",           "67",  "NONE",  "NONE")
highlight("DiffText",         neutralDiff,   "NONE",  "underline",      "67",  "NONE",  "NONE")

-- Custom groups
highlight("CodeBlock",        neutralAdd,   "NONE",     "NONE",       "12",   "NONE", "NONE")
highlight("BlockQuote",       neutralBlock, "NONE",     "NONE",       "12",   "NONE", "NONE")
highlight("Callout",          attention,    "NONE",     "NONE",       "12",   "NONE", "NONE")
highlight("ALEError",         "#ff4444", "NONE", "undercurl", "203", "NONE", "NONE")
highlight("ALEWarning",       highlighMd, "NONE", "undercurl", "214", "NONE", "NONE")
highlight("LspDiagnosticsError",        "#ff4444", "NONE", "NONE",  "203", "NONE",  "NONE")
highlight("LspDiagnosticsWarning",      highlighMd, "NONE", "NONE",  "214", "NONE",  "NONE")
highlight("LspDiagnosticsInformation",  "#0000ff", "NONE", "NONE",  "12",  "NONE",  "NONE")
highlight("LspDiagnosticsHint",         "#00afaf", "NONE", "NONE",  "37",  "NONE",  "NONE")
highlight("ALEErrorSign",               "#ff4444", "NONE", "NONE",  "203", "NONE",  "NONE")
highlight("ALEWarningSign",             highlighMd, "NONE", "NONE",  "214", "NONE",  "NONE")
highlight("ALEVirtualTextError",        "#ff4444", "NONE", "NONE",  "203", "NONE",  "NONE")

nvim.command [[hi! link ALEVirtualTextInfo  Comment]]
nvim.command [[hi! link StatusLineModified Todo]]
nvim.command [[hi! link Folded DiffChange]]
nvim.command [[hi! link LspDiagnosticsUnderlineError ALEError]]
