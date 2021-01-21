highlight clear

if exists("syntax_on")
  syntax reset
endif
if exists("colors_name")
  finish
endif
let g:colors_name = 'ghost_mono'


highlight Comment          guifg=#b5ae7d       guibg=#393636       gui=NONE       ctermfg=215    ctermbg=NONE   cterm=NONE
highlight VertSplit        guifg=#818e8e       guibg=NONE          gui=NONE       ctermfg=240    ctermbg=NONE   cterm=NONE
highlight CursorLineNR     guifg=NONE          guibg=NONE          gui=NONE       ctermfg=247    ctermbg=236    cterm=NONE
highlight Cursor           guifg=#2f2f30       guibg=#198cff       gui=NONE       ctermfg=247    ctermbg=236    cterm=NONE
highlight CursorLine       guifg=NONE          guibg=#2f343f       gui=NONE       ctermfg=NONE   ctermbg=236    cterm=NONE
highlight LineNR           guifg=#818e8e       guibg=NONE          gui=NONE       ctermfg=238    ctermbg=NONE   cterm=NONE
highlight Search           guifg=#121217       guibg=#1fff5c       gui=italic     ctermfg=0      ctermbg=172    cterm=NONE
highlight MatchParen       guifg=#2de2e6       guibg=#121217       gui=bold       ctermfg=81     ctermbg=NONE   cterm=NONE
highlight MatchWord        guifg=#2de2e6       guibg=#121217       gui=bold       ctermfg=81     ctermbg=NONE   cterm=NONE
highlight Normal           guifg=#d2cfcf       guibg=Black         gui=NONE       ctermfg=255    ctermbg=NONE   cterm=NONE
highlight NormalNC         guifg=#d2cfcf       guibg=#0b0d0f       gui=NONE       ctermfg=240    ctermbg=NONE   cterm=NONE
" highlight NormalFloat      guifg=Black         guibg=#818e8e       gui=NONE       ctermfg=240    ctermbg=NONE   cterm=NONE
highlight GitLens          guifg=#818e8e       guibg=NONE          gui=NONE       ctermfg=255    ctermbg=NONE   cterm=NONE
highlight TabLineFill      guifg=#d2cfcf       guibg=#000000       gui=NONE       ctermfg=255    ctermbg=NONE   cterm=NONE
highlight StatusLine       guifg=#818e8e       guibg=NONE          gui=underline  ctermfg=238    ctermbg=NONE   cterm=underline
highlight StatusLineNc     guifg=#d2cfcf       guibg=#121217       gui=NONE       ctermfg=255    ctermbg=0      cterm=NONE
highlight TabLine          guifg=#d2cfcf       guibg=#000000       gui=NONE       ctermfg=255    ctermbg=0      cterm=NONE
highlight Visual           guifg=#F0C30D       guibg=#787271       gui=NONE       ctermfg=NONE   ctermbg=NONE   cterm=NONE
highlight Todo             guifg=White         guibg=#711283       gui=bold       ctermfg=15     ctermbg=201    cterm=NONE
highlight Pmenu            guifg=#9c9695       guibg=#171616       gui=NONE       ctermfg=249    ctermbg=232    cterm=NONE
highlight PmenuSel         guifg=#393636       guibg=#787271       gui=NONE       ctermfg=237    ctermbg=250    cterm=NONE
highlight PmenuThumb       guifg=NONE          guibg=#393636       gui=NONE       ctermfg=NONE   ctermbg=NONE   cterm=NONE
highlight NonText          guifg=#ffce5b       guibg=NONE          gui=NONE       ctermfg=237    ctermbg=NONE   cterm=NONE
highlight Whitespace       guifg=#2f343f       guibg=NONE          gui=NONE       ctermfg=237    ctermbg=NONE   cterm=NONE
highlight WildMenu         guifg=#121217       guibg=#d2cfcf       gui=NONE       ctermfg=NONE   ctermbg=NONE   cterm=NONE
highlight SpellBad         guifg=Red           guibg=NONE          gui=NONE       ctermfg=9      ctermbg=NONE   cterm=NONE
highlight SpellRare        guifg=#198cff       guibg=NONE          gui=NONE       ctermfg=12     ctermbg=NONE   cterm=NONE
highlight TabLineFill      guifg=Black         guibg=#005f5f       gui=NONE       ctermfg=0      ctermbg=23     cterm=NONE

highlight Function         guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=italic
highlight Identifier       guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Include          guifg=NONE         guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=bold
highlight Keyword          guifg=NONE         guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight PreProc          guifg=Magenta      guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Macro            guifg=White        guibg=Black    gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Question         guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Number           guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight String           guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Constant         guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight SignColumn       guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight FoldColumn       guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Statement        guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Type             guifg=NONE         guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Directory        guifg=NONE         guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Underlined       guifg=NONE         guibg=NONE     gui=underline  ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight Title            guifg=#fb7da7      guibg=NONE     gui=bold       ctermfg=15    ctermbg=NONE  cterm=NONE
highlight Special          guifg=NONE         guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=italic
highlight ConstStrings     guifg=#198cff      guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight ReturnStatement  guifg=#198cff      guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE

highlight IncSearch        guifg=#1fff5c         guibg=NONE      gui=NONE       ctermfg=161    ctermbg=NONE    cterm=NONE
highlight QuickFixLine     guifg=#bc6b01         guibg=NONE      gui=NONE       ctermfg=249    ctermbg=239     cterm=NONE
highlight QFNormal         guifg=#222222         guibg=NONE      gui=NONE       ctermfg=NONE   ctermbg=235     cterm=NONE
highlight QFEndOfBuffer    guifg=#222222         guibg=NONE      gui=NONE       ctermfg=NONE   ctermbg=235     cterm=NONE
highlight DiffAdd          guifg=#88aa77         guibg=NONE      gui=NONE       ctermfg=107    ctermbg=NONE    cterm=NONE
highlight DiffDelete       guifg=#aa7766         guibg=NONE      gui=NONE       ctermfg=137    ctermbg=NONE    cterm=NONE
highlight DiffChange       guifg=#7788aa         guibg=NONE      gui=NONE       ctermfg=67     ctermbg=NONE    cterm=NONE
highlight DiffText         guifg=#7788aa         guibg=NONE      gui=underline  ctermfg=67     ctermbg=NONE    cterm=NONE

" Custom groups
highlight CodeBlock                  guifg=#88aa77     guibg=NONE     gui=NONE       ctermfg=12   ctermbg=NONE  cterm=NONE
highlight BlockQuote                 guifg=#648c9c     guibg=NONE     gui=NONE       ctermfg=12   ctermbg=NONE  cterm=NONE
highlight Callout                    guifg=#198cff     guibg=NONE     gui=NONE       ctermfg=12   ctermbg=NONE  cterm=NONE
highlight ALEError                   guifg=#ff4444     guibg=NONE     gui=undercurl  ctermfg=0    ctermbg=203   cterm=NONE
highlight ALEInfo                    guifg=Black       guibg=White    gui=NONE       ctermfg=0    ctermbg=215   cterm=NONE
highlight ALEWarning                 guifg=#F0C30D     guibg=NONE    gui=undercurl  ctermfg=0    ctermbg=214   cterm=NONE
highlight LspDiagnosticsError        guifg=#ff4444     guibg=NONE     gui=NONE       ctermfg=203  ctermbg=NONE  cterm=NONE
highlight LspDiagnosticsWarning      guifg=#F0C30D     guibg=NONE     gui=NONE       ctermfg=214  ctermbg=NONE  cterm=NONE
highlight LspDiagnosticsInformation  guifg=#0000ff     guibg=NONE     gui=NONE       ctermfg=12   ctermbg=NONE  cterm=NONE
highlight LspDiagnosticsHint         guifg=#00afaf     guibg=NONE     gui=NONE       ctermfg=37   ctermbg=NONE  cterm=NONE
highlight ALEErrorSign               guifg=#ff4444     guibg=NONE     gui=NONE       ctermfg=203  ctermbg=NONE  cterm=NONE
highlight ALEWarningSign             guifg=#F0C30D     guibg=NONE     gui=NONE       ctermfg=214  ctermbg=NONE  cterm=NONE
highlight ALEVirtualTextError        guifg=Black       guibg=#ff4444  gui=NONE       ctermfg=0    ctermbg=203   cterm=NONE
highlight ALEVirtualTextWarning      guifg=Black       guibg=#F0C30D  gui=NONE       ctermfg=0    ctermbg=203   cterm=NONE

" Language specific groups
highlight typescriptCommentTodo          guifg=#F0C30D     guibg=White    gui=NONE      ctermfg=107   ctermbg=NONE    cterm=NONE
highlight typescriptPromiseMethod        guifg=#198cff     guibg=NONE     gui=NONE      ctermfg=107   ctermbg=NONE    cterm=NONE
highlight typescriptPromiseStaticMethod  guifg=#198cff     guibg=NONE     gui=NONE      ctermfg=107   ctermbg=NONE    cterm=NONE
highlight typescriptES6SetMethod         guifg=#198cff     guibg=NONE     gui=NONE      ctermfg=107   ctermbg=NONE    cterm=NONE
highlight typescriptParens               guifg=#818e8e     guibg=NONE     gui=NONE      ctermfg=236   ctermbg=NONE    cterm=italic
highlight typescriptBraces               guifg=#818e8e     guibg=NONE     gui=NONE      ctermfg=236   ctermbg=NONE    cterm=italic
highlight tsxTag                         guifg=#F0C30D     guibg=NONE     gui=NONE      ctermfg=215   ctermbg=NONE    cterm=NONE
highlight tsxCloseTag                    guifg=#b5ae7d     guibg=NONE     gui=NONE      ctermfg=215   ctermbg=NONE    cterm=NONE
highlight tsxAttrib                      guifg=White       guibg=NONE     gui=bold      ctermfg=144   ctermbg=NONE    cterm=NONE
highlight tsxTagName                     guifg=#648c9c     guibg=NONE     gui=NONE      ctermfg=12    ctermbg=NONE    cterm=NONE
highlight scalaInstanceDeclaration       guifg=#648c9c     guibg=NONE     gui=NONE      ctermfg=NONE  ctermbg=NONE    cterm=italic
highlight scalaNameDefinition            guifg=#9e3c3c     guibg=NONE     gui=NONE      ctermfg=137   ctermbg=NONE    cterm=NONE
highlight scalaTypeDefinition            guifg=#88aa77     guibg=NONE     gui=NONE      ctermfg=NONE  ctermbg=NONE    cterm=NONE
" highlight scalaBlock                     guifg=#7788aa     guibg=NONE     gui=NONE      ctermfg=NONE  ctermbg=NONE    cterm=italic
highlight scalaSpecial                   guifg=#d2cfcf     guibg=#121217  gui=italic    ctermfg=255   ctermbg=NONE    cterm=italic

" Treesitter
highlight TSConstructor    guifg=#72ffcf     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=italic
highlight TSType           guifg=#61b5a4     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
highlight TSMethod         guifg=#7788aa     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=italic
highlight TSOperator       guifg=#b5ae7d     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=italic
highlight TSPunctBracket   guifg=#818e8e     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=italic
highlight TSFunction       guifg=#7244cf     guibg=NONE     gui=NONE       ctermfg=137   ctermbg=NONE  cterm=NONE
highlight TSCurrentScope   guifg=NONE        guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE

" Links
hi! link StatusLineModified   Todo
hi! link Folded               DiffChange
hi! link typescriptCall       Normal
hi! link AllTodo              Todo
hi! link typescriptParamImpl  Statement
