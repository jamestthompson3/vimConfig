scriptencoding utf-8

" Basics: {{{
if !has('nvim')
  set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
  set background=dark
  set incsearch
  set hlsearch
  set laststatus=2
  if g:isWindows
    set guifont=Iosevka:h10:cANSI:qDRAFT
  elseif has('Mac')
    set guifont=Iosevka\ Term\ Nerd\ Font\ Complete:h11
  else
    set guifont=Iosevka\ 10
  endif
endif

" Turn off column numbers if the window is inactive
augroup WINDOWS
  autocmd!
  autocmd WinEnter * set number
  autocmd WinLeave * set nonumber
augroup END

set termguicolors
set nowrap
set cursorline
set noshowmode
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set pumheight=15   "limit completion menu height
set scrolloff=1 "minimal number of screen lines to keep above and below the cursor.
set sidescrolloff=5 "same, but with columns
set display+=lastline
set listchars= " list chars for showing indentation
set listchars+=tab:░\
set listchars+=trail:·
set listchars+=space:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿

" Custom higlight groups
hi SpellBad guibg=#ff2929 ctermbg=196
hi! link BufTabLineFill NonText
hi! link BufTabLineActive Identifier
hi! link BufTabLineCurrent StatusLine
hi! link BufTabLineHidden Comment
hi! link NormalNC Comment
hi! link Whitespace Comment
colorscheme monotone
" }}}

" Fonts: {{{
let g:enable_italic_font = 1
let g:enable_bold_font = 1
let g:enable_guicolors = 1
" }}}

" Statusline: {{{
set statusline=
set statusline+=%<
set statusline+=\ %m
set statusline+=\ %f
set statusline+=\ %{statusline#ModeCurrent()}
set statusline+=%=
set statusline+=\ %{statusline#MU()}
set statusline+=\ %{statusline#ReadOnly()}
set statusline+=\ %{statusline#LinterStatus()}

"}}}
