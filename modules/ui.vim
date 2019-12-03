scriptencoding utf-8

set listchars=
set listchars+=tab:░\
set listchars+=trail:·
set listchars+=space:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set statusline+=%#StatusLineModified#%{&mod?expand('%'):''}%*%{&mod?'':expand('%')}%<
set statusline+=%=
set statusline+=%<
set statusline+=%#MatchParen#%{statusline#LineNoIndicator()}%*\ %{statusline#ReadOnly()}

set showtabline=2
set tabline=ᚴ\ %{git#branch()}

function! s:colors() abort
  hi clear
  syntax reset
  hi Comment          guifg=#f5ac46  guibg=NONE     gui=italic      ctermfg=215    ctermbg=NONE cterm=NONE
  hi VertSplit        guifg=#5e5959  guibg=NONE     gui=NONE        ctermfg=240    ctermbg=NONE cterm=NONE
  hi CursorLineNR     guifg=#9c9695  guibg=#222020  gui=NONE        ctermfg=247    ctermbg=236  cterm=NONE
  hi CursorLine       guifg=NONE     guibg=#222020  gui=NONE        ctermfg=NONE   ctermbg=236  cterm=NONE
  hi LineNR           guifg=#5e5959  guibg=NONE     gui=NONE        ctermfg=238    ctermbg=NONE cterm=NONE
  hi Search           guifg=#16161d  guibg=#ff9966  gui=italic      ctermfg=0      ctermbg=172  cterm=italic
  hi MatchParen       guifg=#66ccff  guibg=#16161d  gui=bold        ctermfg=81     ctermbg=NONE cterm=bold
  hi NormalFloat      guifg=#66ccff  guibg=#16161d  gui=NONE        ctermfg=81     ctermbg=NONE cterm=NONE
  hi Normal           guifg=#d2cfcf  guibg=#16161d  gui=NONE        ctermfg=255    ctermbg=NONE cterm=NONE
  hi StatusLineNC     guifg=#5e5959  guibg=NONE     gui=underline   ctermfg=238    ctermbg=NONE cterm=underline
  hi StatusLine       guifg=#d2cfcf  guibg=#16161d  gui=NONE        ctermfg=255    ctermbg=0    cterm=NONE
  hi Visual           guifg=#16161d  guibg=#d2cfcf  gui=NONE        ctermfg=NONE   ctermbg=NONE cterm=NONE
  hi Todo             guifg=White    guibg=Magenta  gui=bold        ctermfg=15     ctermbg=201  cterm=bold
  hi Pmenu            guifg=#9c9695  guibg=#171616  gui=NONE        ctermfg=249    ctermbg=232  cterm=NONE
  hi PmenuSel         guifg=#393636  guibg=#787271  gui=NONE        ctermfg=237    ctermbg=250  cterm=NONE
  hi PmenuThumb       guifg=NONE     guibg=#393636  gui=NONE        ctermfg=NONE   ctermbg=NONE cterm=NONE
  hi NormalNC         guifg=#5e5959  guibg=NONE     gui=NONE        ctermfg=240    ctermbg=NONE cterm=NONE
  hi NonText          guifg=#353535  guibg=NONE     gui=NONE        ctermfg=237    ctermbg=NONE cterm=NONE
  hi Whitespace       guifg=#353535  guibg=NONE     gui=NONE        ctermfg=237    ctermbg=NONE cterm=NONE
  hi WildMenu         guifg=#16161d  guibg=#d2cfcf  gui=NONE        ctermfg=NONE   ctermbg=NONE cterm=NONE
  hi SpellBad         guifg=Red      guibg=NONE     gui=NONE        ctermfg=9      ctermbg=NONE cterm=NONE
  hi SpellRare        guifg=#198cff  guibg=NONE     gui=NONE        ctermfg=12     ctermbg=NONE cterm=NONE

  hi Function         guifg=NONE     guibg=NONE     gui=italic     ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Identifier       guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Include          guifg=NONE     guibg=NONE     gui=italic     ctermfg=NONE  ctermbg=NONE  cterm=italic
  hi Keyword          guifg=NONE     guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi PreProc          guifg=NONE     guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Question         guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Number           guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi String           guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Constant         guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi SignColumn       guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi FoldColumn       guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Statement        guifg=NONE     guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Type             guifg=NONE     guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Directory        guifg=NONE     guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Underlined       guifg=NONE     guibg=NONE     gui=underline  ctermfg=NONE  ctermbg=NONE  cterm=underline
  hi Title            guifg=NONE     guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Special          guifg=NONE     guibg=NONE     gui=italic     ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi ConstStrings     guifg=#198cff  guibg=NONE     gui=bold       ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi ReturnStatement  guifg=#198cff  guibg=NONE     gui=NONE       ctermfg=NONE  ctermbg=NONE  cterm=NONE


  hi IncSearch        guifg=#d81a4c guibg=NONE      gui=NONE       ctermfg=161   ctermbg=NONE  cterm=NONE
  hi QuickFixLine     guibg=#353535 guibg=NONE      gui=NONE       ctermfg=249   ctermbg=239   cterm=NONE
  hi QFNormal         guibg=#222222 guibg=NONE      gui=NONE       ctermfg=NONE  ctermbg=235   cterm=NONE
  hi QFEndOfBuffer    guifg=#222222 guibg=NONE      gui=NONE       ctermfg=NONE  ctermbg=235   cterm=NONE
  hi Callout          guifg=#198cff guibg=NONE      gui=NONE       ctermfg=12    ctermbg=NONE  cterm=NONE

  hi DiffAdd          guifg=#88aa77 guibg=NONE  gui=NONE           ctermfg=107   ctermbg=NONE  cterm=NONE
  hi DiffDelete       guifg=#aa7766 guibg=NONE  gui=NONE           ctermfg=137   ctermbg=NONE  cterm=NONE
  hi DiffChange       guifg=#7788aa guibg=NONE  gui=NONE           ctermfg=67    ctermbg=NONE  cterm=NONE
  hi DiffText         guifg=#7788aa guibg=NONE  gui=underline      ctermfg=67    ctermbg=NONE  cterm=underline

  hi ALEError                   guifg=#ff4444 gui=undercurl ctermfg=203  ctermbg=NONE cterm=bold,underline
  hi ALEWarning                 guifg=#dd9922 gui=undercurl ctermfg=214  ctermbg=NONE cterm=bold,underline
  hi LspDiagnosticsError        guifg=#ff4444 gui=NONE      ctermfg=203  ctermbg=NONE cterm=NONE
  hi LspDiagnosticsWarning      guifg=#dd9922 gui=NONE      ctermfg=214  ctermbg=NONE cterm=NONE
  hi LspDiagnosticsInformation  guifg=#0000ff gui=NONE      ctermfg=12   ctermbg=NONE cterm=NONE
  hi LspDiagnosticsHint         guifg=#00afaf gui=NONE      ctermfg=37   ctermbg=NONE cterm=NONE
  hi ALEErrorSign               guifg=#ff4444 gui=NONE      ctermfg=203 ctermbg=NONE  cterm=NONE
  hi ALEWarningSign             guifg=#dd9922 gui=NONE      ctermfg=214 ctermbg=NONE  cterm=NONE
  hi ALEVirtualTextError        guifg=#ff4444 gui=NONE      ctermfg=203 ctermbg=NONE  cterm=NONE

  " links
  hi! link ALEVirtualTextInfo  Comment
  hi! link StatusLineModified Todo
  hi! link Folded DiffChange
  hi! link TabLineFill Normal
  hi! link TabLine StatusLine

endfunction

au VimEnter * call <SID>colors()
