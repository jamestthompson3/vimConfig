"   __          __
" _/  |_  ____ |  | ____ ___. ____
" \   __\/    \|  |/ |  V   |/    \
"  |  | (  ()  )    < \___  (  ()  )
"  |__|  \____/|__|__\|_____|\____/
"   _____   _____/  |________  ____
"  /     \_/ __ \   __\_  __ \/    \
" |  Y Y  \  ___/|  |  |  | \(  ()  )
" |__|_|__/\____||__|  |__|   \____/
"
"
" File:       tokyo-metro.vim
" Maintainer: koirand <koirand.jp@gmail.com>
" Modified:   2018-08-31 13:19+0900
" License:    MIT


if !has('gui_running') && &t_Co < 256
  finish
endif

set background=dark
hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = expand('<sfile>:t:r')

hi! Args cterm=italic gui=italic  ctermfg=15 guifg=#ffffff
hi! ColorColumn cterm=NONE ctermbg=235 guibg=#1e2132
hi! CursorColumn cterm=NONE ctermbg=235 guibg=#1e2132
hi! CursorLine cterm=NONE ctermbg=235 guibg=#1f2230
hi! Comment ctermfg=243 guifg=#6b7089 gui=italic cterm=italic
hi! Constant ctermfg=141 guifg=#8b76d0
hi! XMLConstant ctermfg=141 guifg=#8b76d0 gui=italic cterm=italic
hi! Cursor ctermbg=252 ctermfg=234 guibg=#abadb3 guifg=#161821
hi! CursorLineNr ctermbg=237 ctermfg=253 guibg=#1f2230 guifg=#cdd1e6
hi! Delimiter ctermfg=252 guifg=#abadb3
hi! DiffAdd ctermbg=130 ctermfg=224 guibg=#47413a guifg=#b0aaa0
hi! DiffChange ctermbg=32 ctermfg=14 guibg=#233e4f guifg=#8ba7b5
hi! DiffDelete ctermbg=124 ctermfg=224 guibg=#53242a guifg=#bb8c90
hi! DiffText cterm=NONE ctermbg=30 ctermfg=195 gui=NONE guibg=#31657d guifg=#abadb3
hi! Directory ctermfg=38 guifg=#4399bb
hi! Error ctermbg=234 ctermfg=196 guibg=#161821 guifg=#e24240
hi! ErrorMsg ctermbg=234 ctermfg=196 guibg=#161821 guifg=#e24240
hi! WarningMsg ctermbg=234 ctermfg=196 guibg=#161821 guifg=#e24240
hi! EndOfBuffer ctermbg=234 ctermfg=236 guibg=#161821 guifg=#242940
hi! NonText ctermbg=235 ctermfg=236 guibg=#1c1e2b guifg=#242940
hi! SpecialKey ctermbg=234 ctermfg=236 guibg=#161821 guifg=#242940
hi! Folded ctermbg=235 ctermfg=245 guibg=#1e2132 guifg=#686f9a
hi! FoldColumn ctermbg=235 ctermfg=239 guibg=#1e2132 guifg=#444b71
hi! Function ctermfg=41 guifg=#56b88a
hi! Identifier cterm=NONE ctermfg=38 guifg=#4399bb
hi! Include ctermfg=41 guifg=#56b88a
hi! LineNr ctermbg=235 ctermfg=239 guibg=#1c1e2b guifg=#393f60 cterm=italic gui=italic
hi! MatchParen ctermbg=237 ctermfg=255 guibg=#3e445e guifg=#ffffff
hi! MoreMsg ctermfg=180 guifg=#bca375
hi! Normal ctermbg=234 ctermfg=252 guibg=#1c1e2b guifg=#abadb3
hi! Operator ctermfg=94 guifg=#91603a
hi! Pmenu ctermbg=236 ctermfg=251 guibg=#212121 guifg=#abadb3
hi! PmenuSbar ctermbg=236 guibg=#3d425b
hi! PmenuSel guibg=#6788cc ctermbg=68 ctermfg=255 guifg=#eff0f4
hi! PmenuThumb ctermbg=251 guibg=#abadb3
hi! PreProc ctermfg=180 guifg=#ae65f2
hi! PreProcItalic ctermfg=180 guifg=#ae65f2 gui=italic cterm=italic
hi! Question ctermfg=180 guifg=#bca375
hi! QuickFixLine ctermbg=236 ctermfg=252 guibg=#272c42 guifg=#abadb3
hi! Search ctermbg=215 ctermfg=234 guibg=#e4b580 guifg=#392713
hi! SignColumn ctermbg=235 ctermfg=239 guibg=#1e2132 guifg=#444b71
hi! Special ctermfg=180 guifg=#bca375
hi! SpellBad ctermbg=124 ctermfg=252 gui=undercurl guisp=#e24240
hi! SpellCap ctermbg=137 ctermfg=252 gui=undercurl guisp=#f19a36
hi! SpellLocal ctermbg=32 ctermfg=252 gui=undercurl guisp=#4399bb
hi! SpellRare ctermbg=61 ctermfg=252 gui=undercurl guisp=#8b76d0
hi! Statement ctermfg=41 gui=NONE  guifg=#56b88a
hi! StatusLineTerm cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#17171b guifg=#818596 term=reverse
hi! StatusLine ctermfg=38 guifg=#4399bb ctermbg=0 guibg=#000000
hi! StatusLineNC ctermbg=235 ctermfg=243 guifg=#6b7089 guibg=#000000 gui=italic cterm=italic
hi! StatusLineTermNC cterm=reverse ctermbg=61 ctermfg=233 gui=reverse guibg=#3e445e guifg=#0f1117
hi! StorageClass ctermfg=41 guifg=#56b88a
hi! String ctermfg=38 guifg=#4399bb
hi! Structure ctermfg=41 guifg=#56b88a
hi! JSSpecial ctermfg=41 guifg=#ffdca5 gui=italic cterm=italic
hi! TabLine cterm=NONE ctermbg=245 ctermfg=234 gui=NONE guibg=#818596 guifg=#17171b
hi! TabLineFill cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#17171b guifg=#818596
hi! TabLineSel cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#161821 guifg=#85878e
hi! Title ctermfg=215 gui=NONE guifg=#f19a36
hi! Todo ctermbg=234 ctermfg=180 guibg=#47413a guifg=#bca375
hi! Type ctermfg=43 gui=NONE guifg=#4da79a
hi! Underlined cterm=underline ctermfg=41 gui=underline guifg=#56b88a term=underline
hi! VertSplit cterm=NONE ctermbg=233 ctermfg=233 gui=NONE guibg=#0f1117 guifg=#0f1117
hi! Visual ctermbg=236 guibg=#373e5e
hi! WildMenu guibg=#6788cc ctermbg=68
hi! diffAdded ctermfg=180 guifg=#bca375
hi! diffRemoved ctermfg=196 guifg=#e24240
hi! ALEErrorSign ctermbg=235 ctermfg=196 guibg=#1e2132 guifg=#e24240
hi! ALEVirtualTextError  ctermfg=196  guifg=#ff9796 cterm=italic gui=italic
hi! ALEVirtualTextWarning ctermfg=215 guifg=#fccf7b cterm=italic gui=italic

hi! link cssBraces Delimiter
hi! link cssClassName Special
hi! link cssClassNameDot Normal
hi! link cssPseudoClassId Special
hi! link cssTagName Statement
hi! link helpHyperTextJump Constant
hi! link htmlArg Constant
hi! link htmlEndTag Statement
hi! link htmlTag Statement
hi! link jsonQuote Normal
hi! link phpVarSelector Identifier
hi! link pythonFunction Title
hi! link rubyDefine Statement
hi! link rubyFunction Title
hi! link rustAttribute Normal
hi! link rustDerive Normal
hi! link rubyInterpolationDelimiter String
hi! link rubySharpBang Comment
hi! link rubyStringDelimiter String
hi! link sassClass Special
hi! link shFunction Normal
hi! link vimContinue Comment
hi! link vimFuncSID vimFunction
hi! link vimFuncVar Normal
hi! link vimFunction Title
hi! link vimGroup Statement
hi! link vimHiGroup Statement
hi! link vimHiTerm Identifier
hi! link vimMapModKey Special
hi! link vimOption Identifier
hi! link vimVar Normal
hi! link xmlAttrib XMLConstant
hi! link htmlArg XMLConstant
hi! link xmlAttribPunct Statement
hi! link xmlEndTag Statement
hi! link xmlNamespace Statement
hi! link xmlTag Statement
hi! link xmlTagName Statement
hi! link yamlKeyValueDelimiter Delimiter
hi! link jsFlowMaybe Normal
hi! link jsFlowClassGroup PreProcItalic
hi! link jsFlowObject Normal
hi! link jsFlowObjectKey Normal
hi! link jsFlowType PreProcItalic
hi! link jsFlowTypeValue PreProcItalic
hi! link jsFlowImportType PreProcItalic
hi! link jsFlowArrow Operator
hi! link jsFlowTypeKeyword PreProcItalic
hi! link jsFlowArgumentDef PreProcItalic
hi! link jsFlowTypeStatement Identifier
hi! link graphqlName Normal
hi! link graphqlOperator Normal
hi! link jsArrowFunction Operator
hi! link jsClassDefinition Normal
hi! link jsDestructuringBraces Comment
hi! link jsFuncParens Comment
hi! link jsClassFuncName Title
hi! link jsExport Statement
hi! link jsImport JSSpecial
hi! link typescriptReserved JSSpecial
hi! link jsModuleAs JSSpecial
hi! link jsExtendsKeyword JSSpecial
hi! link jsFrom JSSpecial
hi! link jsFuncName Title
hi! link jsFuncArgs Args
hi! link jsFuncCall Normal
hi! link jsGlobalObjects Statement
hi! link jsModuleKeywords Statement
hi! link jsModuleOperators Statement
hi! link jsModuleBraces Comment
hi! link jsNull Constant
hi! link jsObjectFuncName Title
hi! link jsObjectKey Identifier
hi! link jsSuper Statement
hi! link jsTemplateBraces Special
hi! link jsUndefined Constant
hi! link markdownBold Special
hi! link markdownCode String
hi! link markdownCodeDelimiter String
hi! link markdownHeadingDelimiter Comment
hi! link markdownRule Comment
hi! link ngxDirective Statement
hi! link svssBraces Delimiter
hi! link swiftIdentifier Normal
hi! link typescriptAjaxMethods Normal
hi! link typescriptBraces Normal
hi! link typescriptEndColons Normal
hi! link typescriptFuncKeyword Statement
hi! link typescriptGlobalObjects Statement
hi! link typescriptHtmlElemProperties Normal
hi! link typescriptIdentifier Statement
hi! link typescriptMessage Normal
hi! link typescriptNull Constant
hi! link typescriptParens Normal

if has('nvim')
  let g:terminal_color_0 = '#1e2132'
  let g:terminal_color_1 = '#e24240'
  let g:terminal_color_2 = '#bca375'
  let g:terminal_color_3 = '#f19a36'
  let g:terminal_color_4 = '#56b88a'
  let g:terminal_color_5 = '#8b76d0'
  let g:terminal_color_6 = '#4399bb'
  let g:terminal_color_7 = '#abadb3'
  let g:terminal_color_8 = '#6b7089'
  let g:terminal_color_9 = '#ea5351'
  let g:terminal_color_10 = '#c8af81'
  let g:terminal_color_11 = '#f7a649'
  let g:terminal_color_12 = '#62c496'
  let g:terminal_color_13 = '#9885da'
  let g:terminal_color_14 = '#4fa5c7'
  let g:terminal_color_15 = '#b5b8c2'
else
  let g:terminal_ansi_colors = ['#1e2132', '#e24240', '#bca375', '#f19a36', '#56b88a', '#8b76d0', '#4399bb', '#abadb3', '#6b7089', '#ea5351', '#c8af81', '#f7a649', '#62c496', '#9885da', '#4fa5c7', '#b5b8c2']
endif
