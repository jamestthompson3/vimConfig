scriptencoding utf-8

set termguicolors
set nowrap
set cursorline
set number
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set pumheight=15   "limit completion menu height
set scrolloff=1 "minimal number of screen lines to keep above and below the cursor.
set sidescrolloff=5 "same, but with columns
set display+=lastline
set listchars=
set listchars+=tab:░\
set listchars+=trail:·
set listchars+=space:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿
set guicursor+=n:blinkwait60-blinkon175-blinkoff175

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Turn off column numbers if the window is inactive
augroup WINDOWS
  autocmd!
  autocmd WinEnter * set number
  autocmd WinLeave * set nonumber
augroup END

"colorscheme ghost

set statusline+=%#StatusLineModified#%{&mod?expand('%'):''}%*%{&mod?'':expand('%')}%<
set statusline+=%=
set statusline+=%<
set statusline+=\ %{statusline#ReadOnly()}

set showtabline=2
set tabline=ᚴ\ %{git#branch()}

function! s:colors() abort
  hi clear
  syntax reset
  hi Comment gui=italic guifg=#f5ac46 guibg=NONE
  hi VertSplit gui=NONE guifg=#5e5959 guibg=NONE
  hi CursorLineNR gui=NONE guifg=#9c9695 guibg=#222020
  hi CursorLine gui=NONE guifg=NONE guibg=#222020
  hi LineNR gui=NONE guifg=#5e5959 guibg=NONE
  hi Search gui=italic guifg=#16161d guibg=#ff9966
  hi MatchParen gui=bold guifg=#66ccff guibg=#16161d
  hi Normal gui=NONE guifg=#d2cfcf guibg=#16161d
  hi StatusLineNC gui=underline guifg=#5e5959 guibg=NONE
  hi Visual gui=NONE guifg=#16161d guibg=#d2cfcf
  hi Todo gui=bold guifg=White guibg=Magenta
  hi Pmenu gui=NONE guifg=#9c9695 guibg=#171616
  hi PmenuSel gui=NONE guifg=#393636 guibg=#787271
  hi PmenuThumb gui=NONE guifg=NONE guibg=#393636
  hi NormalNC gui=NONE guifg=#5e5959 guibg=NONE
  hi NonText gui=NONE guifg=#353535 guibg=NONE
  hi Whitespace gui=NONE guifg=#353535 guibg=NONE
  hi WildMenu gui=NONE guifg=#16161d guibg=#d2cfcf
  hi SpellBad gui=NONE guifg=Red guibg=NONE
  hi SpellRare gui=NONE guifg=#198cff guibg=NONE

  hi Function         guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic
  hi Identifier       guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic
  hi Include          guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic
  hi Keyword          guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi PreProc          guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Question         guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Number           guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi String           guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Constant         guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi SignColumn       guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi FoldColumn       guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Statement        guifg=NONE     guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi Type             guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Directory        guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Underlined       guifg=NONE     guibg=NONE  gui=underline    ctermfg=NONE  ctermbg=NONE  cterm=underline
  hi Title            guifg=NONE     guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=bold
  hi Special          guifg=NONE     guibg=NONE  gui=italic       ctermfg=NONE  ctermbg=NONE  cterm=italic
  hi ConstStrings     guifg=#198cff  guibg=NONE  gui=bold         ctermfg=NONE  ctermbg=NONE  cterm=NONE
  hi ReturnStatement  guifg=#198cff  guibg=NONE  gui=NONE         ctermfg=NONE  ctermbg=NONE  cterm=NONE


  hi IncSearch      gui=NONE guifg=#d81a4c
  hi QuickFixLine   gui=NONE guibg=#353535
  hi QFNormal       gui=NONE guibg=#222222
  hi QFEndOfBuffer  gui=NONE guifg=#222222
  hi Callout        gui=NONE guifg=#198cff

  hi DiffAdd     guifg=#88aa77  guibg=NONE  gui=NONE       ctermfg=107  ctermbg=NONE  cterm=NONE
  hi DiffDelete  guifg=#aa7766  guibg=NONE  gui=NONE       ctermfg=137  ctermbg=NONE  cterm=NONE
  hi DiffChange  guifg=#7788aa  guibg=NONE  gui=NONE       ctermfg=67   ctermbg=NONE  cterm=NONE
  hi DiffText    guifg=#7788aa  guibg=NONE  gui=underline  ctermfg=67   ctermbg=NONE  cterm=underline

  hi ALEError            guisp=#ff4444 gui=undercurl ctermfg=203 cterm=bold,underline
  hi ALEWarning          guisp=#dd9922 gui=undercurl ctermfg=214 cterm=bold,underline
  hi ALEErrorSign        guifg=#ff4444 ctermfg=203
  hi ALEWarningSign      guifg=#dd9922 ctermfg=214
  hi ALEVirtualTextError guifg=#ff4444 ctermfg=203

  " links
  hi! link ALEVirtualTextInfo  Comment
  hi! link StatusLineModified Todo
  hi! link Folded DiffChange
  hi! link TabLineFill Normal
  hi! link TabLine StatusLine
  hi! link StatusLine Normal

endfunction

au VimEnter * call <SID>colors()
