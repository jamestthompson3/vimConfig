--
-- built with,
--
--        ,gggg,
--       d8" "8i                         ,dpyb,
--       88  ,dp                         ip'`yb
--    8888888p"                          i8  8i
--       88                              i8  8'
--       88        gg      gg    ,g,     i8 dpgg,
--  ,aa,_88        i8      8i   ,8'8,    i8dp" "8i
-- dp" "88p        i8,    ,8i  ,8'  yb   i8p    i8
-- yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     i8,
--  "y8p"  "y888888p'"y88p"`y8p' "yy8p8p88p     `y8
--

-- this is a starter colorscheme for use with lush,
-- for usage guides, see :h lush or :lushruntutorial

--
-- note: because this is lua file, vim will append your file to the runtime,
--       which means you can require(...) it in other lua code (this is useful),
--       but you should also take care not to conflict with other libraries.
--
--       (this is a lua quirk, as it has somewhat poor support for namespacing.)
--
--       basically, name your file,
--
--       "super_theme/lua/lush_theme/super_theme_dark.lua",
--
--       not,
--
--       "super_theme/lua/dark.lua".
--
--       with that caveat out of the way...
--

-- enable lush.ify on this file, run:
--
--  `:lushify`
--
--  or
--
--  `:lua require('lush').ify()`

local lush = require("lush")
local hsl = lush.hsl

local base0        = hsl("#191c25")
local base1        = hsl("#20222d")
local base2        = hsl("#272935")
local base3        = hsl("#2e313d")
local base4        = hsl("#3c3f4e")
local base5        = hsl("#5b5f71")
local base6        = hsl("#6c6f82")
local base7        = hsl("#b5b4c9")
local base8        = hsl("#f0ecfe")
local red          = hsl("#cf8164")
local green        = hsl("#76a065")
local yellow       = hsl("#ab924c")
local blue         = hsl("#8296b0")
local pink         = hsl("#a18daf")
local cyan         = hsl("#659ea2")
local light_red    = hsl("#fe9f7c")
local light_green  = hsl("#92c47e")
local light_yellow = hsl("#d2b45f")
local light_blue   = hsl("#a0b9d8")
local light_pink   = hsl("#c6aed7")
local light_cyan   = hsl("#7dc2c7")
local red_wash     = hsl("#2d1d16")
local green_wash   = hsl("#1c2316")
local yellow_wash  = hsl("#262011")

local theme = lush(function()
	return {
		-- The following are all the Neovim default highlight groups from the docs
		-- as of 0.5.0-nightly-446, to aid your theme creation. Your themes should
		-- probably style all of these at a bare minimum.
		--
		-- Referenced/linked groups must come before being referenced/lined,
		-- so the order shown ((mostly) alphabetical) is likely
		-- not the order you will end up with.
		--
		-- You can uncomment these and leave them empty to disable any
		-- styling for that group (meaning they mostly get styled as Normal)
		-- or leave them commented to apply vims default colouring or linking.

		Comment         { fg = red.lighten(25), gui = "italic"}, -- any comment
		ColorColumn     { bg = base1 }, -- used for the columns set with 'colorcolumn'
		Conceal         { fg = base5 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
		Cursor          { fg = base0, bg = base8 }, -- character under the cursor
		-- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
		-- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
		CursorColumn { bg = base1 }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
		CursorLine      { bg = base1 }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
		Directory       { fg = blue }, -- directory names (and other special names in listings)
		DiffAdd         { fg = light_green, bg = green_wash }, -- diff mode: Added line |diff.txt|
		DiffChange      { bg = base2 }, -- diff mode: Changed line |diff.txt|
		DiffDelete      { fg = light_red, bg = red_wash }, -- diff mode: Deleted line |diff.txt|
		DiffText        { fg = light_yellow, bg = yellow_wash }, -- diff mode: Changed text within a changed line |diff.txt|
		EndOfBuffer     { Conceal }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
		-- TermCursor   { }, -- cursor in a focused terminal
		-- TermCursorNC { }, -- cursor in an unfocused terminal
		ErrorMsg        { fg = light_red }, -- error messages on the command line
		VertSplit       { fg = base4 }, -- the column separating vertically split windows
		Folded          { fg = base6, bg = base2 }, -- line used for closed folds
		FoldColumn      { fg = base4 }, -- 'foldcolumn'
		SignColumn      { fg = base4 }, -- column where |signs| are displayed
		IncSearch       { fg = base0, bg = base7 }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
		-- Substitute   { }, -- |:substitute| replacement text highlighting
		LineNr          { fg = base5 }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
		CursorLineNr    { fg = base6, bg = base1 }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
		MatchParen      { fg = base8, bg = base3, gui = "bold" }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
		ModeMsg         { fg = base5 }, -- 'showmode' message (e.g., "-- INSERT -- ")
		-- MsgArea      { }, -- Area for messages and cmdline
		-- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
		MoreMsg         { fg = light_blue }, -- |more-prompt|
		NonText         { Conceal }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
		Normal          { fg = base8, bg = base0.darken(35) }, -- normal text
		NormalFloat     { fg = base7, bg = base0 }, -- Normal text in floating windows.
		FloatBorder     { fg = yellow, bg = base1 }, -- Floating border.
		NormalNC        { Normal }, -- normal text in non-current windows
		Pmenu           { fg = base6, bg = base2 }, -- Popup menu: normal item.
		PmenuSel        { fg = base8, bg = base3 }, -- Popup menu: selected item.
		PmenuSbar       { fg= base2, bg = base2   }, -- Popup menu: scrollbar.
		PmenuThumb      { fg = base1, bg = base1 }, -- Popup menu: Thumb of the scrollbar.
		Question        { fg = light_blue }, -- |hit-enter| prompt and yes/no questions
		QuickFixLine    { bg = base3 }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
		Search          { fg = base0, bg = blue }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
		SpecialKey      { Conceal }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
		-- SpellBad     { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
		-- SpellCap     { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
		-- SpellLocal   { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
		-- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
		StatusLine      { fg = base0, bg = base6 }, -- status line of current window
		StatusLineNC    { fg = base5, bg = base2 }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
		TabLine         { StatusLineNC }, -- tab pages line, not active tab page label
		TabLineFill     { StatusLineNC }, -- tab pages line, where there are no labels
		TabLineSel      { StatusLine }, -- tab pages line, active tab page label
		Title           { fg = light_pink }, -- titles for output from ":set all", ":autocmd" etc.
		Visual          { bg = base3 }, -- Visual mode selection
		VisualNOS       { Visual }, -- Visual mode selection when vim is "Not Owning the Selection".
		WarningMsg      { fg = light_yellow }, -- warning messages
		Whitespace      { Conceal }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
		WildMenu        { fg = base0, bg = base7 }, -- current match in 'wildmenu' completion

		-- These groups are not listed as default vim groups,
		-- but they are defacto standard group names for syntax highlighting.
		-- commented out groups should chain up to their "preferred" group by
		-- default,
		-- Uncomment and edit if you want more specific syntax highlighting.

		Constant         { fg = pink }, -- (preferred) any constant
		String           {}, --   a string constant: "this is a string"
		-- Character     { }, --  a character constant: 'c', '\n'
		Number           {}, --   a number constant: 234, 0xff
		-- Boolean       { }, --  a boolean constant: TRUE, false
		-- Float         { }, --    a floating point constant: 2.3e10

		Identifier      {}, -- (preferred) any variable name
		Function        {}, -- function name (also: methods for classes)

		Statement        {}, -- (preferred) any statement
		-- Conditional   { }, --  if, then, else, endif, switch, etc.
		-- Repeat        { }, --   for, do, while, etc.
		-- Label         { }, --    case, default, etc.
		-- Operator      { }, -- "sizeof", "+", "*", etc.
		Keyword({}), -- any other keyword
		-- Exception     { }, --  try, catch, throw

		PreProc          { fg = blue }, -- (preferred) generic Preprocessor
		Include          { PreProc }, --  preprocessor #include
		Define           { PreProc }, --   preprocessor #define
		Macro            { PreProc }, --    same as Define
		PreCondit        { PreProc }, --  preprocessor #if, #else, #endif, etc.

		Type             { fg = pink }, -- (preferred) int, long, char, etc.
		-- StorageClass  { }, -- static, register, volatile, etc.
		-- Structure      { }, --  struct, union, enum, etc.
		-- Typedef        { }, --  A typedef

		Special           { fg = light_cyan }, -- (preferred) any special symbol
		-- SpecialChar    { }, --  special character in a constant
		-- Tag            { }, --    you can use CTRL-] on this
		-- Delimiter      { }, --  character that needs attention
		SpecialComment    { fg = base8, gui = "bold" }, -- special things inside a comment
		-- Debug          { }, --    debugging statements

		Underlined { fg = blue, gui = "underline" }, -- (preferred) text that stands out, HTML links
		Bold       { gui = "bold" },
		Italic     { gui = "italic" },

		-- ("Ignore", below, may be invisible...)
		-- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

		-- Error          { }, -- (preferred) any erroneous construct

		Todo             { fg = base0, bg = light_blue }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
		-- Custom Groups
		ExtraWhitespace  { fg = light_cyan },
		Callout          { fg = light_blue },
    GitLens          { Conceal  },

		-- These groups are for the native LSP client. Some other LSP clients may
		-- use these groups, or use their own. Consult your LSP client's
		-- documentation.

		-- LspReferenceText  { fg = royalpurple }, -- used for highlighting "text" references
		-- LspReferenceRead  { fg = royalpurple }, -- used for highlighting "read" references
		-- LspReferenceWrite { fg = royalpurple }, -- used for highlighting "write" references

		LspDiagnosticsDefaultError       { ErrorMsg }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultWarning     { WarningMsg }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultInformation { fg = light_blue }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultHint        { fg = light_cyan }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

		-- LspDiagnosticsVirtualTextError       { }, -- Used for "Error" diagnostic virtual text
		-- LspDiagnosticsVirtualTextWarning     { }, -- Used for "Warning" diagnostic virtual text
		-- LspDiagnosticsVirtualTextInformation { }, -- Used for "Information" diagnostic virtual text
		-- LspDiagnosticsVirtualTextHint        { }, -- Used for "Hint" diagnostic virtual text

		-- LspDiagnosticsUnderlineError         { }, -- Used to underline "Error" diagnostics
		-- LspDiagnosticsUnderlineWarning       { }, -- Used to underline "Warning" diagnostics
		-- LspDiagnosticsUnderlineInformation   { }, -- Used to underline "Information" diagnostics
		-- LspDiagnosticsUnderlineHint          { }, -- Used to underline "Hint" diagnostics

		-- LspDiagnosticsFloatingError          { }, -- Used to color "Error" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingWarning        { }, -- Used to color "Warning" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingInformation    { }, -- Used to color "Information" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingHint           { }, -- Used to color "Hint" diagnostic messages in diagnostics float

		LspDiagnosticsSignError              { ErrorMsg }, -- Used for "Error" signs in sign column
		LspDiagnosticsSignWarning            { WarningMsg }, -- Used for "Warning" signs in sign column
		LspDiagnosticsSignInformation        { fg = light_blue }, -- Used for "Information" signs in sign column
		LspDiagnosticsSignHint               { fg = light_cyan }, -- Used for "Hint" signs in sign column

		-- These groups are for the neovim tree-sitter highlights.
		-- As of writing, tree-sitter support is a WIP, group names may change.
		-- By default, most of these groups link to an appropriate Vim group,
		-- TSError -> Error for example, so you do not have to define these unless
		-- you explicitly want to support Treesitter's improved syntax awareness.

		-- TSAnnotation            { };    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
		-- TSAttribute          { };    -- (unstable) TODO: docs
		-- TSBoolean            { };    -- For booleans.
		-- TSCharacter          { };    -- For characters.
		TSComment            { Comment };    -- For comment blocks.
		TSDanger             { Todo };    -- For comment blocks.
		-- TSConstructor        {};    -- For constructor calls and definitions: ` { }` in Lua, and Java constructors.
		-- TSConditional        { };    -- For keywords related to conditionnals.
		-- TSConstant           { };    -- For constants
		-- TSConstBuiltin       { };    -- For constant that are built in the language: `nil` in Lua.
		-- TSConstMacro         { };    -- For constants that are defined by macros: `NULL` in C.
		-- TSError              { };    -- For syntax/parser errors.
		-- TSException          { };    -- For exception related keywords.
		-- TSField              { };    -- For fields.
		-- TSFloat              { };    -- For floats.
		TSFunction              { fg = pink }, -- For function (calls and definitions).
		-- TSFuncBuiltin        { };    -- For builtin functions: `table.insert` in Lua.
		-- TSFuncMacro          { };    -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
		-- TSInclude            { };    -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
		-- TSKeyword            { };    -- For keywords that don't fall in previous categories.
		-- TSKeywordFunction    { };    -- For keywords used to define a fuction.
		-- TSLabel              { };    -- For labels: `label:` in C and `:label:` in Lua.
		TSMethod                { fg = pink }, -- For method calls and definitions.
		-- TSNamespace          { };    -- For identifiers referring to modules and namespaces.
		-- TSNone               { };    -- TODO: docs
		-- TSNumber             { };    -- For all numbers
		TSOperator              { fg = cyan }, -- For any operator: `+`, but also `->` and `*` in C.
		-- TSParameter          { };    -- For parameters of a function.
		-- TSParameterReference { };    -- For references to parameters of a function.
		-- TSProperty           { };    -- Same as `TSField`.
		-- TSPunctDelimiter     { };    -- For delimiters ie: `.`
		TSPunctBracket          { fg = base5 }, -- For brackets and parens.
		-- TSPunctSpecial       { };    -- For special punctutation that does not fall in the catagories before.
		-- TSRepeat             { };    -- For keywords related to loops.
		-- TSString             { };    -- For strings.
		-- TSStringRegex        { };    -- For regexes.
		-- TSStringEscape       { };    -- For escape characters within a string.
		-- TSSymbol             { };    -- For identifiers referring to symbols or atoms.
		TSType                  { Type }, -- For types.
		TSTypeBuiltin           { gui = "bold", fg = blue }, -- For builtin types.
		-- TSVariable           { };    -- Any variable name that does not have another highlight.
		-- TSVariableBuiltin    { };    -- Variable names that are defined by the languages, like `this` or `self`.

		TSTag                   { fg = green }, -- Tags like html tag names.
		-- TSTagDelimiter       { };    -- Tag delimiter like `<` `>` `/`
		-- TSText               { };    -- For strings considered text in a markup language.
		-- TSEmphasis           { };    -- For text to be represented with emphasis.
		-- TSUnderline          { };    -- For text to be represented with an underline.
		-- TSStrike             { };    -- For strikethrough text.
		-- TSTitle              { };    -- Text that is part of a title.
		-- TSLiteral            { };    -- Literal text.
		-- TSURI                { };    -- Any URI like a link or email.
	}
end)

-- return our parsed theme for extension or use else where.
return theme
