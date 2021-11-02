hi clear
syntax reset

let g:colors_name = 'bright'

set background=light

hi Comment gui=italic guifg=#000000 guibg=#aa7766
hi VertSplit gui=none guifg=#5e5959 guibg=none
hi MatchParen gui=none guifg=#121111 guibg=#f5ac46
hi CursorLineNR gui=none guifg=#393636 guibg=#787271
hi CursorLine gui=none guifg=#ffffff guibg=#222020
hi LineNR gui=none guifg=#5e5959 guibg=none
hi Search gui=bold guifg=#121111 guibg=#f5ac46
hi Normal gui=none guifg=#000000 guibg=#ffffff
hi StatusLineNC gui=underline guifg=#5e5959 guibg=none
hi Visual gui=none guifg=#121111 guibg=#d2cfcf
hi Todo gui=bold guifg=White guibg=Magenta
hi Pmenu gui=none guifg=#9c9695 guibg=#171616
hi PmenuSel gui=none guifg=#393636 guibg=#787271
hi PmenuThumb gui=none guifg=none guibg=#393636
hi NormalNC gui=none guifg=#5e5959 guibg=none
hi NonText gui=none guifg=#9b4a3a guibg=none
hi WildMenu gui=none guifg=#121111 guibg=#d2cfcf
hi Folded gui=italic guifg=#d2cfcf guibg=#222020

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

hi! link StatusLineModified Todo

hi QuickFixLine guibg=#333333
hi QFNormal guibg=#222222
hi QFEndOfBuffer guifg=#222222

finish
