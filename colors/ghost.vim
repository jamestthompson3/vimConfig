hi clear
syntax reset

let g:colors_name = 'ghost'

hi Comment gui=italic guifg=#f5ac46 guibg=NONE
hi VertSplit gui=NONE guifg=#5e5959 guibg=NONE
hi MatchParen gui=NONE guifg=#121111 guibg=#f5ac46
hi CursorLineNR gui=NONE guifg=#9c9695 guibg=#222020
hi CursorLine gui=NONE guifg=NONE guibg=#222020
hi LineNR gui=NONE guifg=#5e5959 guibg=NONE
hi Search gui=bold guifg=#121111 guibg=#f5ac46
hi MatchParen gui=bold guifg=#f5ac46 guibg=#121111
hi Normal gui=NONE guifg=#d2cfcf guibg=#121111
hi StatusLineNC gui=underline guifg=#5e5959 guibg=NONE
hi Visual gui=NONE guifg=#121111 guibg=#d2cfcf
hi Todo gui=bold guifg=White guibg=Magenta
hi Pmenu gui=NONE guifg=#9c9695 guibg=#171616
hi PmenuSel gui=NONE guifg=#393636 guibg=#787271
hi PmenuThumb gui=NONE guifg=NONE guibg=#393636
hi NormalNC gui=NONE guifg=#5e5959 guibg=NONE
hi NonText gui=NONE guifg=#9b4a3a guibg=NONE
hi WildMenu gui=NONE guifg=#121111 guibg=#d2cfcf
hi Folded gui=italic guifg=#d2cfcf guibg=#222020
hi SpellBad gui=NONE guifg=Red guibg=NONE
hi SpellRare gui=NONE guifg=#198cff guibg=NONE

hi Function     guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic
hi Identifier   guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic
hi Include      guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic
hi Keyword      guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
hi PreProc      guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
hi Question     guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi Number       guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi String       guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi SignColumn   guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi FoldColumn   guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi Constant     guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi Statement    guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi Type         guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
hi Directory    guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
hi Underlined   guifg=NONE     guibg=NONE  gui=underline    ctermfg=NONE  ctermbg=NONE  cterm=underline
hi Title        guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
hi Special      guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic

hi DiffAdd     guifg=#88aa77  guibg=NONE  gui=NONE       ctermfg=107  ctermbg=NONE  cterm=NONE
hi DiffDelete  guifg=#aa7766  guibg=NONE  gui=NONE       ctermfg=137  ctermbg=NONE  cterm=NONE
hi DiffChange  guifg=#7788aa  guibg=NONE  gui=NONE       ctermfg=67   ctermbg=NONE  cterm=NONE
hi DiffText    guifg=#7788aa  guibg=NONE  gui=underline  ctermfg=67   ctermbg=NONE  cterm=underline

hi ALEError            guisp=#ff4444 gui=undercurl ctermfg=203 cterm=bold,underline
hi ALEWarning          guisp=#dd9922 gui=undercurl ctermfg=214 cterm=bold,underline
hi ALEErrorSign        guifg=#ff4444 ctermfg=203
hi ALEWarningSign      guifg=#dd9922 ctermfg=214
hi ALEVirtualTextError guifg=#ff4444 ctermfg=203
hi! link ALEVirtualTextInfo  Comment

hi! link StatusLineModified Todo

hi QuickFixLine guibg=#333333
hi QFNormal guibg=#222222
hi QFEndOfBuffer guifg=#222222

finish
